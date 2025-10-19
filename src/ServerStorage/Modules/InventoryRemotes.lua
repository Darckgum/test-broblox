-- Sistema de RemoteEvents para el inventario
local InventoryRemotes = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InventorySystem = require(script.Parent.InventorySystem)

-- Crear carpeta para RemoteEvents si no existe
local function getOrCreateFolder()
    local folder = ReplicatedStorage:FindFirstChild("InventoryRemotes")
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = "InventoryRemotes"
        folder.Parent = ReplicatedStorage
    end
    return folder
end

-- Función para inicializar RemoteEvents
function InventoryRemotes.init()
    print("🔌 Inicializando RemoteEvents del inventario...")
    
    local folder = getOrCreateFolder()
    
    -- RemoteEvent para abrir/cerrar inventario
    local openInventory = folder:FindFirstChild("OpenInventory") or Instance.new("RemoteEvent")
    openInventory.Name = "OpenInventory"
    openInventory.Parent = folder
    
    -- RemoteEvent para usar items
    local useItem = folder:FindFirstChild("UseItem") or Instance.new("RemoteEvent")
    useItem.Name = "UseItem"
    useItem.Parent = folder
    
    useItem.OnServerEvent:Connect(function(player, slot)
        print("📨 Recibida solicitud de usar item del slot", slot, "de", player.Name)
        if typeof(slot) == "number" and slot >= 1 and slot <= 20 then
            InventorySystem.useItem(player, slot)
        else
            warn("⚠️ Slot inválido:", slot)
        end
    end)
    
    -- RemoteEvent para equipar armas
    local equipWeapon = folder:FindFirstChild("EquipWeapon") or Instance.new("RemoteEvent")
    equipWeapon.Name = "EquipWeapon"
    equipWeapon.Parent = folder
    
    equipWeapon.OnServerEvent:Connect(function(player, slot)
        print("📨 Recibida solicitud de equipar arma del slot", slot, "de", player.Name)
        if typeof(slot) == "number" and slot >= 1 and slot <= 20 then
            InventorySystem.equipWeapon(player, slot)
        else
            warn("⚠️ Slot inválido:", slot)
        end
    end)
    
    -- RemoteEvent para desequipar armas
    local unequipWeapon = folder:FindFirstChild("UnequipWeapon") or Instance.new("RemoteEvent")
    unequipWeapon.Name = "UnequipWeapon"
    unequipWeapon.Parent = folder
    
    unequipWeapon.OnServerEvent:Connect(function(player)
        print("📨 Recibida solicitud de desequipar arma de", player.Name)
        InventorySystem.unequipWeapon(player)
    end)
    
    -- RemoteEvent para tirar items
    local dropItem = folder:FindFirstChild("DropItem") or Instance.new("RemoteEvent")
    dropItem.Name = "DropItem"
    dropItem.Parent = folder
    
    dropItem.OnServerEvent:Connect(function(player, slot, quantity)
        print("📨 Recibida solicitud de tirar item del slot", slot, "de", player.Name)
        quantity = quantity or 1
        if typeof(slot) == "number" and slot >= 1 and slot <= 20 then
            InventorySystem.removeItem(player, slot, quantity)
        else
            warn("⚠️ Slot inválido:", slot)
        end
    end)
    
    -- RemoteEvent para actualizar inventario (servidor -> cliente)
    local updateInventory = folder:FindFirstChild("UpdateInventory") or Instance.new("RemoteEvent")
    updateInventory.Name = "UpdateInventory"
    updateInventory.Parent = folder
    
    -- RemoteFunction para solicitar datos del inventario
    local getInventory = folder:FindFirstChild("GetInventory") or Instance.new("RemoteFunction")
    getInventory.Name = "GetInventory"
    getInventory.Parent = folder
    
    getInventory.OnServerInvoke = function(player)
        print("📨 Solicitud de datos del inventario de", player.Name)
        return InventorySystem.getInventoryData(player)
    end
    
    print("✅ RemoteEvents del inventario inicializados")
end

return InventoryRemotes

