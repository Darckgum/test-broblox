-- Script Principal del Servidor - Sistema de Vida Avanzado
-- Maneja objetos de daño, respawn y comunicación con el cliente

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- Esperar a que los módulos se carguen
local Modules = ServerStorage:WaitForChild("Modules")
local HealthSystem = require(Modules:WaitForChild("HealthSystem"))

-- Esperar a que los RemoteEvents se carguen
local remoteEventsFolder = ReplicatedStorage:WaitForChild("RemoteEvents")
local DamagePlayerEvent = remoteEventsFolder:WaitForChild("DamagePlayer")
local RequestRespawnEvent = remoteEventsFolder:WaitForChild("RequestRespawn")
local PlayerDiedEvent = remoteEventsFolder:WaitForChild("PlayerDied")
local PlayerRespawnedEvent = remoteEventsFolder:WaitForChild("PlayerRespawned")
local UpdateMaxHealthEvent = remoteEventsFolder:WaitForChild("UpdateMaxHealth")

-- Configuración de objetos de daño
local DAMAGE_OBJECTS = {
    {
        Name = "Daño Ligero",
        Position = Vector3.new(0, 10, 10),
        Damage = 5,
        Cooldown = 2,
        Color = BrickColor.new("Bright green"),
        Size = Vector3.new(6, 6, 6)
    },
    {
        Name = "Daño Medio",
        Position = Vector3.new(20, 10, 10),
        Damage = 10,
        Cooldown = 2,
        Color = BrickColor.new("Bright yellow"),
        Size = Vector3.new(8, 8, 8)
    },
    {
        Name = "Daño Fuerte",
        Position = Vector3.new(-20, 10, 10),
        Damage = 20,
        Cooldown = 2,
        Color = BrickColor.new("Bright orange"),
        Size = Vector3.new(10, 10, 10)
    },
    {
        Name = "Daño Extremo",
        Position = Vector3.new(0, 10, -20),
        Damage = 35,
        Cooldown = 2,
        Color = BrickColor.new("Really red"),
        Size = Vector3.new(12, 12, 12)
    }
}

-- Función para crear un objeto que hace daño
local function createDamageObject(config)
    -- Crear la parte que hace daño
    local damagePart = Instance.new("Part")
    damagePart.Name = config.Name
    damagePart.Size = config.Size
    damagePart.Position = config.Position
    damagePart.BrickColor = config.Color
    damagePart.Material = Enum.Material.Neon
    damagePart.Anchored = true
    damagePart.CanCollide = false
    damagePart.Shape = Enum.PartType.Ball
    damagePart.Parent = workspace
    
    -- Tabla para almacenar cooldowns de jugadores
    local playerCooldowns = {}
    
    -- Función para aplicar daño a un jugador
    local function damagePlayer(player)
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        -- Registrar daño en el sistema de vida
        HealthSystem.RegisterDamage(player, config.Damage)
        
        -- Aplicar daño al Humanoid
        local newHealth = math.max(0, humanoid.Health - config.Damage)
        humanoid.Health = newHealth
        
        -- Calcular porcentaje de vida para efectos
        local healthPercentage = newHealth / humanoid.MaxHealth
        
        -- Notificar al cliente sobre el daño recibido
        DamagePlayerEvent:FireClient(player, config.Damage, healthPercentage)
        
        -- Verificar si el jugador murió
        if newHealth <= 0 then
            HealthSystem.HandleDeath(player)
            PlayerDiedEvent:FireClient(player)
        end
        
        print(player.Name .. " recibió " .. config.Damage .. " de daño de " .. config.Name)
    end
    
    -- Evento cuando algo toca el objeto
    damagePart.Touched:Connect(function(hit)
        local character = hit.Parent
        local humanoid = character:FindFirstChild("Humanoid")
        
        if humanoid then
            local player = Players:GetPlayerFromCharacter(character)
            if player then
                local currentTime = tick()
                
                -- Verificar cooldown
                if not playerCooldowns[player.UserId] or 
                   (currentTime - playerCooldowns[player.UserId]) >= config.Cooldown then
                    
                    -- Registrar cooldown
                    playerCooldowns[player.UserId] = currentTime
                    
                    -- Aplicar daño
                    damagePlayer(player)
                end
            end
        end
    end)
    
    print("Objeto de daño creado: " .. config.Name .. " en posición: " .. tostring(config.Position))
    return damagePart
end

-- Función para manejar respawn de jugador
local function handleRespawn(player)
    print("Procesando respawn para " .. player.Name)
    
    -- Respawnear usando el sistema de vida
    local success = HealthSystem.RespawnPlayer(player)
    
    if success then
        -- Notificar al cliente que respawneó
        PlayerRespawnedEvent:FireClient(player)
        
        -- Actualizar vida máxima en el cliente
        local maxHealth = HealthSystem.GetMaxHealth(player)
        UpdateMaxHealthEvent:FireClient(player, maxHealth)
        
        print(player.Name .. " respawneó exitosamente")
    else
        print("Error al respawnear " .. player.Name)
    end
end

-- Función para inicializar un jugador
local function initializePlayer(player)
    print("Inicializando sistema de vida para " .. player.Name)
    
    -- Inicializar sistema de vida
    HealthSystem.InitializePlayer(player)
    
    -- Notificar vida máxima inicial al cliente
    local maxHealth = HealthSystem.GetMaxHealth(player)
    UpdateMaxHealthEvent:FireClient(player, maxHealth)
    
    print("Sistema de vida inicializado para " .. player.Name)
end

-- Función para crear suelo plano
local function createFloor()
    local floor = Instance.new("Part")
    floor.Name = "Floor"
    floor.Size = Vector3.new(100, 1, 100)
    floor.Position = Vector3.new(0, 0, 0)
    floor.Anchored = true
    floor.BrickColor = BrickColor.new("Medium stone grey")
    floor.Material = Enum.Material.Concrete
    floor.Parent = workspace
    
    print("Suelo plano creado")
    return floor
end

-- Eventos principales
Players.PlayerAdded:Connect(function(player)
    print("Jugador " .. player.Name .. " se unió al juego")
    
    player.CharacterAdded:Connect(function(character)
        wait(2) -- Esperar a que el personaje se cargue completamente
        initializePlayer(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    print("Jugador " .. player.Name .. " salió del juego")
    HealthSystem.CleanupPlayer(player)
end)

-- Evento para manejar solicitudes de respawn
RequestRespawnEvent.OnServerEvent:Connect(function(player)
    handleRespawn(player)
end)

-- Crear contenido inicial del mundo
spawn(function()
    wait(5) -- Esperar a que el servidor se inicialice
    
    -- Crear suelo plano
    createFloor()
    
    -- Crear objetos de daño
    for _, config in ipairs(DAMAGE_OBJECTS) do
        createDamageObject(config)
    end
    
    print("Contenido inicial del mundo creado:")
    print("- Suelo plano")
    print("- " .. #DAMAGE_OBJECTS .. " objetos de daño")
end)

print("Sistema de vida avanzado del servidor iniciado correctamente")