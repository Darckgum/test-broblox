-- Barra de Vida en GUI de Pantalla
-- Muestra la vida del jugador en la esquina superior izquierda

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Esperar a que los RemoteEvents estén disponibles
local remoteEventsFolder = ReplicatedStorage:WaitForChild("RemoteEvents")
local updateMaxHealthEvent = remoteEventsFolder:WaitForChild("UpdateMaxHealth")

-- Variables para la barra de vida
local healthBarGui = nil
local healthFrame = nil
local healthText = nil
local maxHealth = 100
local currentHealth = 100

-- Función para crear la GUI de la barra de vida
local function createHealthBarGUI()
    -- Crear ScreenGui principal
    healthBarGui = Instance.new("ScreenGui")
    healthBarGui.Name = "HealthBarGUI"
    healthBarGui.ResetOnSpawn = false
    healthBarGui.Parent = playerGui
    
    -- Frame contenedor principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 60)
    mainFrame.Position = UDim2.new(0, 20, 0, 20) -- Esquina superior izquierda
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = healthBarGui
    
    -- Agregar esquinas redondeadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Sombra del frame
    local shadowFrame = Instance.new("Frame")
    shadowFrame.Name = "ShadowFrame"
    shadowFrame.Size = UDim2.new(1, 4, 1, 4)
    shadowFrame.Position = UDim2.new(0, -2, 0, -2)
    shadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadowFrame.BackgroundTransparency = 0.5
    shadowFrame.BorderSizePixel = 0
    shadowFrame.ZIndex = mainFrame.ZIndex - 1
    shadowFrame.Parent = healthBarGui
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 8)
    shadowCorner.Parent = shadowFrame
    
    -- Frame de fondo de la barra
    local backgroundFrame = Instance.new("Frame")
    backgroundFrame.Name = "BackgroundFrame"
    backgroundFrame.Size = UDim2.new(1, -20, 0.6, 0)
    backgroundFrame.Position = UDim2.new(0, 10, 0.2, 0)
    backgroundFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    backgroundFrame.BorderSizePixel = 0
    backgroundFrame.Parent = mainFrame
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 4)
    bgCorner.Parent = backgroundFrame
    
    -- Frame de la barra de vida
    healthFrame = Instance.new("Frame")
    healthFrame.Name = "HealthFrame"
    healthFrame.Size = UDim2.new(1, 0, 1, 0) -- Inicialmente llena
    healthFrame.Position = UDim2.new(0, 0, 0, 0)
    healthFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Verde inicial
    healthFrame.BorderSizePixel = 0
    healthFrame.Parent = backgroundFrame
    
    local healthCorner = Instance.new("UICorner")
    healthCorner.CornerRadius = UDim.new(0, 4)
    healthCorner.Parent = healthFrame
    
    -- Texto de la vida
    healthText = Instance.new("TextLabel")
    healthText.Name = "HealthText"
    healthText.Size = UDim2.new(1, 0, 1, 0)
    healthText.Position = UDim2.new(0, 0, 0, 0)
    healthText.BackgroundTransparency = 1
    healthText.Text = "HP: 100/100"
    healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthText.TextScaled = true
    healthText.Font = Enum.Font.SourceSansBold
    healthText.Parent = mainFrame
    
    -- Efecto de brillo
    local glowFrame = Instance.new("Frame")
    glowFrame.Name = "GlowFrame"
    glowFrame.Size = UDim2.new(1, 0, 1, 0)
    glowFrame.Position = UDim2.new(0, 0, 0, 0)
    glowFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glowFrame.BackgroundTransparency = 0.8
    glowFrame.BorderSizePixel = 0
    glowFrame.Parent = healthFrame
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 4)
    glowCorner.Parent = glowFrame
    
    print("GUI de barra de vida creada")
end

-- Función para actualizar la barra de vida
local function updateHealthBar(currentHP, maxHP)
    if not healthFrame or not healthText then return end
    
    currentHealth = currentHP
    maxHealth = maxHP
    
    local healthPercentage = currentHP / maxHP
    
    -- Calcular color basado en porcentaje
    local healthColor
    if healthPercentage > 0.6 then
        -- Verde a amarillo
        local factor = (healthPercentage - 0.6) / 0.4
        healthColor = Color3.fromRGB(
            255 * (1 - factor),
            255,
            0
        )
    elseif healthPercentage > 0.3 then
        -- Amarillo a naranja
        local factor = (healthPercentage - 0.3) / 0.3
        healthColor = Color3.fromRGB(
            255,
            255 * (1 - factor * 0.5),
            0
        )
    else
        -- Naranja a rojo
        local factor = healthPercentage / 0.3
        healthColor = Color3.fromRGB(
            255,
            128 * factor,
            0
        )
    end
    
    -- Animar el cambio de tamaño
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
    local goal = {Size = UDim2.new(healthPercentage, 0, 1, 0)}
    local tween = TweenService:Create(healthFrame, tweenInfo, goal)
    tween:Play()
    
    -- Cambiar color
    healthFrame.BackgroundColor3 = healthColor
    
    -- Actualizar texto
    healthText.Text = "HP: " .. math.floor(currentHP) .. "/" .. math.floor(maxHP)
end

-- Función para configurar eventos del Humanoid
local function setupHumanoidEvents(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Actualizar barra cuando cambia la vida
    humanoid.HealthChanged:Connect(function(health)
        updateHealthBar(health, humanoid.MaxHealth)
    end)
    
    -- Actualizar vida máxima cuando cambia
    humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
        updateHealthBar(humanoid.Health, humanoid.MaxHealth)
    end)
    
    -- Actualizar al inicio
    updateHealthBar(humanoid.Health, humanoid.MaxHealth)
end

-- Escuchar cambios en la vida máxima desde el servidor
updateMaxHealthEvent.OnClientEvent:Connect(function(newMaxHealth)
    maxHealth = newMaxHealth
    if healthText then
        healthText.Text = "HP: " .. math.floor(currentHealth) .. "/" .. math.floor(maxHealth)
    end
end)

-- Configurar eventos del jugador
local function setupPlayerEvents()
    -- Crear GUI inicial
    createHealthBarGUI()
    
    -- Configurar para el personaje actual
    if player.Character then
        setupHumanoidEvents(player.Character)
    end
    
    -- Configurar para nuevos personajes
    player.CharacterAdded:Connect(function(character)
        wait(1) -- Esperar a que el personaje se cargue completamente
        setupHumanoidEvents(character)
    end)
end

-- Inicializar
setupPlayerEvents()

print("HealthBarClient: Sistema de barra de vida iniciado")