-- Sistema de Regeneración Automática de Vida
-- Regenera vida cuando el jugador no recibe daño por un tiempo

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Esperar a que los RemoteEvents estén disponibles
local remoteEventsFolder = ReplicatedStorage:WaitForChild("RemoteEvents")
local damagePlayerEvent = remoteEventsFolder:WaitForChild("DamagePlayer")

-- Configuración de regeneración
local REGEN_CONFIG = {
    RegenAmount = 5,        -- HP regenerados por segundo
    RegenDelay = 3,         -- Segundos después del último daño para empezar a regenerar
    RegenInterval = 1,      -- Intervalo entre regeneraciones (segundos)
    MaxRegenRate = 20       -- Máximo HP por segundo (límite de seguridad)
}

-- Variables del sistema
local lastDamageTime = 0
local isRegenerating = false
local regenConnection = nil
local character = nil
local humanoid = nil

-- Función para iniciar la regeneración
local function startRegeneration()
    if isRegenerating then return end
    
    isRegenerating = true
    print("Regeneración de vida iniciada")
    
    regenConnection = RunService.Heartbeat:Connect(function()
        if not character or not humanoid then
            stopRegeneration()
            return
        end
        
        -- Verificar si el jugador está muerto
        if humanoid.Health <= 0 then
            stopRegeneration()
            return
        end
        
        -- Verificar si ya tiene vida máxima
        if humanoid.Health >= humanoid.MaxHealth then
            stopRegeneration()
            return
        end
        
        -- Calcular tiempo desde último daño
        local timeSinceDamage = tick() - lastDamageTime
        
        -- Si ha pasado suficiente tiempo, regenerar
        if timeSinceDamage >= REGEN_CONFIG.RegenDelay then
            local newHealth = math.min(
                humanoid.MaxHealth,
                humanoid.Health + REGEN_CONFIG.RegenAmount
            )
            
            humanoid.Health = newHealth
            
            -- Mostrar efecto visual de regeneración
            showRegenEffect()
        end
    end)
end

-- Función para detener la regeneración
local function stopRegeneration()
    if not isRegenerating then return end
    
    isRegenerating = false
    if regenConnection then
        regenConnection:Disconnect()
        regenConnection = nil
    end
    print("Regeneración de vida detenida")
end

-- Función para mostrar efecto visual de regeneración
local function showRegenEffect()
    -- Crear efecto de partículas verdes en el personaje
    if character and character:FindFirstChild("HumanoidRootPart") then
        local rootPart = character.HumanoidRootPart
        
        -- Crear attachment para partículas
        local attachment = Instance.new("Attachment")
        attachment.Parent = rootPart
        
        -- Crear partículas de regeneración
        local particles = Instance.new("ParticleEmitter")
        particles.Parent = attachment
        particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        particles.Lifetime = NumberRange.new(0.5, 1.0)
        particles.Rate = 20
        particles.SpreadAngle = Vector2.new(45, 45)
        particles.Speed = NumberRange.new(2, 5)
        particles.Color = ColorSequence.new(Color3.fromRGB(0, 255, 0))
        particles.Size = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 0.1)
        }
        
        -- Detener partículas después de un tiempo
        spawn(function()
            wait(0.3)
            particles.Enabled = false
            wait(1)
            attachment:Destroy()
        end)
    end
end

-- Función para registrar daño recibido
local function registerDamage(damageAmount)
    lastDamageTime = tick()
    stopRegeneration()
    print("Daño registrado: " .. damageAmount .. " HP - Regeneración detenida")
end

-- Función para configurar eventos del personaje
local function setupCharacterEvents(newCharacter)
    character = newCharacter
    humanoid = character:FindFirstChild("Humanoid")
    
    if not humanoid then return end
    
    -- Evento cuando el jugador recibe daño
    humanoid.HealthChanged:Connect(function(health)
        if health < humanoid.MaxHealth and health > 0 then
            -- Si la vida disminuyó, registrar daño
            local previousHealth = humanoid.MaxHealth -- Asumir vida máxima como referencia
            if health < previousHealth then
                local damageAmount = previousHealth - health
                registerDamage(damageAmount)
            end
        end
    end)
    
    -- Evento cuando el jugador muere
    humanoid.Died:Connect(function()
        stopRegeneration()
        lastDamageTime = 0
        print("Jugador murió - Regeneración detenida")
    end)
    
    -- Evento cuando el jugador respawnea
    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if humanoid.Health >= humanoid.MaxHealth and humanoid.Health > 0 then
            -- El jugador respawneó o se curó completamente
            lastDamageTime = 0
            print("Jugador respawneó/curado - Regeneración disponible")
        end
    end)
end

-- Escuchar eventos de daño desde el servidor
damagePlayerEvent.OnClientEvent:Connect(function(damageAmount)
    registerDamage(damageAmount)
end)

-- Función para configurar eventos del jugador
local function setupPlayerEvents()
    -- Configurar para el personaje actual
    if player.Character then
        setupCharacterEvents(player.Character)
    end
    
    -- Configurar para nuevos personajes
    player.CharacterAdded:Connect(function(newCharacter)
        wait(1) -- Esperar a que el personaje se cargue completamente
        setupCharacterEvents(newCharacter)
    end)
end

-- Función para iniciar el sistema de regeneración
local function startRegenSystem()
    spawn(function()
        while true do
            wait(REGEN_CONFIG.RegenInterval)
            
            if character and humanoid and humanoid.Health > 0 and humanoid.Health < humanoid.MaxHealth then
                local timeSinceDamage = tick() - lastDamageTime
                
                if timeSinceDamage >= REGEN_CONFIG.RegenDelay and not isRegenerating then
                    startRegeneration()
                end
            end
        end
    end)
end

-- Inicializar sistema
setupPlayerEvents()
startRegenSystem()

print("HealthRegenClient: Sistema de regeneración iniciado")
print("- Regeneración: " .. REGEN_CONFIG.RegenAmount .. " HP cada " .. REGEN_CONFIG.RegenInterval .. " segundo")
print("- Delay después de daño: " .. REGEN_CONFIG.RegenDelay .. " segundos")
