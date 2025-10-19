-- Base de datos de items del RPG
local ItemDatabase = {}

-- Colores de raridad
ItemDatabase.RarityColors = {
    Common = Color3.fromRGB(150, 150, 150),    -- Gris
    Rare = Color3.fromRGB(0, 112, 221),        -- Azul
    Epic = Color3.fromRGB(163, 53, 238),       -- Morado
    Legendary = Color3.fromRGB(255, 128, 0)    -- Dorado/Naranja
}

-- Categorías de items
ItemDatabase.Categories = {
    Weapon = "Weapon",
    Consumable = "Consumable",
    Miscellaneous = "Miscellaneous"
}

-- Base de datos de items
ItemDatabase.Items = {
    -- ARMAS
    ["branch"] = {
        id = "branch",
        name = "Rama",
        description = "Una simple rama. Mejor que nada.",
        category = "Weapon",
        rarity = "Common",
        stackable = false,
        maxStack = 1,
        icon = "🌿", -- Emoji temporal, puedes reemplazar con ID de imagen
        -- Stats de arma
        damage = 5,
        attackSpeed = 1.0,
        weaponType = "Melee"
    },
    
    ["wooden_sword"] = {
        id = "wooden_sword",
        name = "Espada de Madera",
        description = "Una espada simple hecha de madera. Sorprendentemente efectiva.",
        category = "Weapon",
        rarity = "Rare",
        stackable = false,
        maxStack = 1,
        icon = "⚔️",
        -- Stats de arma
        damage = 10,
        attackSpeed = 1.2,
        weaponType = "Melee"
    },
    
    ["iron_sword"] = {
        id = "iron_sword",
        name = "Espada de Hierro",
        description = "Una espada forjada en hierro. Causa daño considerable.",
        category = "Weapon",
        rarity = "Epic",
        stackable = false,
        maxStack = 1,
        icon = "🗡️",
        -- Stats de arma
        damage = 20,
        attackSpeed = 1.3,
        weaponType = "Melee"
    },
    
    -- CONSUMIBLES
    ["small_health_potion"] = {
        id = "small_health_potion",
        name = "Poción Pequeña de Vida",
        description = "Restaura 20 puntos de vida.",
        category = "Consumable",
        rarity = "Common",
        stackable = true,
        maxStack = 10,
        icon = "🧪",
        -- Efecto
        effectType = "heal",
        effectValue = 20
    },
    
    ["medium_health_potion"] = {
        id = "medium_health_potion",
        name = "Poción Mediana de Vida",
        description = "Restaura 50 puntos de vida.",
        category = "Consumable",
        rarity = "Rare",
        stackable = true,
        maxStack = 10,
        icon = "🧪",
        -- Efecto
        effectType = "heal",
        effectValue = 50
    },
    
    ["large_health_potion"] = {
        id = "large_health_potion",
        name = "Poción Grande de Vida",
        description = "Restaura 100 puntos de vida.",
        category = "Consumable",
        rarity = "Epic",
        stackable = true,
        maxStack = 10,
        icon = "🧪",
        -- Efecto
        effectType = "heal",
        effectValue = 100
    },
    
    -- MISCELÁNEOS
    ["gold_coin"] = {
        id = "gold_coin",
        name = "Moneda de Oro",
        description = "Moneda de oro. Se usa para comerciar.",
        category = "Miscellaneous",
        rarity = "Common",
        stackable = true,
        maxStack = 999,
        icon = "🪙"
    },
    
    ["wood"] = {
        id = "wood",
        name = "Madera",
        description = "Madera básica. Útil para craftear.",
        category = "Miscellaneous",
        rarity = "Common",
        stackable = true,
        maxStack = 50,
        icon = "🪵"
    },
    
    ["iron_ore"] = {
        id = "iron_ore",
        name = "Mineral de Hierro",
        description = "Mineral sin refinar. Se puede fundir.",
        category = "Miscellaneous",
        rarity = "Rare",
        stackable = true,
        maxStack = 50,
        icon = "⛏️"
    }
}

-- Función para obtener un item por ID
function ItemDatabase.getItem(itemId)
    return ItemDatabase.Items[itemId]
end

-- Función para verificar si un item existe
function ItemDatabase.itemExists(itemId)
    return ItemDatabase.Items[itemId] ~= nil
end

-- Función para obtener el color de una raridad
function ItemDatabase.getRarityColor(rarity)
    return ItemDatabase.RarityColors[rarity] or ItemDatabase.RarityColors.Common
end

-- Función para obtener todos los items de una categoría
function ItemDatabase.getItemsByCategory(category)
    local items = {}
    for id, item in pairs(ItemDatabase.Items) do
        if item.category == category then
            table.insert(items, item)
        end
    end
    return items
end

return ItemDatabase

