-- Base de Datos de Items para RPG
-- Contiene todos los items disponibles en el juego

local ItemDatabase = {}

-- Tipos de items
ItemDatabase.TYPES = {
    WEAPON = "Weapon",
    ARMOR = "Armor",
    CONSUMABLE = "Consumable",
    MATERIAL = "Material",
    QUEST = "Quest"
}

-- Raridades
ItemDatabase.RARITIES = {
    COMMON = "Common",
    UNCOMMON = "Uncommon", 
    RARE = "Rare",
    EPIC = "Epic",
    LEGENDARY = "Legendary"
}

-- Base de datos de items
ItemDatabase.ITEMS = {
    -- Armas
    ["Iron Sword"] = {
        Name = "Iron Sword",
        Type = ItemDatabase.TYPES.WEAPON,
        Rarity = ItemDatabase.RARITIES.COMMON,
        Damage = 15,
        Description = "Una espada de hierro básica",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = false,
        Equippable = true,
        Value = 50
    },
    
    ["Steel Sword"] = {
        Name = "Steel Sword",
        Type = ItemDatabase.TYPES.WEAPON,
        Rarity = ItemDatabase.RARITIES.UNCOMMON,
        Damage = 25,
        Description = "Una espada de acero más resistente",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = false,
        Equippable = true,
        Value = 150
    },
    
    ["Magic Staff"] = {
        Name = "Magic Staff",
        Type = ItemDatabase.TYPES.WEAPON,
        Rarity = ItemDatabase.RARITIES.RARE,
        Damage = 20,
        MagicDamage = 30,
        Description = "Un bastón que canaliza energía mágica",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = false,
        Equippable = true,
        Value = 300
    },
    
    ["Dragon Blade"] = {
        Name = "Dragon Blade",
        Type = ItemDatabase.TYPES.WEAPON,
        Rarity = ItemDatabase.RARITIES.EPIC,
        Damage = 50,
        FireDamage = 20,
        Description = "Una espada forjada con escamas de dragón",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = false,
        Equippable = true,
        Value = 1000
    },
    
    -- Armadura
    ["Leather Armor"] = {
        Name = "Leather Armor",
        Type = ItemDatabase.TYPES.ARMOR,
        Rarity = ItemDatabase.RARITIES.COMMON,
        Defense = 5,
        Description = "Armadura básica de cuero",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = false,
        Equippable = true,
        Value = 75
    },
    
    ["Chain Mail"] = {
        Name = "Chain Mail",
        Type = ItemDatabase.TYPES.ARMOR,
        Rarity = ItemDatabase.RARITIES.UNCOMMON,
        Defense = 10,
        Description = "Cota de malla resistente",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = false,
        Equippable = true,
        Value = 200
    },
    
    ["Plate Armor"] = {
        Name = "Plate Armor",
        Type = ItemDatabase.TYPES.ARMOR,
        Rarity = ItemDatabase.RARITIES.RARE,
        Defense = 20,
        Description = "Armadura de placas de metal pesado",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = false,
        Equippable = true,
        Value = 500
    },
    
    -- Consumibles
    ["Health Potion"] = {
        Name = "Health Potion",
        Type = ItemDatabase.TYPES.CONSUMABLE,
        Rarity = ItemDatabase.RARITIES.COMMON,
        HealAmount = 50,
        Description = "Restaura 50 puntos de vida",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = true,
        MaxStack = 99,
        Equippable = false,
        Value = 25
    },
    
    ["Mana Potion"] = {
        Name = "Mana Potion",
        Type = ItemDatabase.TYPES.CONSUMABLE,
        Rarity = ItemDatabase.RARITIES.COMMON,
        ManaAmount = 30,
        Description = "Restaura 30 puntos de mana",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = true,
        MaxStack = 99,
        Equippable = false,
        Value = 20
    },
    
    ["Greater Health Potion"] = {
        Name = "Greater Health Potion",
        Type = ItemDatabase.TYPES.CONSUMABLE,
        Rarity = ItemDatabase.RARITIES.UNCOMMON,
        HealAmount = 100,
        Description = "Restaura 100 puntos de vida",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = true,
        MaxStack = 50,
        Equippable = false,
        Value = 75
    },
    
    ["Elixir of Life"] = {
        Name = "Elixir of Life",
        Type = ItemDatabase.TYPES.CONSUMABLE,
        Rarity = ItemDatabase.RARITIES.RARE,
        HealAmount = 200,
        ManaAmount = 100,
        Description = "Un elixir mágico que restaura vida y mana",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = true,
        MaxStack = 10,
        Equippable = false,
        Value = 300
    },
    
    -- Materiales
    ["Iron Ore"] = {
        Name = "Iron Ore",
        Type = ItemDatabase.TYPES.MATERIAL,
        Rarity = ItemDatabase.RARITIES.COMMON,
        Description = "Mineral de hierro usado para forjar",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = true,
        MaxStack = 999,
        Equippable = false,
        Value = 5
    },
    
    ["Wood"] = {
        Name = "Wood",
        Type = ItemDatabase.TYPES.MATERIAL,
        Rarity = ItemDatabase.RARITIES.COMMON,
        Description = "Madera obtenida de talar árboles",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = true,
        MaxStack = 999,
        Equippable = false,
        Value = 2
    },
    
    ["Tree Sap"] = {
        Name = "Tree Sap",
        Type = ItemDatabase.TYPES.MATERIAL,
        Rarity = ItemDatabase.RARITIES.COMMON,
        Description = "Savia de árbol usada para crear pociones",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = true,
        MaxStack = 999,
        Equippable = false,
        Value = 3
    },
    
    ["Magic Crystal"] = {
        Name = "Magic Crystal",
        Type = ItemDatabase.TYPES.MATERIAL,
        Rarity = ItemDatabase.RARITIES.RARE,
        Description = "Cristal mágico con propiedades especiales",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = true,
        MaxStack = 50,
        Equippable = false,
        Value = 100
    },
    
    ["Dragon Scale"] = {
        Name = "Dragon Scale",
        Type = ItemDatabase.TYPES.MATERIAL,
        Rarity = ItemDatabase.RARITIES.EPIC,
        Description = "Escama de dragón extremadamente rara",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = true,
        MaxStack = 10,
        Equippable = false,
        Value = 500
    },
    
    -- Items de Quest
    ["Ancient Key"] = {
        Name = "Ancient Key",
        Type = ItemDatabase.TYPES.QUEST,
        Rarity = ItemDatabase.RARITIES.RARE,
        Description = "Una llave antigua para abrir puertas misteriosas",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = false,
        Equippable = false,
        Value = 0
    },
    
    ["Crystal Fragment"] = {
        Name = "Crystal Fragment",
        Type = ItemDatabase.TYPES.QUEST,
        Rarity = ItemDatabase.RARITIES.UNCOMMON,
        Description = "Fragmento de cristal necesario para una quest",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Stackable = true,
        MaxStack = 5,
        Equippable = false,
        Value = 0
    }
}

-- Función para obtener item por nombre
function ItemDatabase.GetItem(itemName)
    return ItemDatabase.ITEMS[itemName]
end

-- Función para obtener todos los items
function ItemDatabase.GetAllItems()
    return ItemDatabase.ITEMS
end

-- Función para obtener items por tipo
function ItemDatabase.GetItemsByType(itemType)
    local items = {}
    for name, data in pairs(ItemDatabase.ITEMS) do
        if data.Type == itemType then
            items[name] = data
        end
    end
    return items
end

-- Función para obtener items por rareza
function ItemDatabase.GetItemsByRarity(rarity)
    local items = {}
    for name, data in pairs(ItemDatabase.ITEMS) do
        if data.Rarity == rarity then
            items[name] = data
        end
    end
    return items
end

-- Función para obtener items equipables
function ItemDatabase.GetEquippableItems()
    local items = {}
    for name, data in pairs(ItemDatabase.ITEMS) do
        if data.Equippable then
            items[name] = data
        end
    end
    return items
end

-- Función para obtener items consumibles
function ItemDatabase.GetConsumableItems()
    local items = {}
    for name, data in pairs(ItemDatabase.ITEMS) do
        if data.Type == ItemDatabase.TYPES.CONSUMABLE then
            items[name] = data
        end
    end
    return items
end

-- Función para obtener items por nivel requerido
function ItemDatabase.GetItemsByLevel(level)
    local items = {}
    for name, data in pairs(ItemDatabase.ITEMS) do
        local requiredLevel = data.LevelRequired or 1
        if requiredLevel <= level then
            items[name] = data
        end
    end
    return items
end

-- Función para verificar si un item existe
function ItemDatabase.ItemExists(itemName)
    return ItemDatabase.ITEMS[itemName] ~= nil
end

-- Función para obtener el valor total de un inventario
function ItemDatabase.CalculateInventoryValue(inventory)
    local totalValue = 0
    for slot, item in pairs(inventory) do
        if item and item.Data then
            totalValue = totalValue + (item.Data.Value * item.Quantity)
        end
    end
    return totalValue
end

-- Función para generar item aleatorio por rareza
function ItemDatabase.GenerateRandomItem(rarity)
    local itemsOfRarity = ItemDatabase.GetItemsByRarity(rarity)
    local itemNames = {}
    
    for name, _ in pairs(itemsOfRarity) do
        table.insert(itemNames, name)
    end
    
    if #itemNames > 0 then
        local randomIndex = math.random(1, #itemNames)
        return itemNames[randomIndex]
    end
    
    return nil
end

-- Función para obtener información de crafting (si se implementa)
function ItemDatabase.GetCraftingRecipe(itemName)
    local item = ItemDatabase.GetItem(itemName)
    if item and item.CraftingRecipe then
        return item.CraftingRecipe
    end
    return nil
end

return ItemDatabase
