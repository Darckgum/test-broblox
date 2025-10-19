-- Barra de Vida Mejorada - Esquina Izquierda
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables para la barra de vida
local healthBarGui = nil
local healthFrame = nil
local healthText = nil

-- Función para crear la GUI de la barra de vida
local function createHealthBarGUI()
    -- Crear ScreenGui principal
    healthBarGui = Instance.new("ScreenGui")
    healthBarGui.Name = "HealthBarGUI"
    healthBarGui.ResetOnSpawn = false
    healthBarGui.Parent = playerGui
    
    -- Frame contenedor principal (más pequeño)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 200, 0, 40) -- Más pequeño: 200x40
    mainFrame.Position = UDim2.new(0, 15, 0, 15) -- Esquina superior izquierda
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Fondo más oscuro
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = healthBarGui
    
    -- Agregar esquinas redondeadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6) -- Esquinas más redondeadas
    corner.Parent = mainFrame
    
    -- Sombra del frame
    local shadowFrame = Instance.new("Frame")
    shadowFrame.Name = "ShadowFrame"
    shadowFrame.Size = UDim2.new(1, 3, 1, 3)
    shadowFrame.Position = UDim2.new(0, -1.5, 0, -1.5)
    shadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadowFrame.BackgroundTransparency = 0.6
    shadowFrame.BorderSizePixel = 0
    shadowFrame.ZIndex = mainFrame.ZIndex - 1
    shadowFrame.Parent = healthBarGui
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 6)
    shadowCorner.Parent = shadowFrame
    
    -- Frame de fondo de la barra
    local backgroundFrame = Instance.new("Frame")
    backgroundFrame.Name = "BackgroundFrame"
    backgroundFrame.Size = UDim2.new(1, -16, 0.5, 0) -- Más delgada
    backgroundFrame.Position = UDim2.new(0, 8, 0.25, 0)
    backgroundFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Fondo más claro
    backgroundFrame.BorderSizePixel = 0
    backgroundFrame.Parent = mainFrame
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 3)
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
    healthCorner.CornerRadius = UDim.new(0, 3)
    healthCorner.Parent = healthFrame
    
    -- Efecto de brillo en la barra
    local glowFrame = Instance.new("Frame")
    glowFrame.Name = "GlowFrame"
    glowFrame.Size = UDim2.new(1, 0, 0.3, 0)
    glowFrame.Position = UDim2.new(0, 0, 0, 0)
    glowFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glowFrame.BackgroundTransparency = 0.7
    glowFrame.BorderSizePixel = 0
    glowFrame.Parent = healthFrame
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 3)
    glowCorner.Parent = glowFrame
    
    -- Texto de la vida (más pequeño)
    healthText = Instance.new("TextLabel")
    healthText.Name = "HealthText"
    healthText.Size = UDim2.new(1, 0, 1, 0)
    healthText.Position = UDim2.new(0, 0, 0, 0)
    healthText.BackgroundTransparency = 1
    healthText.Text = "100/100"
    healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthText.TextScaled = true
    healthText.Font = Enum.Font.SourceSansBold
    healthText.TextStrokeTransparency = 0.5 -- Contorno del texto
    healthText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    healthText.Parent = mainFrame
    
    -- Icono de corazón
    local heartIcon = Instance.new("TextLabel")
    heartIcon.Name = "HeartIcon"
    heartIcon.Size = UDim2.new(0, 20, 0, 20)
    heartIcon.Position = UDim2.new(0, -25, 0.5, -10)
    heartIcon.BackgroundTransparency = 1
    heartIcon.Text = "❤️"
    heartIcon.TextColor3 = Color3.fromRGB(255, 100, 100)
    heartIcon.TextScaled = true
    heartIcon.Font = Enum.Font.SourceSansBold
    heartIcon.Parent = mainFrame
    
    print("GUI de barra de vida mejorada creada")
end

-- Función para actualizar la barra de vida
local function updateHealthBar(currentHP, maxHP)
    if not healthFrame or not healthText then return end
    
    local healthPercentage = currentHP / maxHP
    
    -- Calcular color basado en porcentaje con mejor gradiente
    local healthColor
    if healthPercentage > 0.7 then
        -- Verde brillante
        healthColor = Color3.fromRGB(0, 255, 0)
    elseif healthPercentage > 0.4 then
        -- Verde a amarillo
        local factor = (healthPercentage - 0.4) / 0.3
        healthColor = Color3.fromRGB(
            255 * (1 - factor),
            255,
            0
        )
    elseif healthPercentage > 0.2 then
        -- Amarillo a naranja
        local factor = (healthPercentage - 0.2) / 0.2
        healthColor = Color3.fromRGB(
            255,
            255 * (1 - factor * 0.3),
            0
        )
    else
        -- Naranja a rojo
        local factor = healthPercentage / 0.2
        healthColor = Color3.fromRGB(
            255,
            100 * factor,
            0
        )
    end
    
    -- Animar el cambio de tamaño con mejor easing
    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0)
    local goal = {Size = UDim2.new(healthPercentage, 0, 1, 0)}
    local tween = TweenService:Create(healthFrame, tweenInfo, goal)
    tween:Play()
    
    -- Cambiar color con animación
    local colorTween = TweenService:Create(healthFrame, TweenInfo.new(0.3), {BackgroundColor3 = healthColor})
    colorTween:Play()
    
    -- Actualizar texto
    healthText.Text = math.floor(currentHP) .. "/" .. math.floor(maxHP)
    
    -- Cambiar color del texto según la vida
    if healthPercentage < 0.3 then
        healthText.TextColor3 = Color3.fromRGB(255, 150, 150) -- Rojo claro
    elseif healthPercentage < 0.6 then
        healthText.TextColor3 = Color3.fromRGB(255, 255, 150) -- Amarillo claro
    else
        healthText.TextColor3 = Color3.fromRGB(255, 255, 255) -- Blanco
    end
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

-- Función para configurar eventos del jugador
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

print("HealthBarClient: Barra de vida mejorada iniciada")