-- InventoryUI.client.lua
-- Sistema completo de UI del inventario moderno con pestañas

print("🎒 INICIANDO SISTEMA DE INVENTARIO MODERNO...")

-- ============================================================================
-- SERVICIOS Y MÓDULOS
-- ============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Esperar a que los módulos estén disponibles
local Modules = ReplicatedStorage:WaitForChild("Modules")
local UIComponents = require(Modules:WaitForChild("UIComponents"))

-- ============================================================================
-- VARIABLES GLOBALES
-- ============================================================================

local inventoryGui = nil
local mainFrame = nil
local isOpen = false
local currentTab = "Inventory"
local currentInventory = nil
local currentRecipes = {}
local draggedSlot = nil
local dragIcon = nil
local activeTooltip = nil
local tooltipConnection = nil
local currentFilter = "All"
local searchQuery = ""

-- Referencias a pestañas
local tabFrames = {}
local tabButtons = {}

-- ============================================================================
-- EVENTOS REMOTOS
-- ============================================================================

-- Esperar a que los eventos remotos estén listos
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents", 10)
if not remoteEvents then
	warn("⚠️ RemoteEvents no encontrado")
	return
end

local inventoryEvents = remoteEvents:WaitForChild("InventoryEvents", 10)
if not inventoryEvents then
	warn("⚠️ InventoryEvents no encontrado")
	return
end

local updateInventoryEvent = inventoryEvents:WaitForChild("UpdateInventory", 10)
local moveItemEvent = inventoryEvents:WaitForChild("MoveItem", 10)
local useItemEvent = inventoryEvents:WaitForChild("UseItem", 10)
local craftItemEvent = inventoryEvents:WaitForChild("CraftItem", 10)
local fuseItemsEvent = inventoryEvents:WaitForChild("FuseItems", 10)
local getRecipesEvent = inventoryEvents:WaitForChild("GetRecipes", 10)
local updateRecipesEvent = inventoryEvents:WaitForChild("UpdateRecipes", 10)

-- ============================================================================
-- FUNCIONES DE CREACIÓN DE UI
-- ============================================================================

-- Crear ScreenGui principal
local function createMainScreenGui()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ModernInventoryGui"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.DisplayOrder = 10  -- Encima de las barras de vida/estamina
	screenGui.Parent = playerGui
	
	return screenGui
end

-- Crear frame principal del inventario
local function createMainFrame(parent)
	local frame = Instance.new("Frame")
	frame.Name = "MainFrame"
	frame.Size = UDim2.new(0, 800, 0, 600)
	frame.Position = UDim2.new(0.5, -400, 0.5, -300)
	frame.BackgroundColor3 = UIComponents.Colors.Background
	frame.BackgroundTransparency = 0.05
	frame.BorderSizePixel = 0
	frame.Visible = false
	frame.Parent = parent
	
	UIComponents.CreateCorner(frame, 12)
	UIComponents.CreateStroke(frame, UIComponents.Colors.Primary, 2)
	
	return frame
end

-- Crear header con título y botón cerrar
local function createHeader(parent)
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 50)
	header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	header.BorderSizePixel = 0
	header.Parent = parent
	
	UIComponents.CreateCorner(header, 12)
	
	-- Título
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(0, 300, 1, 0)
	title.Position = UDim2.new(0, 20, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "🎒 INVENTARIO"
	title.TextColor3 = UIComponents.Colors.Text
	title.TextSize = 24
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header
	
	-- Botón cerrar
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 35, 0, 35)
	closeButton.Position = UDim2.new(1, -45, 0.5, -17.5)
	closeButton.BackgroundColor3 = UIComponents.Colors.Error
	closeButton.BorderSizePixel = 0
	closeButton.Text = "✕"
	closeButton.TextColor3 = UIComponents.Colors.Text
	closeButton.TextSize = 20
	closeButton.Font = Enum.Font.GothamBold
	closeButton.AutoButtonColor = false
	closeButton.Parent = header
	
	UIComponents.CreateCorner(closeButton, 6)
	
	-- Efectos hover
	closeButton.MouseEnter:Connect(function()
		TweenService:Create(closeButton, UIComponents.TweenInfo.Fast, {
			BackgroundColor3 = Color3.fromRGB(255, 100, 100)
		}):Play()
	end)
	
	closeButton.MouseLeave:Connect(function()
		TweenService:Create(closeButton, UIComponents.TweenInfo.Fast, {
			BackgroundColor3 = UIComponents.Colors.Error
		}):Play()
	end)
	
	closeButton.MouseButton1Click:Connect(function()
		closeInventory()
	end)
	
	return header
end

-- Crear sistema de pestañas
local function createTabSystem(parent)
	local tabContainer = Instance.new("Frame")
	tabContainer.Name = "TabContainer"
	tabContainer.Size = UDim2.new(1, -40, 0, 45)
	tabContainer.Position = UDim2.new(0, 20, 0, 60)
	tabContainer.BackgroundTransparency = 1
	tabContainer.Parent = parent
	
	local tabs = {"Inventario", "Crafteo", "Fusión"}
	
	for i, tabName in ipairs(tabs) do
		local tab = UIComponents.CreateTab(tabContainer, tabName, i, #tabs)
		tabButtons[tabName] = tab
		
		tab.MouseButton1Click:Connect(function()
			switchTab(tabName)
		end)
	end
	
	return tabContainer
end

-- Crear pestaña de inventario
local function createInventoryTab(parent)
	local inventoryFrame = Instance.new("Frame")
	inventoryFrame.Name = "InventoryTab"
	inventoryFrame.Size = UDim2.new(1, -40, 1, -165)
	inventoryFrame.Position = UDim2.new(0, 20, 0, 115)
	inventoryFrame.BackgroundTransparency = 1
	inventoryFrame.Visible = true
	inventoryFrame.Parent = parent
	
	-- Barra de búsqueda y filtros
	local searchBox = UIComponents.CreateSearchBox(inventoryFrame, UDim2.new(0, 300, 0, 35), UDim2.new(0, 0, 0, 0))
	
	searchBox.Changed:Connect(function(property)
		if property == "Text" then
			searchQuery = searchBox.Text:lower()
			updateInventoryDisplay()
		end
	end)
	
	-- Filtros de categoría
	local filterFrame = Instance.new("Frame")
	filterFrame.Name = "FilterFrame"
	filterFrame.Size = UDim2.new(1, -320, 0, 35)
	filterFrame.Position = UDim2.new(0, 310, 0, 0)
	filterFrame.BackgroundTransparency = 1
	filterFrame.Parent = inventoryFrame
	
	local filters = {"All", "Materials", "Weapons", "Consumables", "Tools", "Equipment"}
	local filterSpacing = 70
	
	for i, filterName in ipairs(filters) do
		local filterButton = Instance.new("TextButton")
		filterButton.Name = "Filter" .. filterName
		filterButton.Size = UDim2.new(0, 65, 0, 35)
		filterButton.Position = UDim2.new(0, (i - 1) * filterSpacing, 0, 0)
		filterButton.BackgroundColor3 = UIComponents.Colors.SlotEmpty
		filterButton.BorderSizePixel = 0
		filterButton.Text = filterName == "All" and "Todos" or filterName
		filterButton.TextColor3 = UIComponents.Colors.TextSecondary
		filterButton.TextSize = 12
		filterButton.Font = Enum.Font.GothamMedium
		filterButton.AutoButtonColor = false
		filterButton.Parent = filterFrame
		
		UIComponents.CreateCorner(filterButton, 6)
		
		filterButton.MouseButton1Click:Connect(function()
			setFilter(filterName, filterFrame)
		end)
	end
	
	-- Grid de slots
	local slotsFrame = Instance.new("ScrollingFrame")
	slotsFrame.Name = "SlotsFrame"
	slotsFrame.Size = UDim2.new(1, 0, 1, -50)
	slotsFrame.Position = UDim2.new(0, 0, 0, 45)
	slotsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	slotsFrame.BorderSizePixel = 0
	slotsFrame.ScrollBarThickness = 8
	slotsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	slotsFrame.Parent = inventoryFrame
	
	UIComponents.CreateCorner(slotsFrame, 8)
	
	-- Grid layout
	local gridLayout = Instance.new("UIGridLayout")
	gridLayout.CellSize = UDim2.new(0, 70, 0, 70)
	gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
	gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	gridLayout.Parent = slotsFrame
	
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingBottom = UDim.new(0, 10)
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.Parent = slotsFrame
	
	-- Crear 30 slots
	for i = 1, 30 do
		local slot = UIComponents.CreateSlot(slotsFrame, i, 70)
		setupSlotEvents(slot)
	end
	
	tabFrames["Inventario"] = inventoryFrame
	return inventoryFrame
end

-- Crear pestaña de crafteo
local function createCraftingTab(parent)
	local craftingFrame = Instance.new("Frame")
	craftingFrame.Name = "CraftingTab"
	craftingFrame.Size = UDim2.new(1, -40, 1, -165)
	craftingFrame.Position = UDim2.new(0, 20, 0, 115)
	craftingFrame.BackgroundTransparency = 1
	craftingFrame.Visible = false
	craftingFrame.Parent = parent
	
	-- Panel izquierdo: Lista de recetas
	local recipesPanel = Instance.new("ScrollingFrame")
	recipesPanel.Name = "RecipesPanel"
	recipesPanel.Size = UDim2.new(0.5, -10, 1, 0)
	recipesPanel.Position = UDim2.new(0, 0, 0, 0)
	recipesPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	recipesPanel.BorderSizePixel = 0
	recipesPanel.ScrollBarThickness = 8
	recipesPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
	recipesPanel.Parent = craftingFrame
	
	UIComponents.CreateCorner(recipesPanel, 8)
	
	local recipesList = Instance.new("UIListLayout")
	recipesList.Padding = UDim.new(0, 8)
	recipesList.SortOrder = Enum.SortOrder.LayoutOrder
	recipesList.Parent = recipesPanel
	
	local recipesPadding = Instance.new("UIPadding")
	recipesPadding.PaddingTop = UDim.new(0, 10)
	recipesPadding.PaddingBottom = UDim.new(0, 10)
	recipesPadding.PaddingLeft = UDim.new(0, 10)
	recipesPadding.PaddingRight = UDim.new(0, 10)
	recipesPadding.Parent = recipesPanel
	
	-- Panel derecho: Detalle de receta y crafteo
	local detailPanel = Instance.new("Frame")
	detailPanel.Name = "DetailPanel"
	detailPanel.Size = UDim2.new(0.5, -10, 1, 0)
	detailPanel.Position = UDim2.new(0.5, 10, 0, 0)
	detailPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	detailPanel.BorderSizePixel = 0
	detailPanel.Parent = craftingFrame
	
	UIComponents.CreateCorner(detailPanel, 8)
	
	-- Título del panel de detalle
	local detailTitle = Instance.new("TextLabel")
	detailTitle.Name = "DetailTitle"
	detailTitle.Size = UDim2.new(1, -20, 0, 30)
	detailTitle.Position = UDim2.new(0, 10, 0, 10)
	detailTitle.BackgroundTransparency = 1
	detailTitle.Text = "Selecciona una receta"
	detailTitle.TextColor3 = UIComponents.Colors.Text
	detailTitle.TextSize = 18
	detailTitle.Font = Enum.Font.GothamBold
	detailTitle.TextXAlignment = Enum.TextXAlignment.Left
	detailTitle.Parent = detailPanel
	
	-- Materiales necesarios
	local materialsFrame = Instance.new("Frame")
	materialsFrame.Name = "MaterialsFrame"
	materialsFrame.Size = UDim2.new(1, -20, 0, 150)
	materialsFrame.Position = UDim2.new(0, 10, 0, 50)
	materialsFrame.BackgroundTransparency = 1
	materialsFrame.Parent = detailPanel
	
	local materialsList = Instance.new("UIListLayout")
	materialsList.Padding = UDim.new(0, 10)
	materialsList.SortOrder = Enum.SortOrder.LayoutOrder
	materialsList.Parent = materialsFrame
	
	-- Botón craftear
	local craftButton = UIComponents.CreateButton(detailPanel, "CRAFTEAR", UDim2.new(0, 200, 0, 50), UDim2.new(0.5, -100, 1, -70))
	craftButton.Name = "CraftButton"
	craftButton.Visible = false
	
	craftButton.MouseButton1Click:Connect(function()
		local selectedRecipe = craftButton:GetAttribute("SelectedRecipe")
		if selectedRecipe then
			craftItemEvent:FireServer(selectedRecipe)
		end
	end)
	
	tabFrames["Crafteo"] = craftingFrame
	return craftingFrame
end

-- Crear pestaña de fusión
local function createFusionTab(parent)
	local fusionFrame = Instance.new("Frame")
	fusionFrame.Name = "FusionTab"
	fusionFrame.Size = UDim2.new(1, -40, 1, -165)
	fusionFrame.Position = UDim2.new(0, 20, 0, 115)
	fusionFrame.BackgroundTransparency = 1
	fusionFrame.Visible = false
	fusionFrame.Parent = parent
	
	-- Contenedor central
	local centerContainer = Instance.new("Frame")
	centerContainer.Size = UDim2.new(0, 500, 0, 400)
	centerContainer.Position = UDim2.new(0.5, -250, 0.5, -200)
	centerContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	centerContainer.BorderSizePixel = 0
	centerContainer.Parent = fusionFrame
	
	UIComponents.CreateCorner(centerContainer, 12)
	
	-- Título
	local fusionTitle = Instance.new("TextLabel")
	fusionTitle.Size = UDim2.new(1, 0, 0, 40)
	fusionTitle.Position = UDim2.new(0, 0, 0, 20)
	fusionTitle.BackgroundTransparency = 1
	fusionTitle.Text = "✨ FUSIÓN DE ITEMS"
	fusionTitle.TextColor3 = UIComponents.Colors.Text
	fusionTitle.TextSize = 22
	fusionTitle.Font = Enum.Font.GothamBold
	fusionTitle.Parent = centerContainer
	
	-- Instrucciones
	local instructions = Instance.new("TextLabel")
	instructions.Size = UDim2.new(1, -40, 0, 40)
	instructions.Position = UDim2.new(0, 20, 0, 70)
	instructions.BackgroundTransparency = 1
	instructions.Text = "Arrastra dos items iguales para fusionarlos"
	instructions.TextColor3 = UIComponents.Colors.TextSecondary
	instructions.TextSize = 14
	instructions.Font = Enum.Font.Gotham
	instructions.TextWrapped = true
	instructions.Parent = centerContainer
	
	-- Slot 1
	local fusionSlot1 = UIComponents.CreateSlot(centerContainer, 1, 100)
	fusionSlot1.Name = "FusionSlot1"
	fusionSlot1.Position = UDim2.new(0.25, -50, 0.4, -50)
	setupSlotEvents(fusionSlot1, true)
	
	-- Icono de suma
	local plusIcon = Instance.new("TextLabel")
	plusIcon.Size = UDim2.new(0, 50, 0, 50)
	plusIcon.Position = UDim2.new(0.5, -25, 0.4, -25)
	plusIcon.BackgroundTransparency = 1
	plusIcon.Text = "+"
	plusIcon.TextColor3 = UIComponents.Colors.Primary
	plusIcon.TextSize = 36
	plusIcon.Font = Enum.Font.GothamBold
	plusIcon.Parent = centerContainer
	
	-- Slot 2
	local fusionSlot2 = UIComponents.CreateSlot(centerContainer, 2, 100)
	fusionSlot2.Name = "FusionSlot2"
	fusionSlot2.Position = UDim2.new(0.75, -50, 0.4, -50)
	setupSlotEvents(fusionSlot2, true)
	
	-- Flecha
	local arrowIcon = Instance.new("TextLabel")
	arrowIcon.Size = UDim2.new(0, 50, 0, 50)
	arrowIcon.Position = UDim2.new(0.5, -25, 0.65, -25)
	arrowIcon.BackgroundTransparency = 1
	arrowIcon.Text = "↓"
	arrowIcon.TextColor3 = UIComponents.Colors.Primary
	arrowIcon.TextSize = 36
	arrowIcon.Font = Enum.Font.GothamBold
	arrowIcon.Parent = centerContainer
	
	-- Resultado
	local resultSlot = UIComponents.CreateSlot(centerContainer, 3, 100)
	resultSlot.Name = "ResultSlot"
	resultSlot.Position = UDim2.new(0.5, -50, 0.85, -50)
	
	-- Botón fusionar
	local fuseButton = UIComponents.CreateButton(centerContainer, "FUSIONAR", UDim2.new(0, 200, 0, 50), UDim2.new(0.5, -100, 1, -70))
	fuseButton.Name = "FuseButton"
	fuseButton.Visible = false
	
	fuseButton.MouseButton1Click:Connect(function()
		local item1 = fusionSlot1:GetAttribute("ItemId")
		local item2 = fusionSlot2:GetAttribute("ItemId")
		
		if item1 ~= "" and item2 ~= "" then
			fuseItemsEvent:FireServer(item1, item2)
		end
	end)
	
	tabFrames["Fusión"] = fusionFrame
	return fusionFrame
end

-- ============================================================================
-- FUNCIONES DE GESTIÓN DE UI
-- ============================================================================

-- Cambiar de pestaña
function switchTab(tabName)
	currentTab = tabName
	
	-- Actualizar botones de pestañas
	for name, button in pairs(tabButtons) do
		UIComponents.SetTabActive(button, name == tabName)
	end
	
	-- Mostrar/ocultar frames de pestañas
	for name, frame in pairs(tabFrames) do
		frame.Visible = (name == tabName)
	end
	
	-- Actualizar título
	local header = mainFrame:FindFirstChild("Header")
	if header then
		local title = header:FindFirstChild("Title")
		if title then
			if tabName == "Inventario" then
				title.Text = "🎒 INVENTARIO"
			elseif tabName == "Crafteo" then
				title.Text = "🔨 CRAFTEO"
			elseif tabName == "Fusión" then
				title.Text = "✨ FUSIÓN"
			end
		end
	end
	
	-- Cargar datos según pestaña
	if tabName == "Crafteo" then
		getRecipesEvent:FireServer()
	end
end

-- Establecer filtro activo
function setFilter(filterName, filterFrame)
	currentFilter = filterName
	
	-- Actualizar visualización de botones de filtro
	for _, button in ipairs(filterFrame:GetChildren()) do
		if button:IsA("TextButton") then
			local isActive = button.Name == "Filter" .. filterName
			
			if isActive then
				TweenService:Create(button, UIComponents.TweenInfo.Fast, {
					BackgroundColor3 = UIComponents.Colors.Primary,
					TextColor3 = UIComponents.Colors.Text
				}):Play()
			else
				TweenService:Create(button, UIComponents.TweenInfo.Fast, {
					BackgroundColor3 = UIComponents.Colors.SlotEmpty,
					TextColor3 = UIComponents.Colors.TextSecondary
				}):Play()
			end
		end
	end
	
	updateInventoryDisplay()
end

-- Configurar eventos de un slot
function setupSlotEvents(slot, isFusionSlot)
	-- Drag start
	slot.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local itemId = slot:GetAttribute("ItemId")
			if itemId and itemId ~= "" then
				startDrag(slot)
			end
		end
	end)
	
	-- Drag end (drop)
	slot.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if draggedSlot then
				endDrag(slot, isFusionSlot)
			end
		end
	end)
	
	-- Hover para tooltip
	slot.MouseEnter:Connect(function()
		showTooltip(slot)
	end)
	
	slot.MouseLeave:Connect(function()
		hideTooltip()
	end)
	
	-- Click derecho para usar item
	slot.MouseButton2Click:Connect(function()
		local itemId = slot:GetAttribute("ItemId")
		if itemId and itemId ~= "" and not isFusionSlot then
			local slotIndex = slot:GetAttribute("SlotIndex")
			useItemEvent:FireServer(slotIndex)
		end
	end)
end

-- Iniciar arrastre
function startDrag(slot)
	draggedSlot = slot
	
	-- Crear icono que sigue el cursor
	dragIcon = Instance.new("ImageLabel")
	dragIcon.Size = UDim2.new(0, 60, 0, 60)
	dragIcon.BackgroundTransparency = 0.3
	dragIcon.BackgroundColor3 = UIComponents.Colors.Primary
	dragIcon.BorderSizePixel = 0
	dragIcon.ZIndex = 10000
	dragIcon.Parent = inventoryGui
	
	UIComponents.CreateCorner(dragIcon, 8)
	
	-- Copiar icono del slot
	local slotIcon = slot:FindFirstChild("Icon")
	if slotIcon then
		dragIcon.Image = slotIcon.Image
		dragIcon.ImageColor3 = slotIcon.ImageColor3
	end
end

-- Finalizar arrastre
function endDrag(targetSlot, isFusionSlot)
	if not draggedSlot then return end
	
	local fromIndex = draggedSlot:GetAttribute("SlotIndex")
	local toIndex = targetSlot:GetAttribute("SlotIndex")
	
	-- Si es pestaña de fusión, manejarlo diferente
	if currentTab == "Fusión" or isFusionSlot then
		handleFusionDrop(targetSlot)
	else
		-- Mover item en inventario normal
		if fromIndex and toIndex and fromIndex ~= toIndex then
			moveItemEvent:FireServer(fromIndex, toIndex)
		end
	end
	
	-- Limpiar
	if dragIcon then
		dragIcon:Destroy()
		dragIcon = nil
	end
	draggedSlot = nil
end

-- Manejar drop en slots de fusión
function handleFusionDrop(targetSlot)
	if not draggedSlot then return end
	
	local itemId = draggedSlot:GetAttribute("ItemId")
	local quantity = draggedSlot:GetAttribute("Quantity")
	
	-- Copiar item al slot de fusión
	targetSlot:SetAttribute("ItemId", itemId)
	targetSlot:SetAttribute("Quantity", 1)
	
	local icon = targetSlot:FindFirstChild("Icon")
	local dragIcon = draggedSlot:FindFirstChild("Icon")
	
	if icon and dragIcon then
		icon.Image = dragIcon.Image
		icon.ImageColor3 = dragIcon.ImageColor3
	end
	
	-- Actualizar visualización de fusión
	updateFusionPreview()
end

-- Actualizar preview de fusión
function updateFusionPreview()
	local fusionTab = tabFrames["Fusión"]
	if not fusionTab then return end
	
	local container = fusionTab:FindFirstChild("Frame")
	if not container then
		container = fusionTab:GetChildren()[1]
	end
	
	local slot1 = container:FindFirstChild("FusionSlot1")
	local slot2 = container:FindFirstChild("FusionSlot2")
	local fuseButton = container:FindFirstChild("FuseButton")
	
	if not slot1 or not slot2 or not fuseButton then return end
	
	local item1 = slot1:GetAttribute("ItemId")
	local item2 = slot2:GetAttribute("ItemId")
	
	-- Mostrar botón si ambos slots tienen items iguales
	if item1 ~= "" and item2 ~= "" and item1 == item2 then
		fuseButton.Visible = true
	else
		fuseButton.Visible = false
	end
end

-- Mostrar tooltip
function showTooltip(slot)
	local itemId = slot:GetAttribute("ItemId")
	if not itemId or itemId == "" then return end
	
	-- Cancelar tooltip anterior
	hideTooltip()
	
	-- Esperar un poco antes de mostrar
	tooltipConnection = task.delay(0.3, function()
		-- Solicitar info del item al servidor (por ahora usaremos datos básicos)
		local itemData = {
			name = itemId,
			description = "Descripción del item",
			rarity = "Common",
			quantity = slot:GetAttribute("Quantity") or 1
		}
		
		activeTooltip = UIComponents.CreateTooltip(inventoryGui, itemData)
		
		-- Posicionar cerca del cursor
		local mouse = player:GetMouse()
		activeTooltip.Position = UDim2.new(0, mouse.X + 10, 0, mouse.Y + 10)
		activeTooltip.Visible = true
	end)
end

-- Ocultar tooltip
function hideTooltip()
	if tooltipConnection then
		task.cancel(tooltipConnection)
		tooltipConnection = nil
	end
	
	if activeTooltip then
		activeTooltip:Destroy()
		activeTooltip = nil
	end
end

-- Actualizar display del inventario
function updateInventoryDisplay()
	if not currentInventory then return end
	
	local inventoryTab = tabFrames["Inventario"]
	if not inventoryTab then return end
	
	local slotsFrame = inventoryTab:FindFirstChild("SlotsFrame")
	if not slotsFrame then return end
	
	-- Filtrar y buscar items
	local visibleSlots = {}
	
	for i, slotData in pairs(currentInventory.slots) do
		if slotData and slotData.id then
			local shouldShow = true
			
			-- Aplicar filtro de categoría
			if currentFilter ~= "All" then
				-- Por ahora mostramos todo, el servidor debería enviar la categoría
				-- shouldShow = slotData.category == currentFilter
			end
			
			-- Aplicar búsqueda
			if searchQuery ~= "" then
				shouldShow = shouldShow and string.find(slotData.id:lower(), searchQuery) ~= nil
			end
			
			if shouldShow then
				table.insert(visibleSlots, {index = i, data = slotData})
			end
		end
	end
	
	-- Actualizar slots visibles
	local slotIndex = 1
	for _, slot in ipairs(slotsFrame:GetChildren()) do
		if slot:IsA("Frame") and slot.Name:match("Slot") then
			if slotIndex <= #visibleSlots then
				local slotData = visibleSlots[slotIndex].data
				updateSlotVisual(slot, slotData)
				slotIndex = slotIndex + 1
			else
				clearSlot(slot)
			end
		end
	end
end

-- Actualizar visual de un slot
function updateSlotVisual(slot, slotData)
	slot:SetAttribute("ItemId", slotData.id)
	slot:SetAttribute("Quantity", slotData.quantity)
	
	local icon = slot:FindFirstChild("Icon")
	local quantity = slot:FindFirstChild("Quantity")
	
	if icon then
		icon.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
		-- Aquí se aplicaría el color según el item
		icon.ImageColor3 = Color3.fromRGB(200, 200, 200)
	end
	
	if quantity then
		if slotData.quantity > 1 then
			quantity.Text = tostring(slotData.quantity)
		else
			quantity.Text = ""
		end
	end
	
	-- Cambiar color de fondo
	TweenService:Create(slot, UIComponents.TweenInfo.Fast, {
		BackgroundColor3 = UIComponents.Colors.SlotFilled
	}):Play()
end

-- Limpiar un slot
function clearSlot(slot)
	slot:SetAttribute("ItemId", "")
	slot:SetAttribute("Quantity", 0)
	
	local icon = slot:FindFirstChild("Icon")
	local quantity = slot:FindFirstChild("Quantity")
	
	if icon then
		icon.Image = ""
	end
	
	if quantity then
		quantity.Text = ""
	end
	
	TweenService:Create(slot, UIComponents.TweenInfo.Fast, {
		BackgroundColor3 = UIComponents.Colors.SlotEmpty
	}):Play()
end

-- ============================================================================
-- FUNCIONES DE APERTURA/CIERRE
-- ============================================================================

function openInventory()
	if isOpen then return end
	
	isOpen = true
	UIComponents.AnimateWindow(mainFrame, true)
	
	-- Actualizar display
	updateInventoryDisplay()
end

function closeInventory()
	if not isOpen then return end
	
	isOpen = false
	UIComponents.AnimateWindow(mainFrame, false)
	
	-- Limpiar tooltip y drag
	hideTooltip()
	if dragIcon then
		dragIcon:Destroy()
		dragIcon = nil
	end
	draggedSlot = nil
end

-- ============================================================================
-- EVENTOS DEL SERVIDOR
-- ============================================================================

-- Actualizar inventario
if updateInventoryEvent then
	updateInventoryEvent.OnClientEvent:Connect(function(inventory)
		print("📦 Inventario actualizado")
		currentInventory = inventory
		updateInventoryDisplay()
	end)
end

-- Actualizar recetas
if updateRecipesEvent then
	updateRecipesEvent.OnClientEvent:Connect(function(recipes)
		print("📋 Recetas actualizadas")
		currentRecipes = recipes
		updateRecipesDisplay()
	end)
end

-- Actualizar display de recetas
function updateRecipesDisplay()
	local craftingTab = tabFrames["Crafteo"]
	if not craftingTab then return end
	
	local recipesPanel = craftingTab:FindFirstChild("RecipesPanel")
	if not recipesPanel then return end
	
	-- Limpiar recetas anteriores
	for _, child in ipairs(recipesPanel:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	
	-- Crear botones de recetas
	for _, recipe in ipairs(currentRecipes) do
		createRecipeButton(recipesPanel, recipe)
	end
	
	-- Actualizar canvas size
	local listLayout = recipesPanel:FindFirstChildOfClass("UIListLayout")
	if listLayout then
		recipesPanel.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
	end
end

-- Crear botón de receta
function createRecipeButton(parent, recipe)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -20, 0, 60)
	button.BackgroundColor3 = UIComponents.Colors.SlotEmpty
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	button.Parent = parent
	
	UIComponents.CreateCorner(button, 8)
	
	local name = Instance.new("TextLabel")
	name.Size = UDim2.new(1, -20, 0, 25)
	name.Position = UDim2.new(0, 10, 0, 5)
	name.BackgroundTransparency = 1
	name.Text = recipe.name
	name.TextColor3 = UIComponents.Colors.Text
	name.TextSize = 16
	name.Font = Enum.Font.GothamBold
	name.TextXAlignment = Enum.TextXAlignment.Left
	name.Parent = button
	
	local materials = Instance.new("TextLabel")
	materials.Size = UDim2.new(1, -20, 0, 20)
	materials.Position = UDim2.new(0, 10, 0, 32)
	materials.BackgroundTransparency = 1
	materials.Text = "Materiales: " .. #recipe.materials
	materials.TextColor3 = UIComponents.Colors.TextSecondary
	materials.TextSize = 12
	materials.Font = Enum.Font.Gotham
	materials.TextXAlignment = Enum.TextXAlignment.Left
	materials.Parent = button
	
	button.MouseEnter:Connect(function()
		TweenService:Create(button, UIComponents.TweenInfo.Fast, {
			BackgroundColor3 = UIComponents.Colors.SlotFilled
		}):Play()
	end)
	
	button.MouseLeave:Connect(function()
		TweenService:Create(button, UIComponents.TweenInfo.Fast, {
			BackgroundColor3 = UIComponents.Colors.SlotEmpty
		}):Play()
	end)
	
	button.MouseButton1Click:Connect(function()
		selectRecipe(recipe)
	end)
end

-- Seleccionar receta
function selectRecipe(recipe)
	local craftingTab = tabFrames["Crafteo"]
	if not craftingTab then return end
	
	local detailPanel = craftingTab:FindFirstChild("DetailPanel")
	if not detailPanel then return end
	
	local detailTitle = detailPanel:FindFirstChild("DetailTitle")
	if detailTitle then
		detailTitle.Text = recipe.name
	end
	
	local craftButton = detailPanel:FindFirstChild("CraftButton")
	if craftButton then
		craftButton.Visible = true
		craftButton:SetAttribute("SelectedRecipe", recipe.id)
	end
	
	-- Mostrar materiales necesarios
	local materialsFrame = detailPanel:FindFirstChild("MaterialsFrame")
	if materialsFrame then
		-- Limpiar materiales anteriores
		for _, child in ipairs(materialsFrame:GetChildren()) do
			if child:IsA("Frame") then
				child:Destroy()
			end
		end
		
		-- Agregar materiales
		for _, material in ipairs(recipe.materials) do
			local matFrame = Instance.new("Frame")
			matFrame.Size = UDim2.new(1, 0, 0, 30)
			matFrame.BackgroundTransparency = 1
			matFrame.Parent = materialsFrame
			
			local matLabel = Instance.new("TextLabel")
			matLabel.Size = UDim2.new(1, 0, 1, 0)
			matLabel.BackgroundTransparency = 1
			matLabel.Text = string.format("%s x%d", material.id, material.quantity)
			matLabel.TextColor3 = UIComponents.Colors.Text
			matLabel.TextSize = 14
			matLabel.Font = Enum.Font.Gotham
			matLabel.TextXAlignment = Enum.TextXAlignment.Left
			matLabel.Parent = matFrame
		end
	end
end

-- ============================================================================
-- CONTROLES DE TECLADO
-- ============================================================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.E then
		if isOpen then
			closeInventory()
		else
			openInventory()
		end
	elseif input.KeyCode == Enum.KeyCode.Escape and isOpen then
		closeInventory()
	end
end)

-- Actualizar posición del icono arrastrado
RunService.RenderStepped:Connect(function()
	if dragIcon then
		local mouse = player:GetMouse()
		dragIcon.Position = UDim2.new(0, mouse.X - 30, 0, mouse.Y - 30)
	end
end)

-- ============================================================================
-- INICIALIZACIÓN
-- ============================================================================

print("🎨 Creando interfaz de usuario...")

inventoryGui = createMainScreenGui()
mainFrame = createMainFrame(inventoryGui)
createHeader(mainFrame)
createTabSystem(mainFrame)
createInventoryTab(mainFrame)
createCraftingTab(mainFrame)
createFusionTab(mainFrame)

-- Activar pestaña inicial
switchTab("Inventario")

print("✅ Sistema de inventario moderno cargado")
print("💡 Presiona [E] para abrir/cerrar el inventario")


