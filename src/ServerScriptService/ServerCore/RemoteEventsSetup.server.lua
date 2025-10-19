-- Configuración de RemoteEvents para el Sistema de Vida
-- Maneja la comunicación entre cliente y servidor

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Crear carpeta para RemoteEvents
local remoteEventsFolder = ReplicatedStorage:FindFirstChild("RemoteEvents")
if not remoteEventsFolder then
    remoteEventsFolder = Instance.new("Folder")
    remoteEventsFolder.Name = "RemoteEvents"
    remoteEventsFolder.Parent = ReplicatedStorage
end

-- RemoteEvent: DamagePlayer (Servidor → Cliente)
-- Notifica al cliente que el jugador recibió daño
local damagePlayerEvent = remoteEventsFolder:FindFirstChild("DamagePlayer")
if not damagePlayerEvent then
    damagePlayerEvent = Instance.new("RemoteEvent")
    damagePlayerEvent.Name = "DamagePlayer"
    damagePlayerEvent.Parent = remoteEventsFolder
end

-- RemoteEvent: RequestRespawn (Cliente → Servidor)
-- El cliente solicita respawnear al servidor
local requestRespawnEvent = remoteEventsFolder:FindFirstChild("RequestRespawn")
if not requestRespawnEvent then
    requestRespawnEvent = Instance.new("RemoteEvent")
    requestRespawnEvent.Name = "RequestRespawn"
    requestRespawnEvent.Parent = remoteEventsFolder
end

-- RemoteEvent: UpdateMaxHealth (Servidor → Cliente)
-- Notifica al cliente que la vida máxima cambió
local updateMaxHealthEvent = remoteEventsFolder:FindFirstChild("UpdateMaxHealth")
if not updateMaxHealthEvent then
    updateMaxHealthEvent = Instance.new("RemoteEvent")
    updateMaxHealthEvent.Name = "UpdateMaxHealth"
    updateMaxHealthEvent.Parent = remoteEventsFolder
end

-- RemoteEvent: PlayerDied (Servidor → Cliente)
-- Notifica al cliente que el jugador murió
local playerDiedEvent = remoteEventsFolder:FindFirstChild("PlayerDied")
if not playerDiedEvent then
    playerDiedEvent = Instance.new("RemoteEvent")
    playerDiedEvent.Name = "PlayerDied"
    playerDiedEvent.Parent = remoteEventsFolder
end

-- RemoteEvent: PlayerRespawned (Servidor → Cliente)
-- Notifica al cliente que el jugador respawneó
local playerRespawnedEvent = remoteEventsFolder:FindFirstChild("PlayerRespawned")
if not playerRespawnedEvent then
    playerRespawnedEvent = Instance.new("RemoteEvent")
    playerRespawnedEvent.Name = "PlayerRespawned"
    playerRespawnedEvent.Parent = remoteEventsFolder
end

-- Función para obtener un RemoteEvent por nombre
local function getRemoteEvent(eventName)
    return remoteEventsFolder:FindFirstChild(eventName)
end

-- Exportar los RemoteEvents para uso en otros scripts
local RemoteEvents = {
    DamagePlayer = damagePlayerEvent,
    RequestRespawn = requestRespawnEvent,
    UpdateMaxHealth = updateMaxHealthEvent,
    PlayerDied = playerDiedEvent,
    PlayerRespawned = playerRespawnedEvent,
    GetEvent = getRemoteEvent
}

print("RemoteEvents configurados correctamente:")
print("- DamagePlayer: " .. tostring(damagePlayerEvent))
print("- RequestRespawn: " .. tostring(requestRespawnEvent))
print("- UpdateMaxHealth: " .. tostring(updateMaxHealthEvent))
print("- PlayerDied: " .. tostring(playerDiedEvent))
print("- PlayerRespawned: " .. tostring(playerRespawnedEvent))

return RemoteEvents
