-- Sistema RPG para Roblox
-- Script principal de estadísticas del jugador

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Módulo de estadísticas del jugador
local PlayerStats = {}

-- Configuración inicial de stats
local DEFAULT_STATS = {
    Level = 1,
    Experience = 0,
    ExperienceToNext = 100,
    Health = 100,
    MaxHealth = 100,
    Mana = 50,
    MaxMana = 50,
    Strength = 10,      -- Fuerza (daño físico)
    Defense = 5,        -- Defensa (reduce daño recibido)
    Intelligence = 8,   -- Inteligencia (daño mágico)
    Speed = 12,         -- Velocidad de movimiento
    Luck = 5,           -- Suerte (críticos, drops)
    Points = 0          -- Puntos de habilidad disponibles
}

-- Tabla para almacenar stats de cada jugador
local playerStats = {}

-- Función para inicializar stats de un jugador
function PlayerStats.InitializePlayer(player)
    local stats = {}
    
    -- Copiar stats por defecto
    for stat, value in pairs(DEFAULT_STATS) do
        stats[stat] = value
    end
    
    -- Guardar stats del jugador
    playerStats[player.UserId] = stats
    
    print("Stats inicializados para " .. player.Name)
end

-- Función para obtener stats de un jugador
function PlayerStats.GetStats(player)
    return playerStats[player.UserId]
end

-- Función para actualizar un stat específico
function PlayerStats.UpdateStat(player, statName, newValue)
    if playerStats[player.UserId] and playerStats[player.UserId][statName] then
        playerStats[player.UserId][statName] = newValue
        return true
    end
    return false
end

-- Función para agregar experiencia
function PlayerStats.AddExperience(player, amount)
    local stats = playerStats[player.UserId]
    if not stats then return false end
    
    stats.Experience = stats.Experience + amount
    
    -- Verificar si subió de nivel
    while stats.Experience >= stats.ExperienceToNext do
        PlayerStats.LevelUp(player)
    end
    
    return true
end

-- Función para subir de nivel
function PlayerStats.LevelUp(player)
    local stats = playerStats[player.UserId]
    if not stats then return false end
    
    stats.Level = stats.Level + 1
    stats.Experience = stats.Experience - stats.ExperienceToNext
    stats.ExperienceToNext = math.floor(stats.ExperienceToNext * 1.2) -- Incremento exponencial
    
    -- Aumentar stats al subir de nivel
    stats.MaxHealth = stats.MaxHealth + 10
    stats.Health = stats.MaxHealth -- Curar completamente al subir nivel
    stats.MaxMana = stats.MaxMana + 5
    stats.Mana = stats.MaxMana
    stats.Points = stats.Points + 2 -- Puntos de habilidad
    
    -- Mostrar notificación de nivel
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = player.Name .. " subió al nivel " .. stats.Level .. "!";
        Color = Color3.fromRGB(255, 215, 0);
        Font = Enum.Font.SourceSansBold;
        FontSize = Enum.FontSize.Size18;
    })
    
    print(player.Name .. " subió al nivel " .. stats.Level)
    return true
end

-- Función para recibir daño
function PlayerStats.TakeDamage(player, damage)
    local stats = playerStats[player.UserId]
    if not stats then return false end
    
    -- Calcular daño reducido por defensa
    local actualDamage = math.max(1, damage - stats.Defense)
    stats.Health = math.max(0, stats.Health - actualDamage)
    
    PlayerStats.UpdateStat(player, "Health", stats.Health)
    
    -- Verificar si el jugador murió
    if stats.Health <= 0 then
        PlayerStats.PlayerDeath(player)
    end
    
    return actualDamage
end

-- Función para curar
function PlayerStats.Heal(player, amount)
    local stats = playerStats[player.UserId]
    if not stats then return false end
    
    stats.Health = math.min(stats.MaxHealth, stats.Health + amount)
    PlayerStats.UpdateStat(player, "Health", stats.Health)
    
    return true
end

-- Función para usar mana
function PlayerStats.UseMana(player, amount)
    local stats = playerStats[player.UserId]
    if not stats then return false end
    
    if stats.Mana >= amount then
        stats.Mana = stats.Mana - amount
        PlayerStats.UpdateStat(player, "Mana", stats.Mana)
        return true
    end
    
    return false
end

-- Función para restaurar mana
function PlayerStats.RestoreMana(player, amount)
    local stats = playerStats[player.UserId]
    if not stats then return false end
    
    stats.Mana = math.min(stats.MaxMana, stats.Mana + amount)
    PlayerStats.UpdateStat(player, "Mana", stats.Mana)
    
    return true
end

-- Función para muerte del jugador
function PlayerStats.PlayerDeath(player)
    local stats = playerStats[player.UserId]
    if not stats then return false end
    
    -- Penalización por muerte (pérdida de experiencia)
    local expLoss = math.floor(stats.Experience * 0.1)
    stats.Experience = math.max(0, stats.Experience - expLoss)
    
    -- Respawn después de 5 segundos
    wait(5)
    player:LoadCharacter()
    
    -- Reinicializar stats después del respawn
    wait(2)
    PlayerStats.InitializePlayer(player)
    
    print(player.Name .. " murió y perdió " .. expLoss .. " experiencia")
end

-- Función para gastar puntos de habilidad
function PlayerStats.SpendPoints(player, statName, amount)
    local stats = playerStats[player.UserId]
    if not stats then return false end
    
    if stats.Points >= amount and stats[statName] then
        stats.Points = stats.Points - amount
        stats[statName] = stats[statName] + amount
        
        -- Actualizar stats derivados
        if statName == "Strength" then
            -- La fuerza puede afectar el daño físico
        elseif statName == "Defense" then
            -- La defensa reduce el daño recibido
        elseif statName == "Intelligence" then
            -- La inteligencia afecta el daño mágico
        elseif statName == "Speed" then
            -- La velocidad afecta la velocidad de movimiento
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = 16 + stats.Speed
            end
        end
        
        return true
    end
    
    return false
end

-- Limpiar stats cuando un jugador se va
Players.PlayerRemoving:Connect(function(player)
    playerStats[player.UserId] = nil
end)

-- Exportar el módulo
return PlayerStats
