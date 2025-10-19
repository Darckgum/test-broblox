-- Cliente del sistema de inventario
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Esperar a que los RemoteEvents estén disponibles
local remotesFolder = ReplicatedStorage:WaitForChild("InventoryRemotes", 10)
if not remotesFolder then
    warn("⚠️ No se encontraron los RemoteEvents del inventario")
    return
end

local updateInventoryEvent = remotesFolder:WaitForChild("UpdateInventory")
local useItemEvent = remotesFolder:WaitForChild("UseItem")
local equipWeaponEvent = remotesFolder:WaitForChild("EquipWeapon")
local unequipWeaponEvent = remotesFolder:WaitForChild("UnequipWeapon")
local dropItemEvent = remotesFolder:WaitForChild("DropItem")
local getInventoryFunction = remotesFolder:WaitForChild("GetInventory")

-- Variables
local inventoryData = nil
local inventoryOpen = false
local selectedSlot = nil

-- Colores de raridad
local rarityColors = {
    Common = Color3.fromRGB(150, 150, 150),
    Rare = Color3.fromRGB(0, 112, 221),
    Epic = Color3.fromRGB(163, 53, 238),
    Legendary = Color3.fromRGB(255, 128, 0)
}

-- Crear GUI del inventario
local function createInventoryGUI()
    print("🎨 Creando GUI del inventario...")
    
    -- ScreenGui principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "InventoryGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui
    
    -- Frame principal (oculto por defecto)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 600, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
    mainFrame.Visible = false
    mainFrame.Parent = screenGui
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    title.BorderSizePixel = 0
    title.Text = "📦 INVENTARIO"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 24
    title.Font = Enum.Font.SourceSansBold
    title.Parent = mainFrame
    
    -- Botón de cerrar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextSize = 20
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = mainFrame
    
    -- Contenedor de slots
    local slotsContainer = Instance.new("Frame")
    slotsContainer.Name = "SlotsContainer"
    slotsContainer.Size = UDim2.new(1, -20, 1, -100)
    slotsContainer.Position = UDim2.new(0, 10, 0, 50)
    slotsContainer.BackgroundTransparency = 1
    slotsContainer.Parent = mainFrame
    
    -- Crear grid de slots (4 columnas x 5 filas = 20 slots)
    local slotSize = 80
    local spacing = 10
    
    for i = 1, 20 do
        local row = math.floor((i - 1) / 4)
        local col = (i - 1) % 4
        
        local slotFrame = Instance.new("Frame")
        slotFrame.Name = "Slot" .. i
        slotFrame.Size = UDim2.new(0, slotSize, 0, slotSize)
        slotFrame.Position = UDim2.new(0, col * (slotSize + spacing) + 50, 0, row * (slotSize + spacing))
        slotFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        slotFrame.BorderSizePixel = 2
        slotFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
        slotFrame.Parent = slotsContainer
        
        -- Icono del item
        local icon = Instance.new("TextLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(1, 0, 0.6, 0)
        icon.BackgroundTransparency = 1
        icon.Text = ""
        icon.TextColor3 = Color3.new(1, 1, 1)
        icon.TextSize = 36
        icon.Font = Enum.Font.SourceSansBold
        icon.Parent = slotFrame
        
        -- Cantidad
        local quantity = Instance.new("TextLabel")
        quantity.Name = "Quantity"
        quantity.Size = UDim2.new(1, 0, 0.3, 0)
        quantity.Position = UDim2.new(0, 0, 0.7, 0)
        quantity.BackgroundTransparency = 1
        quantity.Text = ""
        quantity.TextColor3 = Color3.new(1, 1, 1)
        quantity.TextSize = 16
        quantity.Font = Enum.Font.SourceSans
        quantity.Parent = slotFrame
        
        -- Botón para seleccionar slot
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Size = UDim2.new(1, 0, 1, 0)
        button.BackgroundTransparency = 1
        button.Text = ""
        button.Parent = slotFrame
        
        -- Event de clic
        button.MouseButton1Click:Connect(function()
            selectSlot(i)
        end)
    end
    
    -- Panel de información del item seleccionado
    local infoPanel = Instance.new("Frame")
    infoPanel.Name = "InfoPanel"
    infoPanel.Size = UDim2.new(0, 200, 1, -100)
    infoPanel.Position = UDim2.new(1, -210, 0, 50)
    infoPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    infoPanel.BorderSizePixel = 1
    infoPanel.BorderColor3 = Color3.fromRGB(80, 80, 80)
    infoPanel.Parent = mainFrame
    
    -- Nombre del item
    local itemName = Instance.new("TextLabel")
    itemName.Name = "ItemName"
    itemName.Size = UDim2.new(1, -10, 0, 30)
    itemName.Position = UDim2.new(0, 5, 0, 5)
    itemName.BackgroundTransparency = 1
    itemName.Text = "Sin item"
    itemName.TextColor3 = Color3.new(1, 1, 1)
    itemName.TextSize = 18
    itemName.Font = Enum.Font.SourceSansBold
    itemName.TextXAlignment = Enum.TextXAlignment.Left
    itemName.TextWrapped = true
    itemName.Parent = infoPanel
    
    -- Descripción del item
    local itemDesc = Instance.new("TextLabel")
    itemDesc.Name = "ItemDesc"
    itemDesc.Size = UDim2.new(1, -10, 0, 100)
    itemDesc.Position = UDim2.new(0, 5, 0, 40)
    itemDesc.BackgroundTransparency = 1
    itemDesc.Text = ""
    itemDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    itemDesc.TextSize = 14
    itemDesc.Font = Enum.Font.SourceSans
    itemDesc.TextXAlignment = Enum.TextXAlignment.Left
    itemDesc.TextYAlignment = Enum.TextYAlignment.Top
    itemDesc.TextWrapped = true
    itemDesc.Parent = infoPanel
    
    -- Botón Usar
    local useButton = Instance.new("TextButton")
    useButton.Name = "UseButton"
    useButton.Size = UDim2.new(1, -10, 0, 35)
    useButton.Position = UDim2.new(0, 5, 0, 150)
    useButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    useButton.Text = "💊 Usar"
    useButton.TextColor3 = Color3.new(1, 1, 1)
    useButton.TextSize = 16
    useButton.Font = Enum.Font.SourceSansBold
    useButton.Visible = false
    useButton.Parent = infoPanel
    
    useButton.MouseButton1Click:Connect(function()
        if selectedSlot then
            useItemEvent:FireServer(selectedSlot)
        end
    end)
    
    -- Botón Equipar
    local equipButton = Instance.new("TextButton")
    equipButton.Name = "EquipButton"
    equipButton.Size = UDim2.new(1, -10, 0, 35)
    equipButton.Position = UDim2.new(0, 5, 0, 190)
    equipButton.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    equipButton.Text = "⚔️ Equipar"
    equipButton.TextColor3 = Color3.new(1, 1, 1)
    equipButton.TextSize = 16
    equipButton.Font = Enum.Font.SourceSansBold
    equipButton.Visible = false
    equipButton.Parent = infoPanel
    
    equipButton.MouseButton1Click:Connect(function()
        if selectedSlot then
            equipWeaponEvent:FireServer(selectedSlot)
        end
    end)
    
    -- Botón Tirar
    local dropButton = Instance.new("TextButton")
    dropButton.Name = "DropButton"
    dropButton.Size = UDim2.new(1, -10, 0, 35)
    dropButton.Position = UDim2.new(0, 5, 0, 230)
    dropButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    dropButton.Text = "🗑️ Tirar"
    dropButton.TextColor3 = Color3.new(1, 1, 1)
    dropButton.TextSize = 16
    dropButton.Font = Enum.Font.SourceSansBold
    dropButton.Visible = false
    dropButton.Parent = infoPanel
    
    dropButton.MouseButton1Click:Connect(function()
        if selectedSlot then
            dropItemEvent:FireServer(selectedSlot, 1)
        end
    end)
    
    -- Event del botón cerrar
    closeButton.MouseButton1Click:Connect(function()
        toggleInventory()
    end)
    
    print("✅ GUI del inventario creada")
    return screenGui
end

-- Función para seleccionar un slot
function selectSlot(slotNumber)
    selectedSlot = slotNumber
    print("🎯 Slot seleccionado:", slotNumber)
    updateInfoPanel()
end

-- Función para actualizar el panel de información
function updateInfoPanel()
    local gui = playerGui:FindFirstChild("InventoryGUI")
    if not gui then return end
    
    local infoPanel = gui.MainFrame.InfoPanel
    local itemName = infoPanel.ItemName
    local itemDesc = infoPanel.ItemDesc
    local useButton = infoPanel.UseButton
    local equipButton = infoPanel.EquipButton
    local dropButton = infoPanel.DropButton
    
    if not selectedSlot or not inventoryData then
        itemName.Text = "Sin item"
        itemDesc.Text = ""
        useButton.Visible = false
        equipButton.Visible = false
        dropButton.Visible = false
        return
    end
    
    local slotData = inventoryData.slots[selectedSlot]
    
    if not slotData.itemId then
        itemName.Text = "Vacío"
        itemDesc.Text = ""
        useButton.Visible = false
        equipButton.Visible = false
        dropButton.Visible = false
        return
    end
    
    local itemData = slotData.itemData
    
    -- Actualizar nombre con color de raridad
    itemName.Text = itemData.name
    itemName.TextColor3 = rarityColors[itemData.rarity] or Color3.new(1, 1, 1)
    
    -- Actualizar descripción
    itemDesc.Text = itemData.description
    if itemData.category == "Weapon" then
        itemDesc.Text = itemDesc.Text .. "\n\nDaño: " .. itemData.damage
    elseif itemData.category == "Consumable" then
        itemDesc.Text = itemDesc.Text .. "\n\nEfecto: +" .. itemData.effectValue .. " HP"
    end
    
    -- Mostrar botones apropiados
    useButton.Visible = itemData.category == "Consumable"
    equipButton.Visible = itemData.category == "Weapon"
    dropButton.Visible = true
end

-- Función para actualizar la visualización del inventario
function updateInventoryDisplay()
    local gui = playerGui:FindFirstChild("InventoryGUI")
    if not gui or not inventoryData then return end
    
    local slotsContainer = gui.MainFrame.SlotsContainer
    
    for i = 1, 20 do
        local slotFrame = slotsContainer:FindFirstChild("Slot" .. i)
        if slotFrame then
            local slotData = inventoryData.slots[i]
            local icon = slotFrame.Icon
            local quantity = slotFrame.Quantity
            
            if slotData.itemId and slotData.itemData then
                local itemData = slotData.itemData
                
                -- Actualizar icono
                icon.Text = itemData.icon
                
                -- Actualizar cantidad
                if itemData.stackable and slotData.quantity > 1 then
                    quantity.Text = "x" .. slotData.quantity
                else
                    quantity.Text = ""
                end
                
                -- Color de fondo según raridad
                slotFrame.BackgroundColor3 = rarityColors[itemData.rarity] or Color3.fromRGB(50, 50, 50)
            else
                -- Slot vacío
                icon.Text = ""
                quantity.Text = ""
                slotFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end
        end
    end
    
    -- Actualizar panel de información si hay un slot seleccionado
    if selectedSlot then
        updateInfoPanel()
    end
end

-- Función para alternar visibilidad del inventario
function toggleInventory()
    local gui = playerGui:FindFirstChild("InventoryGUI")
    if not gui then return end
    
    inventoryOpen = not inventoryOpen
    gui.MainFrame.Visible = inventoryOpen
    
    if inventoryOpen then
        print("📦 Inventario abierto")
        -- Solicitar datos actualizados
        local success, data = pcall(function()
            return getInventoryFunction:InvokeServer()
        end)
        
        if success and data then
            inventoryData = data
            updateInventoryDisplay()
        end
    else
        print("📦 Inventario cerrado")
        selectedSlot = nil
    end
end

-- Detectar tecla para abrir inventario (I o E)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.I or input.KeyCode == Enum.KeyCode.E then
        toggleInventory()
    end
end)

-- Escuchar actualizaciones del servidor
updateInventoryEvent.OnClientEvent:Connect(function(data)
    print("🔄 Inventario actualizado desde el servidor")
    inventoryData = data
    updateInventoryDisplay()
end)

-- Crear GUI al iniciar
createInventoryGUI()

print("✅ Cliente de inventario inicializado")
print("💡 Presiona 'I' o 'E' para abrir el inventario")

