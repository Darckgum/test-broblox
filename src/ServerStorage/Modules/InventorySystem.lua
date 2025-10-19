-- Sistema de inventario para el RPG
local InventorySystem = {}

local ItemDatabase = require(script.Parent.ItemDatabase)
local Players = game:GetService("Players")

-- Almacenamiento de inventarios de jugadores
local playerInventories = {}

-- Configuración
local INVENTORY_SIZE = 20

-- Función para crear un inventario vacío
function InventorySystem.createInventory(player)
    print("🎒 Creando inventario para:", player.Name)
    
    local inventory = {
        slots = {},
        equippedWeapon = nil,
        size = INVENTORY_SIZE
    }
    
    -- Inicializar slots vacíos
    for i = 1, INVENTORY_SIZE do
        inventory.slots[i] = {
            itemId = nil,
            quantity = 0
        }
    end
    
    playerInventories[player.UserId] = inventory
    print("✅ Inventario creado con", INVENTORY_SIZE, "slots")
    
    return inventory
end

-- Función para obtener el inventario de un jugador
function InventorySystem.getInventory(player)
    return playerInventories[player.UserId]
end

-- Función para encontrar un slot vacío
local function findEmptySlot(inventory)
    for i, slot in ipairs(inventory.slots) do
        if slot.itemId == nil then
            return i
        end
    end
    return nil
end

-- Función para encontrar un item stackable existente
local function findStackableSlot(inventory, itemId)
    local itemData = ItemDatabase.getItem(itemId)
    if not itemData or not itemData.stackable then
        return nil
    end
    
    for i, slot in ipairs(inventory.slots) do
        if slot.itemId == itemId and slot.quantity < itemData.maxStack then
            return i
        end
    end
    return nil
end

-- Función para agregar un item al inventario
function InventorySystem.addItem(player, itemId, quantity)
    quantity = quantity or 1
    
    if not ItemDatabase.itemExists(itemId) then
        warn("⚠️ Item no existe:", itemId)
        return false
    end
    
    local inventory = InventorySystem.getInventory(player)
    if not inventory then
        warn("⚠️ Inventario no encontrado para:", player.Name)
        return false
    end
    
    local itemData = ItemDatabase.getItem(itemId)
    local remainingQuantity = quantity
    
    print("📦 Agregando", quantity, "x", itemData.name, "al inventario de", player.Name)
    
    -- Si es stackable, intentar agregar a slots existentes primero
    if itemData.stackable then
        while remainingQuantity > 0 do
            local stackSlot = findStackableSlot(inventory, itemId)
            
            if stackSlot then
                local slot = inventory.slots[stackSlot]
                local spaceAvailable = itemData.maxStack - slot.quantity
                local toAdd = math.min(spaceAvailable, remainingQuantity)
                
                slot.quantity = slot.quantity + toAdd
                remainingQuantity = remainingQuantity - toAdd
                
                print("  ➕ Agregado", toAdd, "al slot", stackSlot, "(total:", slot.quantity .. ")")
            else
                -- No hay más slots con este item, crear nuevo slot
                local emptySlot = findEmptySlot(inventory)
                if emptySlot then
                    local toAdd = math.min(itemData.maxStack, remainingQuantity)
                    inventory.slots[emptySlot] = {
                        itemId = itemId,
                        quantity = toAdd
                    }
                    remainingQuantity = remainingQuantity - toAdd
                    print("  ➕ Creado nuevo slot", emptySlot, "con", toAdd, "items")
                else
                    print("⚠️ Inventario lleno, no se pudieron agregar", remainingQuantity, "items")
                    break
                end
            end
        end
    else
        -- Item no stackable, agregar a slot vacío
        for i = 1, quantity do
            local emptySlot = findEmptySlot(inventory)
            if emptySlot then
                inventory.slots[emptySlot] = {
                    itemId = itemId,
                    quantity = 1
                }
                remainingQuantity = remainingQuantity - 1
                print("  ➕ Agregado al slot", emptySlot)
            else
                print("⚠️ Inventario lleno")
                break
            end
        end
    end
    
    local added = quantity - remainingQuantity
    print("✅ Se agregaron", added, "items. Restantes:", remainingQuantity)
    
    -- Sincronizar con el cliente
    InventorySystem.syncInventory(player)
    
    return added > 0
end

-- Función para remover un item del inventario
function InventorySystem.removeItem(player, slot, quantity)
    quantity = quantity or 1
    
    local inventory = InventorySystem.getInventory(player)
    if not inventory then return false end
    
    if slot < 1 or slot > INVENTORY_SIZE then
        warn("⚠️ Slot inválido:", slot)
        return false
    end
    
    local slotData = inventory.slots[slot]
    if not slotData.itemId then
        warn("⚠️ Slot vacío:", slot)
        return false
    end
    
    local itemData = ItemDatabase.getItem(slotData.itemId)
    print("🗑️ Removiendo", quantity, "x", itemData.name, "del slot", slot)
    
    slotData.quantity = slotData.quantity - quantity
    
    if slotData.quantity <= 0 then
        inventory.slots[slot] = {
            itemId = nil,
            quantity = 0
        }
        print("  ✅ Slot", slot, "ahora vacío")
    else
        print("  ✅ Quedan", slotData.quantity, "en el slot", slot)
    end
    
    -- Sincronizar con el cliente
    InventorySystem.syncInventory(player)
    
    return true
end

-- Función para usar un item consumible
function InventorySystem.useItem(player, slot)
    local inventory = InventorySystem.getInventory(player)
    if not inventory then return false end
    
    local slotData = inventory.slots[slot]
    if not slotData.itemId then
        warn("⚠️ No hay item en el slot:", slot)
        return false
    end
    
    local itemData = ItemDatabase.getItem(slotData.itemId)
    
    if itemData.category ~= "Consumable" then
        warn("⚠️ Item no es consumible:", itemData.name)
        return false
    end
    
    print("💊 Usando", itemData.name)
    
    -- Aplicar efecto según el tipo
    if itemData.effectType == "heal" then
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            local health = leaderstats:FindFirstChild("Health")
            local level = leaderstats:FindFirstChild("Level")
            
            if health and level then
                local maxHealth = level.Value * 50
                local newHealth = math.min(maxHealth, health.Value + itemData.effectValue)
                local healed = newHealth - health.Value
                
                health.Value = newHealth
                
                -- Actualizar Humanoid si existe
                if player.Character then
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.Health = newHealth
                    end
                end
                
                print("  💚 Curado", healed, "HP. Vida actual:", newHealth)
            end
        end
    end
    
    -- Remover item del inventario
    InventorySystem.removeItem(player, slot, 1)
    
    return true
end

-- Función para equipar un arma
function InventorySystem.equipWeapon(player, slot)
    local inventory = InventorySystem.getInventory(player)
    if not inventory then return false end
    
    local slotData = inventory.slots[slot]
    if not slotData.itemId then
        warn("⚠️ No hay item en el slot:", slot)
        return false
    end
    
    local itemData = ItemDatabase.getItem(slotData.itemId)
    
    if itemData.category ~= "Weapon" then
        warn("⚠️ Item no es un arma:", itemData.name)
        return false
    end
    
    print("⚔️ Equipando", itemData.name)
    
    -- Si ya hay un arma equipada, desequiparla
    if inventory.equippedWeapon then
        InventorySystem.unequipWeapon(player)
    end
    
    -- Equipar nueva arma
    inventory.equippedWeapon = {
        itemId = slotData.itemId,
        slot = slot
    }
    
    -- Crear modelo del arma (simplificado por ahora)
    if player.Character then
        local character = player.Character
        local rightArm = character:FindFirstChild("Right Arm") or character:FindFirstChild("RightHand")
        
        if rightArm then
            -- Crear representación simple del arma
            local weapon = Instance.new("Part")
            weapon.Name = "EquippedWeapon"
            weapon.Size = Vector3.new(0.5, 3, 0.5)
            weapon.BrickColor = itemData.rarity == "Common" and BrickColor.new("Brown") or BrickColor.new("Medium stone grey")
            weapon.Material = Enum.Material.Wood
            weapon.CanCollide = false
            weapon.Parent = character
            
            -- Adjuntar al brazo
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = rightArm
            weld.Part1 = weapon
            weld.Parent = weapon
            
            -- Posicionar
            weapon.CFrame = rightArm.CFrame * CFrame.new(0, -2, 0)
            
            print("  ✅ Arma equipada visualmente")
        end
    end
    
    -- Guardar stats del arma en el jugador
    local stats = player:FindFirstChild("Stats")
    if not stats then
        stats = Instance.new("Folder")
        stats.Name = "Stats"
        stats.Parent = player
    end
    
    local damage = stats:FindFirstChild("Damage")
    if not damage then
        damage = Instance.new("IntValue")
        damage.Name = "Damage"
        damage.Parent = stats
    end
    damage.Value = itemData.damage
    
    print("  ✅ Daño actualizado a:", itemData.damage)
    
    -- Sincronizar con el cliente
    InventorySystem.syncInventory(player)
    
    return true
end

-- Función para desequipar un arma
function InventorySystem.unequipWeapon(player)
    local inventory = InventorySystem.getInventory(player)
    if not inventory or not inventory.equippedWeapon then
        return false
    end
    
    print("🔓 Desequipando arma")
    
    -- Remover modelo del arma
    if player.Character then
        local weapon = player.Character:FindFirstChild("EquippedWeapon")
        if weapon then
            weapon:Destroy()
        end
    end
    
    -- Resetear stats
    local stats = player:FindFirstChild("Stats")
    if stats then
        local damage = stats:FindFirstChild("Damage")
        if damage then
            damage.Value = 0
        end
    end
    
    inventory.equippedWeapon = nil
    
    -- Sincronizar con el cliente
    InventorySystem.syncInventory(player)
    
    return true
end

-- Función para obtener datos serializables del inventario
function InventorySystem.getInventoryData(player)
    local inventory = InventorySystem.getInventory(player)
    if not inventory then return nil end
    
    local data = {
        slots = {},
        equippedWeapon = inventory.equippedWeapon,
        size = inventory.size
    }
    
    for i, slot in ipairs(inventory.slots) do
        data.slots[i] = {
            itemId = slot.itemId,
            quantity = slot.quantity,
            itemData = slot.itemId and ItemDatabase.getItem(slot.itemId) or nil
        }
    end
    
    return data
end

-- Función para sincronizar inventario con el cliente
function InventorySystem.syncInventory(player)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local remoteEvent = ReplicatedStorage:FindFirstChild("UpdateInventory")
    
    if remoteEvent then
        local data = InventorySystem.getInventoryData(player)
        remoteEvent:FireClient(player, data)
        print("🔄 Inventario sincronizado con", player.Name)
    end
end

-- Limpiar inventario cuando el jugador se va
Players.PlayerRemoving:Connect(function(player)
    playerInventories[player.UserId] = nil
    print("🗑️ Inventario removido para:", player.Name)
end)

return InventorySystem

