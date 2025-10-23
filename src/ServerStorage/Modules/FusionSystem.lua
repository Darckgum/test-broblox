-- FusionSystem.lua
-- Sistema de fusión simple de items

local ItemDatabase = require(script.Parent.ItemDatabase)

local FusionSystem = {}

-- Configuración de fusión
local FUSION_RULES = {
    -- Armas se pueden fusionar con armas del mismo tipo
    ["wooden_sword"] = {
        result = "wooden_sword_plus",
        resultName = "Espada de Madera+",
        maxLevel = 5
    },
    ["iron_sword"] = {
        result = "iron_sword_plus", 
        resultName = "Espada de Hierro+",
        maxLevel = 5
    },
    ["golden_sword"] = {
        result = "golden_sword_plus",
        resultName = "Espada Dorada+", 
        maxLevel = 3
    },
    ["bow"] = {
        result = "bow_plus",
        resultName = "Arco+",
        maxLevel = 5
    }
}

-- Items fusionados (se crean dinámicamente)
local FUSED_ITEMS = {
    {
        id = "wooden_sword_plus",
        name = "Espada de Madera+",
        description = "Espada de madera mejorada",
        category = "Weapons",
        rarity = "Uncommon",
        stackable = false,
        maxStack = 1,
        icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        damage = 15,
        fusionLevel = 1
    },
    {
        id = "iron_sword_plus",
        name = "Espada de Hierro+", 
        description = "Espada de hierro mejorada",
        category = "Weapons",
        rarity = "Rare",
        stackable = false,
        maxStack = 1,
        icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        damage = 35,
        fusionLevel = 1
    },
    {
        id = "golden_sword_plus",
        name = "Espada Dorada+",
        description = "Espada dorada mejorada", 
        category = "Weapons",
        rarity = "Epic",
        stackable = false,
        maxStack = 1,
        icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        damage = 70,
        fusionLevel = 1
    },
    {
        id = "bow_plus",
        name = "Arco+",
        description = "Arco mejorado",
        category = "Weapons", 
        rarity = "Rare",
        stackable = false,
        maxStack = 1,
        icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        damage = 30,
        fusionLevel = 1
    }
}

-- Verificar si dos items se pueden fusionar
function FusionSystem.canFuse(item1Id, item2Id)
    -- Deben ser el mismo item
    if item1Id ~= item2Id then
        return false
    end
    
    -- Debe existir regla de fusión
    if not FUSION_RULES[item1Id] then
        return false
    end
    
    return true
end

-- Obtener resultado de fusión
function FusionSystem.getFusionResult(itemId)
    local rule = FUSION_RULES[itemId]
    if not rule then
        return nil
    end
    
    return {
        id = rule.result,
        name = rule.resultName,
        maxLevel = rule.maxLevel
    }
end

-- Fusionar dos items
function FusionSystem.fuseItems(player, item1Id, item2Id, inventoryManager)
    if not FusionSystem.canFuse(item1Id, item2Id) then
        return false, "Estos items no se pueden fusionar"
    end
    
    -- Verificar que el jugador tenga ambos items
    if not inventoryManager.hasItem(player, item1Id, 2) then
        return false, "No tienes suficientes items para fusionar"
    end
    
    local fusionResult = FusionSystem.getFusionResult(item1Id)
    if not fusionResult then
        return false, "Error en la fusión"
    end
    
    -- Remover los dos items originales
    inventoryManager.removeItem(player, item1Id, 2)
    
    -- Agregar el item fusionado
    local success = inventoryManager.addItem(player, fusionResult.id, 1)
    
    if success then
        print("✨", player.Name, "fusionó", item1Id, "→", fusionResult.name)
        return true, "¡" .. fusionResult.name .. " creado exitosamente!"
    else
        -- Devolver items si no se pudo agregar el resultado
        inventoryManager.addItem(player, item1Id, 2)
        return false, "Inventario lleno"
    end
end

-- Obtener información de fusión para un item
function FusionSystem.getFusionInfo(itemId)
    local rule = FUSION_RULES[itemId]
    if not rule then
        return nil
    end
    
    return {
        canFuse = true,
        resultId = rule.result,
        resultName = rule.resultName,
        maxLevel = rule.maxLevel,
        requiredItems = 2
    }
end

-- Obtener todos los items que se pueden fusionar
function FusionSystem.getFusableItems()
    local fusableItems = {}
    
    for itemId, rule in pairs(FUSION_RULES) do
        table.insert(fusableItems, {
            id = itemId,
            name = ItemDatabase.getItemById(itemId).name,
            resultId = rule.result,
            resultName = rule.resultName,
            maxLevel = rule.maxLevel
        })
    end
    
    return fusableItems
end

-- Obtener item fusionado por ID
function FusionSystem.getFusedItemById(itemId)
    for _, item in ipairs(FUSED_ITEMS) do
        if item.id == itemId then
            return item
        end
    end
    return nil
end

-- Obtener todos los items fusionados
function FusionSystem.getAllFusedItems()
    return FUSED_ITEMS
end

return FusionSystem

