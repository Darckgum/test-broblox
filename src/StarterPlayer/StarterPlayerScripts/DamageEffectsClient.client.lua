-- Efectos Visuales de Daño
-- Flash rojo, vignette y sacudida de cámara cuando el jugador recibe daño

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Esperar a que los RemoteEvents estén disponibles
local remoteEventsFolder = ReplicatedStorage:WaitForChild("RemoteEvents")
local damagePlayerEvent = remoteEventsFolder:WaitForChild("DamagePlayer")

-- Variables de efectos
local damageEffectsGui = nil
local flashFrame = nil
local vignetteFrame = nil
local camera = workspace.CurrentCamera
local originalCFrame = nil

-- Configuración de efectos
local EFFECTS_CONFIG = {
    FlashDuration = 0.3,        -- Duración del flash rojo
    VignetteThreshold = 30,     -- Porcentaje de vida para mostrar vignette
    CameraShakeIntensity = 0.5, -- Intensidad de la sacudida de cámara
    CameraShakeDuration = 0.2   -- Duración de la sacudida
}

-- Función para crear la GUI de efectos
local function createDamageEffectsGUI()
    -- Crear ScreenGui principal
    damageEffectsGui = Instance.new("ScreenGui")
    damageEffectsGui.Name = "DamageEffectsGUI"
    damageEffectsGui.ResetOnSpawn = false
    damageEffectsGui.Parent = playerGui
    
    -- Frame para el flash rojo
    flashFrame = Instance.new("Frame")
    flashFrame.Name = "FlashFrame"
    flashFrame.Size = UDim2.new(1, 0, 1, 0)
    flashFrame.Position = UDim2.new(0, 0, 0, 0)
    flashFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    flashFrame.BackgroundTransparency = 1 -- Inicialmente invisible
    flashFrame.BorderSizePixel = 0
    flashFrame.Parent = damageEffectsGui
    
    -- Frame para el vignette (oscurecimiento de bordes)
    vignetteFrame = Instance.new("Frame")
    vignetteFrame.Name = "VignetteFrame"
    vignetteFrame.Size = UDim2.new(1, 0, 1, 0)
    vignetteFrame.Position = UDim2.new(0, 0, 0, 0)
    vignetteFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    vignetteFrame.BackgroundTransparency = 1 -- Inicialmente invisible
    vignetteFrame.BorderSizePixel = 0
    vignetteFrame.Parent = damageEffectsGui
    
    -- Crear efecto de vignette usando un Frame con esquinas redondeadas
    local vignetteInner = Instance.new("Frame")
    vignetteInner.Name = "VignetteInner"
    vignetteInner.Size = UDim2.new(0.8, 0, 0.8, 0)
    vignetteInner.Position = UDim2.new(0.1, 0, 0.1, 0)
    vignetteInner.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    vignetteInner.BackgroundTransparency = 1
    vignetteInner.BorderSizePixel = 0
    vignetteInner.Parent = vignetteFrame
    
    -- Usar UICorner para crear el efecto de vignette
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 100)
    corner.Parent = vignetteInner
    
    print("GUI de efectos de daño creada")
end

-- Función para mostrar flash rojo
local function showDamageFlash(damageAmount)
    if not flashFrame then return end
    
    -- Calcular intensidad del flash basada en el daño
    local intensity = math.min(1, damageAmount / 50) -- Máximo flash con 50+ de daño
    local transparency = 1 - (intensity * 0.8) -- Flash más intenso con más daño
    
    -- Flash rápido
    local tweenInfo = TweenInfo.new(EFFECTS_CONFIG.FlashDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    -- Fade in
    local fadeInGoal = {BackgroundTransparency = transparency}
    local fadeInTween = TweenService:Create(flashFrame, tweenInfo, fadeInGoal)
    fadeInTween:Play()
    
    -- Fade out
    fadeInTween.Completed:Connect(function()
        local fadeOutTween = TweenService:Create(flashFrame, tweenInfo, {BackgroundTransparency = 1})
        fadeOutTween:Play()
    end)
    
    print("Flash de daño mostrado - Intensidad: " .. intensity)
end

-- Función para mostrar/ocultar vignette
local function updateVignette(healthPercentage)
    if not vignetteFrame then return end
    
    local shouldShow = healthPercentage <= (EFFECTS_CONFIG.VignetteThreshold / 100)
    local targetTransparency = shouldShow and 0.3 or 1
    
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {BackgroundTransparency = targetTransparency}
    local tween = TweenService:Create(vignetteFrame, tweenInfo, goal)
    tween:Play()
    
    if shouldShow then
        print("Vignette activado - Vida baja: " .. math.floor(healthPercentage * 100) .. "%")
    end
end

-- Función para sacudir la cámara
local function shakeCamera(intensity)
    if not camera then return end
    
    intensity = intensity or EFFECTS_CONFIG.CameraShakeIntensity
    local shakeAmount = intensity * 0.1
    
    -- Guardar posición original si no está guardada
    if not originalCFrame then
        originalCFrame = camera.CFrame
    end
    
    -- Crear sacudida aleatoria
    local shakeConnection
    local shakeTime = 0
    
    shakeConnection = RunService.Heartbeat:Connect(function(deltaTime)
        shakeTime = shakeTime + deltaTime
        
        if shakeTime >= EFFECTS_CONFIG.CameraShakeDuration then
            -- Restaurar posición original
            camera.CFrame = originalCFrame
            shakeConnection:Disconnect()
            return
        end
        
        -- Aplicar sacudida aleatoria
        local randomX = (math.random() - 0.5) * shakeAmount
        local randomY = (math.random() - 0.5) * shakeAmount
        local randomZ = (math.random() - 0.5) * shakeAmount
        
        camera.CFrame = originalCFrame * CFrame.new(randomX, randomY, randomZ)
    end)
    
    print("Sacudida de cámara aplicada - Intensidad: " .. intensity)
end

-- Función para aplicar todos los efectos de daño
local function applyDamageEffects(damageAmount, healthPercentage)
    showDamageFlash(damageAmount)
    updateVignette(healthPercentage)
    shakeCamera(damageAmount / 100) -- Intensidad basada en daño
end

-- Función para configurar eventos del personaje
local function setupCharacterEvents(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Evento cuando cambia la vida
    humanoid.HealthChanged:Connect(function(health)
        local healthPercentage = health / humanoid.MaxHealth
        updateVignette(healthPercentage)
    end)
    
    -- Actualizar vignette al inicio
    updateVignette(humanoid.Health / humanoid.MaxHealth)
end

-- Escuchar eventos de daño desde el servidor
damagePlayerEvent.OnClientEvent:Connect(function(damageAmount, healthPercentage)
    applyDamageEffects(damageAmount, healthPercentage)
end)

-- Función para configurar eventos del jugador
local function setupPlayerEvents()
    -- Crear GUI inicial
    createDamageEffectsGUI()
    
    -- Configurar para el personaje actual
    if player.Character then
        setupCharacterEvents(player.Character)
    end
    
    -- Configurar para nuevos personajes
    player.CharacterAdded:Connect(function(character)
        wait(1) -- Esperar a que el personaje se cargue completamente
        setupCharacterEvents(character)
    end)
end

-- Función para limpiar efectos cuando el jugador respawnea
local function cleanupEffects()
    if vignetteFrame then
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {BackgroundTransparency = 1}
        local tween = TweenService:Create(vignetteFrame, tweenInfo, goal)
        tween:Play()
    end
    
    originalCFrame = nil
    print("Efectos de daño limpiados")
end

-- Escuchar respawn para limpiar efectos
local remoteEventsFolder = ReplicatedStorage:WaitForChild("RemoteEvents")
local playerRespawnedEvent = remoteEventsFolder:WaitForChild("PlayerRespawned")
playerRespawnedEvent.OnClientEvent:Connect(function()
    cleanupEffects()
end)

-- Inicializar sistema
setupPlayerEvents()

print("DamageEffectsClient: Sistema de efectos visuales iniciado")
print("- Flash rojo al recibir daño")
print("- Vignette cuando vida < " .. EFFECTS_CONFIG.VignetteThreshold .. "%")
print("- Sacudida de cámara proporcional al daño")
