-- Cliente de Inventario - Sistema de Inventario Completo
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Esperar a que los remotes estén disponibles
local inventoryRemotes = ReplicatedStorage:WaitForChild("InventoryRemotes")

-- Variables del inventario
local inventoryGui = nil
local inventoryFrame = nil
local isInventoryOpen = false
local draggedItem = nil
local inventorySlots = {}

-- Configuración del inventario
local INVENTORY_SIZE = 20
local SLOT_SIZE = 50
local SLOT_SPACING = 5

-- Función para crear la GUI del inventario
local function createInventoryGUI()
    -- Crear ScreenGui principal
    inventoryGui = Instance.new("ScreenGui")
    inventoryGui.Name = "InventoryGUI"
    inventoryGui.ResetOnSpawn = false
    inventoryGui.Parent = playerGui
    
    -- Frame principal del inventario
    inventoryFrame = Instance.new("Frame")
    inventoryFrame.Name = "InventoryFrame"
    inventoryFrame.Size = UDim2.new(0, 400, 0, 300)
    inventoryFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    inventoryFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    inventoryFrame.BorderSizePixel = 0
    inventoryFrame.Visible = false
    inventoryFrame.Parent = inventoryGui
    
    -- Esquinas redondeadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = inventoryFrame
    
    -- Título del inventario
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "Inventario"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = inventoryFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleLabel
    
    -- Crear slots del inventario
    local slotsFrame = Instance.new("Frame")
    slotsFrame.Name = "SlotsFrame"
    slotsFrame.Size = UDim2.new(1, -20, 1, -60)
    slotsFrame.Position = UDim2.new(0, 10, 0, 50)
    slotsFrame.BackgroundTransparency = 1
    slotsFrame.Parent = inventoryFrame
    
    -- Crear grid de slots
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0, SLOT_SIZE, 0, SLOT_SIZE)
    gridLayout.CellPadding = UDim2.new(0, SLOT_SPACING, 0, SLOT_SPACING)
    gridLayout.Parent = slotsFrame
    
    -- Crear slots
    for i = 1, INVENTORY_SIZE do
        local slot = Instance.new("Frame")
        slot.Name = "Slot" .. i
        slot.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        slot.BorderSizePixel = 0
        slot.Parent = slotsFrame
        
        local slotCorner = Instance.new("UICorner")
        slotCorner.CornerRadius = UDim.new(0, 4)
        slotCorner.Parent = slot
        
        -- Texto del slot
        local slotText = Instance.new("TextLabel")
        slotText.Name = "SlotText"
        slotText.Size = UDim2.new(1, 0, 1, 0)
        slotText.BackgroundTransparency = 1
        slotText.Text = ""
        slotText.TextColor3 = Color3.fromRGB(255, 255, 255)
        slotText.TextScaled = true
        slotText.Font = Enum.Font.SourceSans
        slotText.Parent = slot
        
        -- Guardar referencia del slot
        inventorySlots[i] = slot
    end
    
    print("✅ GUI de inventario creada")
end

-- Función para actualizar un slot del inventario
local function updateSlot(slotIndex, itemData)
    local slot = inventorySlots[slotIndex]
    if not slot then return end
    
    local slotText = slot:FindFirstChild("SlotText")
    if not slotText then return end
    
    if itemData and itemData.name then
        slotText.Text = itemData.name
        slot.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    else
        slotText.Text = ""
        slot.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end

-- Función para actualizar todo el inventario
local function updateInventory(inventoryData)
    for i = 1, INVENTORY_SIZE do
        local itemData = inventoryData[i]
        updateSlot(i, itemData)
    end
end

-- Función para abrir/cerrar inventario
local function toggleInventory()
    isInventoryOpen = not isInventoryOpen
    inventoryFrame.Visible = isInventoryOpen
    
    if isInventoryOpen then
        -- Solicitar datos del inventario
        inventoryRemotes.GetInventory:FireServer()
    end
end

-- Función para manejar el drag and drop
local function setupDragAndDrop()
    for i, slot in pairs(inventorySlots) do
        slot.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggedItem = {
                    slotIndex = i,
                    slot = slot
                }
            end
        end)
        
        slot.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and draggedItem then
                -- Intercambiar items
                if draggedItem.slotIndex ~= i then
                    inventoryRemotes.SwapItems:FireServer(draggedItem.slotIndex, i)
                end
                draggedItem = nil
            end
        end)
    end
end

-- Configurar eventos de los remotes
inventoryRemotes.UpdateInventory.OnClientEvent:Connect(function(inventoryData)
    updateInventory(inventoryData)
end)

-- Configurar tecla para abrir inventario
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.I then
        toggleInventory()
    end
end)

-- Inicializar
createInventoryGUI()
setupDragAndDrop()

print("✅ InventoryClient iniciado - Presiona 'I' para abrir el inventario")