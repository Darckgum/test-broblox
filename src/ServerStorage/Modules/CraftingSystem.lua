-- CraftingSystem.lua
-- Sistema de crafteo con recetas predefinidas y descubrimiento

local ItemDatabase = require(script.Parent.ItemDatabase)

local CraftingSystem = {}

-- Recetas predefinidas
local RECIPES = {
    {
        id = "wooden_sword",
        name = "Espada de Madera",
        result = "wooden_sword",
        resultQuantity = 1,
        materials = {
            {id = "wood", quantity = 5}
        },
        category = "Weapons",
        discovered = true -- Receta conocida desde el inicio
    },
    {
        id = "iron_sword", 
        name = "Espada de Hierro",
        result = "iron_sword",
        resultQuantity = 1,
        materials = {
            {id = "iron", quantity = 3},
            {id = "wood", quantity = 2}
        },
        category = "Weapons",
        discovered = true
    },
    {
        id = "golden_sword",
        name = "Espada Dorada", 
        result = "golden_sword",
        resultQuantity = 1,
        materials = {
            {id = "gold", quantity = 2},
            {id = "iron", quantity = 1}
        },
        category = "Weapons",
        discovered = false -- Se descubre al experimentar
    },
    {
        id = "bow",
        name = "Arco",
        result = "bow", 
        resultQuantity = 1,
        materials = {
            {id = "wood", quantity = 3},
            {id = "stone", quantity = 1}
        },
        category = "Weapons",
        discovered = true
    },
    {
        id = "health_potion",
        name = "Poción de Vida",
        result = "health_potion",
        resultQuantity = 1,
        materials = {
            {id = "crystal", quantity = 1},
            {id = "wood", quantity = 2}
        },
        category = "Consumables", 
        discovered = true
    },
    {
        id = "speed_potion",
        name = "Poción de Velocidad",
        result = "speed_potion",
        resultQuantity = 1,
        materials = {
            {id = "crystal", quantity = 2},
            {id = "iron", quantity = 1}
        },
        category = "Consumables",
        discovered = false
    },
    {
        id = "strength_potion", 
        name = "Poción de Fuerza",
        result = "strength_potion",
        resultQuantity = 1,
        materials = {
            {id = "crystal", quantity = 3},
            {id = "gold", quantity = 1}
        },
        category = "Consumables",
        discovered = false
    }
}

-- Recetas descubiertas por jugador
local discoveredRecipes = {}

-- Obtener recetas conocidas por un jugador
function CraftingSystem.getKnownRecipes(player)
    local playerId = player.UserId
    if not discoveredRecipes[playerId] then
        discoveredRecipes[playerId] = {}
    end
    
    local knownRecipes = {}
    for _, recipe in ipairs(RECIPES) do
        if recipe.discovered or discoveredRecipes[playerId][recipe.id] then
            table.insert(knownRecipes, recipe)
        end
    end
    
    return knownRecipes
end

-- Obtener todas las recetas (para admin)
function CraftingSystem.getAllRecipes()
    return RECIPES
end

-- Verificar si se puede craftear una receta
function CraftingSystem.canCraft(player, recipeId, inventoryManager)
    local recipe = nil
    for _, r in ipairs(RECIPES) do
        if r.id == recipeId then
            recipe = r
            break
        end
    end
    
    if not recipe then return false end
    
    -- Verificar si la receta es conocida
    local playerId = player.UserId
    if not recipe.discovered and not discoveredRecipes[playerId][recipe.id] then
        return false
    end
    
    -- Verificar materiales
    for _, material in ipairs(recipe.materials) do
        if not inventoryManager.hasItem(player, material.id, material.quantity) then
            return false
        end
    end
    
    return true
end

-- Craftear item
function CraftingSystem.craftItem(player, recipeId, inventoryManager)
    if not CraftingSystem.canCraft(player, recipeId, inventoryManager) then
        return false, "No se puede craftear esta receta"
    end
    
    local recipe = nil
    for _, r in ipairs(RECIPES) do
        if r.id == recipeId then
            recipe = r
            break
        end
    end
    
    -- Consumir materiales
    for _, material in ipairs(recipe.materials) do
        inventoryManager.removeItem(player, material.id, material.quantity)
    end
    
    -- Agregar resultado
    local success = inventoryManager.addItem(player, recipe.result, recipe.resultQuantity)
    
    if success then
        print("🔨", player.Name, "crafteó", recipe.name)
        return true, "¡" .. recipe.name .. " crafteado exitosamente!"
    else
        -- Devolver materiales si no se pudo agregar el resultado
        for _, material in ipairs(recipe.materials) do
            inventoryManager.addItem(player, material.id, material.quantity)
        end
        return false, "Inventario lleno"
    end
end

-- Intentar descubrir receta por experimentación
function CraftingSystem.tryDiscoverRecipe(player, materials)
    local playerId = player.UserId
    if not discoveredRecipes[playerId] then
        discoveredRecipes[playerId] = {}
    end
    
    -- Buscar receta que coincida con los materiales
    for _, recipe in ipairs(RECIPES) do
        if not recipe.discovered and not discoveredRecipes[playerId][recipe.id] then
            if CraftingSystem.materialsMatch(recipe.materials, materials) then
                discoveredRecipes[playerId][recipe.id] = true
                print("💡", player.Name, "descubrió la receta:", recipe.name)
                return recipe
            end
        end
    end
    
    return nil
end

-- Verificar si los materiales coinciden
function CraftingSystem.materialsMatch(recipeMaterials, playerMaterials)
    if #recipeMaterials ~= #playerMaterials then
        return false
    end
    
    -- Crear copias para no modificar los originales
    local recipeCopy = {}
    local playerCopy = {}
    
    for _, material in ipairs(recipeMaterials) do
        table.insert(recipeCopy, {id = material.id, quantity = material.quantity})
    end
    
    for _, material in ipairs(playerMaterials) do
        table.insert(playerCopy, {id = material.id, quantity = material.quantity})
    end
    
    -- Verificar cada material de la receta
    for _, recipeMat in ipairs(recipeCopy) do
        local found = false
        for i, playerMat in ipairs(playerCopy) do
            if recipeMat.id == playerMat.id and recipeMat.quantity == playerMat.quantity then
                table.remove(playerCopy, i)
                found = true
                break
            end
        end
        if not found then
            return false
        end
    end
    
    return #playerCopy == 0
end

-- Obtener recetas por categoría
function CraftingSystem.getRecipesByCategory(player, category)
    local knownRecipes = CraftingSystem.getKnownRecipes(player)
    local categoryRecipes = {}
    
    for _, recipe in ipairs(knownRecipes) do
        if recipe.category == category then
            table.insert(categoryRecipes, recipe)
        end
    end
    
    return categoryRecipes
end

-- Limpiar recetas descubiertas al desconectar
local Players = game:GetService("Players")
Players.PlayerRemoving:Connect(function(player)
    discoveredRecipes[player.UserId] = nil
end)

return CraftingSystem

