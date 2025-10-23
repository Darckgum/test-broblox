-- InventoryManager.lua
-- Gestión del inventario de los jugadores

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ItemDatabase = require(script.Parent.ItemDatabase)

local InventoryManager = {}

-- Configuración
local INVENTORY_SIZE = 30
local DATASTORE_NAME = "PlayerInventories"
local SAVE_INTERVAL = 30 -- segundos

-- DataStore
local inventoryDataStore = DataStoreService:GetDataStore(DATASTORE_NAME)

-- Cache de inventarios en memoria
local playerInventories = {}
local lastSaveTime = {}

-- Estructura de inventario por defecto
local function createDefaultInventory()
    return {
        slots = {},
        maxSlots = INVENTORY_SIZE
    }
end

-- Obtener inventario de un jugador
function InventoryManager.getInventory(player)
    if not playerInventories[player.UserId] then
        InventoryManager.loadInventory(player)
    end
    return playerInventories[player.UserId]
end

-- Cargar inventario desde DataStore
function InventoryManager.loadInventory(player)
    local success, data = pcall(function()
        return inventoryDataStore:GetAsync(tostring(player.UserId))
    end)
    
    if success and data then
        playerInventories[player.UserId] = data
    else
        -- Crear inventario por defecto
        playerInventories[player.UserId] = createDefaultInventory()
        -- Dar algunos items iniciales
        InventoryManager.addItem(player, "wood", 10)
        InventoryManager.addItem(player, "stone", 5)
        InventoryManager.addItem(player, "iron", 2)
    end
    
    lastSaveTime[player.UserId] = tick()
    return playerInventories[player.UserId]
end

-- Guardar inventario en DataStore
function InventoryManager.saveInventory(player)
    if not playerInventories[player.UserId] then return end
    
    local success, error = pcall(function()
        inventoryDataStore:SetAsync(tostring(player.UserId), playerInventories[player.UserId])
    end)
    
    if success then
        print("✅ Inventario guardado para", player.Name)
    else
        warn("❌ Error guardando inventario de", player.Name, ":", error)
    end
end

-- Agregar item al inventario
function InventoryManager.addItem(player, itemId, quantity)
    local inventory = InventoryManager.getInventory(player)
    local itemData = ItemDatabase.getItemById(itemId)
    
    if not itemData then
        warn("❌ Item no encontrado:", itemId)
        return false
    end
    
    quantity = quantity or 1
    
    -- Si es stackable, buscar slot existente
    if itemData.stackable then
        for slotIndex, slot in ipairs(inventory.slots) do
            if slot and slot.id == itemId then
                local newQuantity = slot.quantity + quantity
                if newQuantity <= itemData.maxStack then
                    slot.quantity = newQuantity
                    InventoryManager.updateClientInventory(player)
                    return true
                end
            end
        end
    end
    
    -- Buscar slot vacío
    for i = 1, INVENTORY_SIZE do
        if not inventory.slots[i] then
            inventory.slots[i] = {
                id = itemId,
                quantity = quantity
            }
            InventoryManager.updateClientInventory(player)
            return true
        end
    end
    
    warn("❌ Inventario lleno para", player.Name)
    return false
end

-- Remover item del inventario
function InventoryManager.removeItem(player, itemId, quantity)
    local inventory = InventoryManager.getInventory(player)
    quantity = quantity or 1
    
    for slotIndex, slot in ipairs(inventory.slots) do
        if slot and slot.id == itemId then
            if slot.quantity >= quantity then
                slot.quantity = slot.quantity - quantity
                if slot.quantity <= 0 then
                    inventory.slots[slotIndex] = nil
                end
                InventoryManager.updateClientInventory(player)
                return true
            end
        end
    end
    
    return false
end

-- Verificar si tiene suficientes items
function InventoryManager.hasItem(player, itemId, quantity)
    local inventory = InventoryManager.getInventory(player)
    quantity = quantity or 1
    
    for _, slot in ipairs(inventory.slots) do
        if slot and slot.id == itemId and slot.quantity >= quantity then
            return true
        end
    end
    
    return false
end

-- Mover item entre slots
function InventoryManager.moveItem(player, fromSlot, toSlot)
    local inventory = InventoryManager.getInventory(player)
    
    if fromSlot < 1 or fromSlot > INVENTORY_SIZE or toSlot < 1 or toSlot > INVENTORY_SIZE then
        return false
    end
    
    local fromItem = inventory.slots[fromSlot]
    local toItem = inventory.slots[toSlot]
    
    -- Intercambiar items
    inventory.slots[fromSlot] = toItem
    inventory.slots[toSlot] = fromItem
    
    InventoryManager.updateClientInventory(player)
    return true
end

-- Usar item
function InventoryManager.useItem(player, slotIndex)
    local inventory = InventoryManager.getInventory(player)
    local slot = inventory.slots[slotIndex]
    
    if not slot then return false end
    
    local itemData = ItemDatabase.getItemById(slot.id)
    if not itemData then return false end
    
    -- Solo consumibles se pueden usar
    if itemData.category ~= "Consumables" then
        return false
    end
    
    -- Aplicar efecto del consumible
    if itemData.healAmount then
        -- Lógica de curación (conectar con sistema de vida)
        print("💚", player.Name, "usó poción de vida (+" .. itemData.healAmount .. " HP)")
    elseif itemData.speedMultiplier then
        print("🏃", player.Name, "usó poción de velocidad")
    elseif itemData.damageMultiplier then
        print("💪", player.Name, "usó poción de fuerza")
    end
    
    -- Consumir item
    InventoryManager.removeItem(player, slot.id, 1)
    return true
end

-- Actualizar inventario en el cliente
function InventoryManager.updateClientInventory(player)
    local inventory = InventoryManager.getInventory(player)
    
    -- Enviar datos al cliente (si existen los eventos)
    local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if remoteEvents then
        local inventoryEvents = remoteEvents:FindFirstChild("InventoryEvents")
        if inventoryEvents then
            local updateEvent = inventoryEvents:FindFirstChild("UpdateInventory")
            if updateEvent then
                updateEvent:FireClient(player, inventory)
            end
        end
    end
end

-- Auto-guardar inventarios
spawn(function()
    while true do
        wait(SAVE_INTERVAL)
        for userId, _ in pairs(playerInventories) do
            local player = Players:GetPlayerByUserId(userId)
            if player then
                InventoryManager.saveInventory(player)
            end
        end
    end
end)

-- Guardar al desconectar
Players.PlayerRemoving:Connect(function(player)
    InventoryManager.saveInventory(player)
    playerInventories[player.UserId] = nil
    lastSaveTime[player.UserId] = nil
end)

return InventoryManager

