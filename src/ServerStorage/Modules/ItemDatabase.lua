-- ItemDatabase.lua
-- Base de datos de todos los items del juego

local ItemDatabase = {}

-- Colores de rareza
local RARITY_COLORS = {
    Common = Color3.fromRGB(150, 150, 150),    -- Gris
    Uncommon = Color3.fromRGB(0, 255, 0),      -- Verde
    Rare = Color3.fromRGB(0, 100, 255),        -- Azul
    Epic = Color3.fromRGB(150, 0, 255),        -- Morado
    Legendary = Color3.fromRGB(255, 215, 0)    -- Dorado
}

-- Categorías de items
local CATEGORIES = {
    "Materials",
    "Weapons", 
    "Consumables",
    "Tools",
    "Equipment"
}

-- Base de datos de items
local ITEMS = {
    -- MATERIALES
    {
        id = "wood",
        name = "Madera",
        description = "Material básico para crafteo",
        category = "Materials",
        rarity = "Common",
        stackable = true,
        maxStack = 999,
        icon = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    },
    {
        id = "stone",
        name = "Piedra", 
        description = "Piedra sólida para construcción",
        category = "Materials",
        rarity = "Common",
        stackable = true,
        maxStack = 999,
        icon = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    },
    {
        id = "iron",
        name = "Hierro",
        description = "Metal resistente para armas",
        category = "Materials", 
        rarity = "Uncommon",
        stackable = true,
        maxStack = 999,
        icon = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    },
    {
        id = "gold",
        name = "Oro",
        description = "Metal precioso y valioso",
        category = "Materials",
        rarity = "Rare", 
        stackable = true,
        maxStack = 999,
        icon = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    },
    {
        id = "crystal",
        name = "Cristal",
        description = "Cristal mágico con propiedades especiales",
        category = "Materials",
        rarity = "Epic",
        stackable = true,
        maxStack = 99,
        icon = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    },
    
    -- ARMAS
    {
        id = "wooden_sword",
        name = "Espada de Madera",
        description = "Espada básica de madera",
        category = "Weapons",
        rarity = "Common",
        stackable = false,
        maxStack = 1,
        icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        damage = 10
    },
    {
        id = "iron_sword", 
        name = "Espada de Hierro",
        description = "Espada resistente de hierro",
        category = "Weapons",
        rarity = "Uncommon",
        stackable = false,
        maxStack = 1,
        icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        damage = 25
    },
    {
        id = "golden_sword",
        name = "Espada Dorada", 
        description = "Espada de oro con gran poder",
        category = "Weapons",
        rarity = "Rare",
        stackable = false,
        maxStack = 1,
        icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        damage = 50
    },
    {
        id = "bow",
        name = "Arco",
        description = "Arco para atacar a distancia",
        category = "Weapons",
        rarity = "Uncommon", 
        stackable = false,
        maxStack = 1,
        icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        damage = 20
    },
    
    -- CONSUMIBLES
    {
        id = "health_potion",
        name = "Poción de Vida",
        description = "Restaura 50 puntos de vida",
        category = "Consumables",
        rarity = "Common",
        stackable = true,
        maxStack = 10,
        icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        healAmount = 50
    },
    {
        id = "speed_potion",
        name = "Poción de Velocidad", 
        description = "Aumenta la velocidad por 30 segundos",
        category = "Consumables",
        rarity = "Uncommon",
        stackable = true,
        maxStack = 5,
        icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        speedMultiplier = 1.5
    },
    {
        id = "strength_potion",
        name = "Poción de Fuerza",
        description = "Aumenta el daño por 60 segundos", 
        category = "Consumables",
        rarity = "Rare",
        stackable = true,
        maxStack = 3,
        icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        damageMultiplier = 2.0
    }
}

-- Funciones públicas
function ItemDatabase.getItemById(id)
    for _, item in ipairs(ITEMS) do
        if item.id == id then
            return item
        end
    end
    return nil
end

function ItemDatabase.getAllItems()
    return ITEMS
end

function ItemDatabase.getItemsByCategory(category)
    local items = {}
    for _, item in ipairs(ITEMS) do
        if item.category == category then
            table.insert(items, item)
        end
    end
    return items
end

function ItemDatabase.getCategories()
    return CATEGORIES
end

function ItemDatabase.getRarityColor(rarity)
    return RARITY_COLORS[rarity] or RARITY_COLORS.Common
end

function ItemDatabase.getItemRarityColor(itemId)
    local item = ItemDatabase.getItemById(itemId)
    if item then
        return ItemDatabase.getRarityColor(item.rarity)
    end
    return RARITY_COLORS.Common
end

return ItemDatabase

