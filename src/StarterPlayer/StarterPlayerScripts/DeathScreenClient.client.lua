-- Pantalla de Muerte con Botón de Respawn
-- Muestra una pantalla elegante cuando el jugador muere

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Esperar a que los RemoteEvents estén disponibles
local remoteEventsFolder = ReplicatedStorage:WaitForChild("RemoteEvents")
local requestRespawnEvent = remoteEventsFolder:WaitForChild("RequestRespawn")
local playerDiedEvent = remoteEventsFolder:WaitForChild("PlayerDied")
local playerRespawnedEvent = remoteEventsFolder:WaitForChild("PlayerRespawned")

-- Variables de la pantalla de muerte
local deathScreenGui = nil
local isDead = false

-- Función para crear la GUI de la pantalla de muerte
local function createDeathScreenGUI()
    -- Crear ScreenGui principal
    deathScreenGui = Instance.new("ScreenGui")
    deathScreenGui.Name = "DeathScreenGUI"
    deathScreenGui.ResetOnSpawn = false
    deathScreenGui.Parent = playerGui
    
    -- Frame principal (pantalla completa)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.Position = UDim2.new(0, 0, 0, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BackgroundTransparency = 1 -- Inicialmente invisible
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = deathScreenGui
    
    -- Asegurar que esté completamente oculto al inicio
    mainFrame.Visible = false
    
    -- Frame de fondo con gradiente
    local backgroundFrame = Instance.new("Frame")
    backgroundFrame.Name = "BackgroundFrame"
    backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
    backgroundFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    backgroundFrame.BackgroundTransparency = 0.3
    backgroundFrame.BorderSizePixel = 0
    backgroundFrame.Parent = mainFrame
    
    -- Frame central para el contenido
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(0, 400, 0, 300)
    contentFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame
    
    -- Esquinas redondeadas para el frame central
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = contentFrame
    
    -- Sombra del frame central
    local shadowFrame = Instance.new("Frame")
    shadowFrame.Name = "ShadowFrame"
    shadowFrame.Size = UDim2.new(1, 6, 1, 6)
    shadowFrame.Position = UDim2.new(0, -3, 0, -3)
    shadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadowFrame.BackgroundTransparency = 0.7
    shadowFrame.BorderSizePixel = 0
    shadowFrame.ZIndex = contentFrame.ZIndex - 1
    shadowFrame.Parent = mainFrame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 15)
    shadowCorner.Parent = shadowFrame
    
    -- Título "Has Muerto"
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 80)
    titleLabel.Position = UDim2.new(0, 0, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "💀 HAS MUERTO 💀"
    titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = contentFrame
    
    -- Mensaje de información
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Name = "InfoLabel"
    infoLabel.Size = UDim2.new(1, -40, 0, 60)
    infoLabel.Position = UDim2.new(0, 20, 0, 100)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "Tu vida ha llegado a cero.\nPresiona el botón para respawnear."
    infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    infoLabel.TextScaled = true
    infoLabel.Font = Enum.Font.SourceSans
    infoLabel.TextWrapped = true
    infoLabel.Parent = contentFrame
    
    -- Botón de respawn
    local respawnButton = Instance.new("TextButton")
    respawnButton.Name = "RespawnButton"
    respawnButton.Size = UDim2.new(0, 200, 0, 50)
    respawnButton.Position = UDim2.new(0.5, -100, 0, 180)
    respawnButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    respawnButton.BorderSizePixel = 0
    respawnButton.Text = "🔄 RESPAWNEAR"
    respawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    respawnButton.TextScaled = true
    respawnButton.Font = Enum.Font.SourceSansBold
    respawnButton.Parent = contentFrame
    
    -- Esquinas redondeadas para el botón
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = respawnButton
    
    -- Efecto hover del botón
    respawnButton.MouseEnter:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {BackgroundColor3 = Color3.fromRGB(120, 220, 120)}
        local tween = TweenService:Create(respawnButton, tweenInfo, goal)
        tween:Play()
    end)
    
    respawnButton.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {BackgroundColor3 = Color3.fromRGB(100, 200, 100)}
        local tween = TweenService:Create(respawnButton, tweenInfo, goal)
        tween:Play()
    end)
    
    -- Evento del botón de respawn
    respawnButton.MouseButton1Click:Connect(function()
        requestRespawn()
    end)
    
    -- Contador de tiempo (opcional)
    local timerLabel = Instance.new("TextLabel")
    timerLabel.Name = "TimerLabel"
    timerLabel.Size = UDim2.new(1, 0, 0, 30)
    timerLabel.Position = UDim2.new(0, 0, 0, 240)
    timerLabel.BackgroundTransparency = 1
    timerLabel.Text = ""
    timerLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    timerLabel.TextScaled = true
    timerLabel.Font = Enum.Font.SourceSans
    timerLabel.Parent = contentFrame
    
    print("GUI de pantalla de muerte creada")
end

-- Función para mostrar la pantalla de muerte
local function showDeathScreen()
    if not deathScreenGui or isDead then return end
    
    isDead = true
    local mainFrame = deathScreenGui:FindFirstChild("MainFrame")
    if not mainFrame then return end
    
    -- Hacer visible y fade in
    mainFrame.Visible = true
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {BackgroundTransparency = 0}
    local tween = TweenService:Create(mainFrame, tweenInfo, goal)
    tween:Play()
    
    print("Pantalla de muerte mostrada")
end

-- Función para ocultar la pantalla de muerte
local function hideDeathScreen()
    if not deathScreenGui or not isDead then return end
    
    local mainFrame = deathScreenGui:FindFirstChild("MainFrame")
    if not mainFrame then return end
    
    -- Fade out
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {BackgroundTransparency = 1}
    local tween = TweenService:Create(mainFrame, tweenInfo, goal)
    tween:Play()
    
    -- Esperar a que termine la animación y ocultar completamente
    tween.Completed:Connect(function()
        isDead = false
        mainFrame.Visible = false
    end)
    
    print("Pantalla de muerte ocultada")
end

-- Función para solicitar respawn
local function requestRespawn()
    print("Solicitando respawn...")
    requestRespawnEvent:FireServer()
end

-- Función para configurar eventos del personaje
local function setupCharacterEvents(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Evento cuando el jugador muere
    humanoid.Died:Connect(function()
        showDeathScreen()
    end)
    
    -- Evento cuando cambia la vida
    humanoid.HealthChanged:Connect(function(health)
        if health <= 0 and not isDead then
            -- Solo mostrar pantalla de muerte si la vida llega a 0
            showDeathScreen()
        elseif health > 0 and isDead then
            -- Ocultar pantalla de muerte si la vida se recupera
            hideDeathScreen()
        end
    end)
end

-- Escuchar eventos del servidor
playerDiedEvent.OnClientEvent:Connect(function()
    showDeathScreen()
end)

playerRespawnedEvent.OnClientEvent:Connect(function()
    hideDeathScreen()
end)

-- Función para configurar eventos del jugador
local function setupPlayerEvents()
    -- Crear GUI inicial
    createDeathScreenGUI()
    
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

-- Inicializar sistema
setupPlayerEvents()

print("DeathScreenClient: Sistema de pantalla de muerte iniciado")
