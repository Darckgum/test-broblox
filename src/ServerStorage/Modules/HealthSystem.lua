-- Sistema de Vida Variable para Roblox RPG
-- Módulo para gestionar la vida máxima de los jugadores

local Players = game:GetService("Players")

local HealthSystem = {}

-- Configuración del sistema
local HEALTH_CONFIG = {
    BaseMaxHealth = 100,      -- Vida máxima base
    HealthPerLevel = 10,       -- Vida adicional por nivel
    MaxLevel = 50,            -- Nivel máximo
    RespawnHealth = 100       -- Vida al respawnear
}

-- Tabla para almacenar datos de vida de cada jugador
local playerHealthData = {}

-- Función para inicializar datos de vida de un jugador
function HealthSystem.InitializePlayer(player)
    local healthData = {
        MaxHealth = HEALTH_CONFIG.BaseMaxHealth,
        Level = 1,
        LastDamageTime = 0,
        IsDead = false
    }
    
    playerHealthData[player.UserId] = healthData
    
    -- Configurar Humanoid del jugador
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = healthData.MaxHealth
            humanoid.Health = healthData.MaxHealth
        end
    end
    
    print("Sistema de vida inicializado para " .. player.Name .. " - MaxHealth: " .. healthData.MaxHealth)
end

-- Función para obtener datos de vida de un jugador
function HealthSystem.GetHealthData(player)
    return playerHealthData[player.UserId]
end

-- Función para obtener la vida máxima de un jugador
function HealthSystem.GetMaxHealth(player)
    local data = playerHealthData[player.UserId]
    return data and data.MaxHealth or HEALTH_CONFIG.BaseMaxHealth
end

-- Función para establecer la vida máxima de un jugador
function HealthSystem.SetMaxHealth(player, newMaxHealth)
    local data = playerHealthData[player.UserId]
    if not data then return false end
    
    data.MaxHealth = math.max(1, newMaxHealth) -- Mínimo 1 HP
    
    -- Actualizar Humanoid si existe
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            local currentHealth = humanoid.Health
            humanoid.MaxHealth = data.MaxHealth
            
            -- Mantener el porcentaje de vida actual
            local healthPercentage = currentHealth / humanoid.MaxHealth
            humanoid.Health = math.min(data.MaxHealth, currentHealth)
        end
    end
    
    print(player.Name .. " - Nueva vida máxima: " .. data.MaxHealth)
    return true
end

-- Función para aumentar la vida máxima de un jugador
function HealthSystem.IncreaseMaxHealth(player, amount)
    local data = playerHealthData[player.UserId]
    if not data then return false end
    
    local newMaxHealth = data.MaxHealth + amount
    return HealthSystem.SetMaxHealth(player, newMaxHealth)
end

-- Función para establecer el nivel de un jugador
function HealthSystem.SetLevel(player, newLevel)
    local data = playerHealthData[player.UserId]
    if not data then return false end
    
    newLevel = math.max(1, math.min(newLevel, HEALTH_CONFIG.MaxLevel))
    data.Level = newLevel
    
    -- Calcular nueva vida máxima basada en nivel
    local newMaxHealth = HEALTH_CONFIG.BaseMaxHealth + (newLevel - 1) * HEALTH_CONFIG.HealthPerLevel
    HealthSystem.SetMaxHealth(player, newMaxHealth)
    
    print(player.Name .. " subió al nivel " .. newLevel .. " - Nueva vida máxima: " .. newMaxHealth)
    return true
end

-- Función para obtener el nivel de un jugador
function HealthSystem.GetLevel(player)
    local data = playerHealthData[player.UserId]
    return data and data.Level or 1
end

-- Función para registrar daño recibido
function HealthSystem.RegisterDamage(player, damageAmount)
    local data = playerHealthData[player.UserId]
    if not data then return end
    
    data.LastDamageTime = tick()
    data.IsDead = false
end

-- Función para manejar la muerte del jugador
function HealthSystem.HandleDeath(player)
    local data = playerHealthData[player.UserId]
    if not data then return end
    
    data.IsDead = true
    print(player.Name .. " ha muerto")
end

-- Función para respawnear un jugador
function HealthSystem.RespawnPlayer(player)
    local data = playerHealthData[player.UserId]
    if not data then return false end
    
    data.IsDead = false
    data.LastDamageTime = 0
    
    -- Esperar a que el personaje se cargue
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = data.MaxHealth
            humanoid.Health = HEALTH_CONFIG.RespawnHealth
        end
    end
    
    print(player.Name .. " respawneó con " .. HEALTH_CONFIG.RespawnHealth .. " HP")
    return true
end

-- Función para verificar si un jugador está muerto
function HealthSystem.IsDead(player)
    local data = playerHealthData[player.UserId]
    return data and data.IsDead or false
end

-- Función para obtener el tiempo desde el último daño
function HealthSystem.GetTimeSinceLastDamage(player)
    local data = playerHealthData[player.UserId]
    if not data then return math.huge end
    
    return tick() - data.LastDamageTime
end

-- Función para limpiar datos cuando un jugador se va
function HealthSystem.CleanupPlayer(player)
    playerHealthData[player.UserId] = nil
    print("Datos de vida limpiados para " .. player.Name)
end

-- Eventos para manejar jugadores
Players.PlayerRemoving:Connect(function(player)
    HealthSystem.CleanupPlayer(player)
end)

return HealthSystem
