-- Sistema de Inventario para RPG
-- Maneja items, equipamiento y objetos del jugador

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Módulo de Inventario
local InventorySystem = {}

-- Tipos de items disponibles
local ITEM_TYPES = {
    WEAPON = "Weapon",
    ARMOR = "Armor", 
    CONSUMABLE = "Consumable",
    MATERIAL = "Material",
    QUEST = "Quest"
}

-- Base de datos de items
local ITEM_DATABASE = {
    -- Armas
    ["Iron Sword"] = {
        Name = "Iron Sword",
        Type = ITEM_TYPES.WEAPON,
        Rarity = "Common",
        Damage = 15,
        Description = "Una espada de hierro básica",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = false,
        Equippable = true
    },
    ["Steel Sword"] = {
        Name = "Steel Sword", 
        Type = ITEM_TYPES.WEAPON,
        Rarity = "Uncommon",
        Damage = 25,
        Description = "Una espada de acero más resistente",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = false,
        Equippable = true
    },
    ["Magic Staff"] = {
        Name = "Magic Staff",
        Type = ITEM_TYPES.WEAPON,
        Rarity = "Rare",
        Damage = 20,
        MagicDamage = 30,
        Description = "Un bastón que canaliza energía mágica",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = false,
        Equippable = true
    },
    
    -- Armadura
    ["Leather Armor"] = {
        Name = "Leather Armor",
        Type = ITEM_TYPES.ARMOR,
        Rarity = "Common",
        Defense = 5,
        Description = "Armadura básica de cuero",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = false,
        Equippable = true
    },
    ["Chain Mail"] = {
        Name = "Chain Mail",
        Type = ITEM_TYPES.ARMOR,
        Rarity = "Uncommon", 
        Defense = 10,
        Description = "Cota de malla resistente",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = false,
        Equippable = true
    },
    
    -- Consumibles
    ["Health Potion"] = {
        Name = "Health Potion",
        Type = ITEM_TYPES.CONSUMABLE,
        Rarity = "Common",
        HealAmount = 50,
        Description = "Restaura 50 puntos de vida",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = true,
        MaxStack = 99,
        Equippable = false
    },
    ["Mana Potion"] = {
        Name = "Mana Potion", 
        Type = ITEM_TYPES.CONSUMABLE,
        Rarity = "Common",
        ManaAmount = 30,
        Description = "Restaura 30 puntos de mana",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = true,
        MaxStack = 99,
        Equippable = false
    },
    ["Greater Health Potion"] = {
        Name = "Greater Health Potion",
        Type = ITEM_TYPES.CONSUMABLE,
        Rarity = "Uncommon",
        HealAmount = 100,
        Description = "Restaura 100 puntos de vida",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = true,
        MaxStack = 50,
        Equippable = false
    },
    
    -- Materiales
    ["Iron Ore"] = {
        Name = "Iron Ore",
        Type = ITEM_TYPES.MATERIAL,
        Rarity = "Common",
        Description = "Mineral de hierro usado para forjar",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = true,
        MaxStack = 999,
        Equippable = false
    },
    ["Magic Crystal"] = {
        Name = "Magic Crystal",
        Type = ITEM_TYPES.MATERIAL,
        Rarity = "Rare",
        Description = "Cristal mágico con propiedades especiales",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = true,
        MaxStack = 50,
        Equippable = false
    }
}

-- Configuración del inventario
local INVENTORY_SIZE = 30
local EQUIPMENT_SLOTS = {
    Weapon = "Weapon",
    Armor = "Armor",
    Accessory = "Accessory"
}

-- Tabla para almacenar inventarios de jugadores
local playerInventories = {}
local playerEquipment = {}

-- Función para inicializar inventario de un jugador
function InventorySystem.InitializePlayer(player)
    playerInventories[player.UserId] = {}
    playerEquipment[player.UserId] = {
        Weapon = nil,
        Armor = nil,
        Accessory = nil
    }
    
    -- Dar items iniciales
    InventorySystem.AddItem(player, "Iron Sword", 1)
    InventorySystem.AddItem(player, "Leather Armor", 1)
    InventorySystem.AddItem(player, "Health Potion", 5)
    InventorySystem.AddItem(player, "Mana Potion", 3)
    
    print("Inventario inicializado para " .. player.Name)
end

-- Función para obtener inventario de un jugador
function InventorySystem.GetInventory(player)
    return playerInventories[player.UserId] or {}
end

-- Función para obtener equipamiento de un jugador
function InventorySystem.GetEquipment(player)
    return playerEquipment[player.UserId] or {}
end

-- Función para agregar un item al inventario
function InventorySystem.AddItem(player, itemName, quantity)
    local inventory = playerInventories[player.UserId]
    if not inventory then return false end
    
    local itemData = ITEM_DATABASE[itemName]
    if not itemData then 
        print("Item no encontrado: " .. itemName)
        return false 
    end
    
    -- Si el item es apilable, buscar si ya existe en el inventario
    if itemData.Stackable then
        for slot, item in pairs(inventory) do
            if item.Name == itemName and item.Quantity < itemData.MaxStack then
                local canAdd = math.min(quantity, itemData.MaxStack - item.Quantity)
                item.Quantity = item.Quantity + canAdd
                quantity = quantity - canAdd
                
                if quantity <= 0 then
                    return true
                end
            end
        end
    end
    
    -- Buscar slot vacío para agregar el item
    while quantity > 0 do
        local emptySlot = InventorySystem.FindEmptySlot(player)
        if not emptySlot then
            print("Inventario lleno para " .. player.Name)
            return false
        end
        
        local addQuantity = itemData.Stackable and math.min(quantity, itemData.MaxStack) or 1
        
        inventory[emptySlot] = {
            Name = itemName,
            Quantity = addQuantity,
            Data = itemData
        }
        
        quantity = quantity - addQuantity
    end
    
    print("Agregado " .. itemName .. " x" .. quantity .. " al inventario de " .. player.Name)
    return true
end

-- Función para encontrar un slot vacío
function InventorySystem.FindEmptySlot(player)
    local inventory = playerInventories[player.UserId]
    if not inventory then return nil end
    
    for i = 1, INVENTORY_SIZE do
        if not inventory[i] then
            return i
        end
    end
    
    return nil
end

-- Función para remover un item del inventario
function InventorySystem.RemoveItem(player, itemName, quantity)
    local inventory = playerInventories[player.UserId]
    if not inventory then return false end
    
    local removed = 0
    
    for slot, item in pairs(inventory) do
        if item.Name == itemName then
            local removeAmount = math.min(quantity - removed, item.Quantity)
            item.Quantity = item.Quantity - removeAmount
            removed = removed + removeAmount
            
            if item.Quantity <= 0 then
                inventory[slot] = nil
            end
            
            if removed >= quantity then
                break
            end
        end
    end
    
    return removed >= quantity
end

-- Función para equipar un item
function InventorySystem.EquipItem(player, slot)
    local inventory = playerInventories[player.UserId]
    local equipment = playerEquipment[player.UserId]
    
    if not inventory or not equipment then return false end
    
    local item = inventory[slot]
    if not item or not item.Data.Equippable then return false end
    
    local itemType = item.Data.Type
    
    -- Desequipar item actual si existe
    if equipment[itemType] then
        InventorySystem.UnequipItem(player, itemType)
    end
    
    -- Equipar nuevo item
    equipment[itemType] = item
    inventory[slot] = nil
    
    -- Aplicar efectos del equipamiento
    InventorySystem.ApplyEquipmentEffects(player, item.Data)
    
    print(player.Name .. " equipó " .. item.Name)
    return true
end

-- Función para desequipar un item
function InventorySystem.UnequipItem(player, itemType)
    local inventory = playerInventories[player.UserId]
    local equipment = playerEquipment[player.UserId]
    
    if not inventory or not equipment then return false end
    
    local equippedItem = equipment[itemType]
    if not equippedItem then return false end
    
    -- Buscar slot vacío en inventario
    local emptySlot = InventorySystem.FindEmptySlot(player)
    if not emptySlot then
        print("No hay espacio en inventario para desequipar")
        return false
    end
    
    -- Remover efectos del equipamiento
    InventorySystem.RemoveEquipmentEffects(player, equippedItem.Data)
    
    -- Mover item de vuelta al inventario
    inventory[emptySlot] = equippedItem
    equipment[itemType] = nil
    
    print(player.Name .. " desequipó " .. equippedItem.Name)
    return true
end

-- Función para aplicar efectos del equipamiento
function InventorySystem.ApplyEquipmentEffects(player, itemData)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Aplicar efectos según el tipo de item
    if itemData.Type == ITEM_TYPES.WEAPON then
        -- Los efectos de arma se aplican en el sistema de combate
    elseif itemData.Type == ITEM_TYPES.ARMOR then
        -- Los efectos de armadura se aplican en el sistema de stats
    end
end

-- Función para remover efectos del equipamiento
function InventorySystem.RemoveEquipmentEffects(player, itemData)
    -- Implementar lógica para remover efectos
end

-- Función para usar un consumible
function InventorySystem.UseConsumable(player, slot)
    local inventory = playerInventories[player.UserId]
    if not inventory then return false end
    
    local item = inventory[slot]
    if not item or item.Data.Type ~= ITEM_TYPES.CONSUMABLE then return false end
    
    local itemData = item.Data
    
    -- Aplicar efectos del consumible
    if itemData.HealAmount then
        -- Usar el sistema de stats para curar
        local PlayerStats = require(script.Parent.PlayerStats)
        PlayerStats.Heal(player, itemData.HealAmount)
    end
    
    if itemData.ManaAmount then
        -- Usar el sistema de stats para restaurar mana
        local PlayerStats = require(script.Parent.PlayerStats)
        PlayerStats.RestoreMana(player, itemData.ManaAmount)
    end
    
    -- Reducir cantidad del item
    item.Quantity = item.Quantity - 1
    if item.Quantity <= 0 then
        inventory[slot] = nil
    end
    
    print(player.Name .. " usó " .. item.Name)
    return true
end

-- Función para obtener información de un item
function InventorySystem.GetItemData(itemName)
    return ITEM_DATABASE[itemName]
end

-- Función para obtener todos los items disponibles
function InventorySystem.GetAllItems()
    return ITEM_DATABASE
end

-- Función para verificar si un jugador tiene un item
function InventorySystem.HasItem(player, itemName, quantity)
    quantity = quantity or 1
    local inventory = playerInventories[player.UserId]
    if not inventory then return false end
    
    local totalQuantity = 0
    for slot, item in pairs(inventory) do
        if item.Name == itemName then
            totalQuantity = totalQuantity + item.Quantity
        end
    end
    
    return totalQuantity >= quantity
end

-- Función para obtener el daño total del equipamiento
function InventorySystem.GetTotalDamage(player)
    local equipment = playerEquipment[player.UserId]
    if not equipment then return 0 end
    
    local totalDamage = 0
    
    if equipment.Weapon and equipment.Weapon.Data.Damage then
        totalDamage = totalDamage + equipment.Weapon.Data.Damage
    end
    
    return totalDamage
end

-- Función para obtener la defensa total del equipamiento
function InventorySystem.GetTotalDefense(player)
    local equipment = playerEquipment[player.UserId]
    if not equipment then return 0 end
    
    local totalDefense = 0
    
    if equipment.Armor and equipment.Armor.Data.Defense then
        totalDefense = totalDefense + equipment.Armor.Data.Defense
    end
    
    return totalDefense
end

-- Limpiar datos cuando un jugador se va
Players.PlayerRemoving:Connect(function(player)
    playerInventories[player.UserId] = nil
    playerEquipment[player.UserId] = nil
end)

-- Exportar el módulo
return InventorySystem
