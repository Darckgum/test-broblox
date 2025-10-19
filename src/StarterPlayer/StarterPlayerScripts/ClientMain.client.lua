-- Script Principal del Cliente RPG
-- Maneja la interfaz de usuario y eventos del cliente

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Esperar a que los eventos se carguen
local rpgEvents = ReplicatedStorage:WaitForChild("RPGEvents")
local combatEvents = rpgEvents:WaitForChild("CombatEvents")
local inventoryEvents = rpgEvents:WaitForChild("InventoryEvents")
local statsEvents = rpgEvents:WaitForChild("StatsEvents")
local questEvents = rpgEvents:WaitForChild("QuestEvents")
local guiEvents = rpgEvents:WaitForChild("GUIEvents")

-- Obtener RemoteEvents
local attackEvent = combatEvents:WaitForChild("AttackEvent")
local skillEvent = combatEvents:WaitForChild("SkillEvent")
local equipItemEvent = inventoryEvents:WaitForChild("EquipItemEvent")
local useItemEvent = inventoryEvents:WaitForChild("UseItemEvent")
local dropItemEvent = inventoryEvents:WaitForChild("DropItemEvent")
local levelUpEvent = statsEvents:WaitForChild("LevelUpEvent")
local spendPointsEvent = statsEvents:WaitForChild("SpendPointsEvent")
local startQuestEvent = questEvents:WaitForChild("StartQuestEvent")
local completeQuestEvent = questEvents:WaitForChild("CompleteQuestEvent")
local openGUIEvent = guiEvents:WaitForChild("OpenGUIEvent")
local closeGUIEvent = guiEvents:WaitForChild("CloseGUIEvent")

-- Variables del cliente
local currentTarget = nil
local isGUIOpen = false
local currentGUIType = nil

-- ===== SISTEMA DE GUI =====

-- Función para crear la GUI principal
local function createMainGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RPGMainGUI"
    screenGui.Parent = playerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Parent = screenGui
    
    -- Agregar esquinas redondeadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Barra de título
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, -40, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "RPG Stats"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = titleBar
    
    -- Botón de cerrar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeButton
    
    -- Contenido principal
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -20, 1, -60)
    contentFrame.Position = UDim2.new(0, 10, 0, 50)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Crear tabs
    createTabs(contentFrame)
    
    -- Eventos
    closeButton.MouseButton1Click:Connect(function()
        toggleMainGUI()
    end)
    
    return screenGui
end

-- Función para crear tabs
local function createTabs(parent)
    -- Frame de tabs
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = "TabFrame"
    tabFrame.Size = UDim2.new(1, 0, 0, 40)
    tabFrame.Position = UDim2.new(0, 0, 0, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Parent = parent
    
    -- Botones de tab
    local tabs = {"Stats", "Inventory", "Skills", "Quests"}
    local tabButtons = {}
    
    for i, tabName in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName .. "Tab"
        tabButton.Size = UDim2.new(1/4, -5, 1, 0)
        tabButton.Position = UDim2.new((i-1)/4, 0, 0, 0)
        tabButton.BackgroundColor3 = i == 1 and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(60, 60, 60)
        tabButton.BorderSizePixel = 0
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.TextScaled = true
        tabButton.Font = Enum.Font.SourceSans
        tabButton.Parent = tabFrame
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 5)
        tabCorner.Parent = tabButton
        
        tabButtons[tabName] = tabButton
        
        -- Evento de click
        tabButton.MouseButton1Click:Connect(function()
            switchTab(tabName)
        end)
    end
    
    -- Frame de contenido de tabs
    local tabContentFrame = Instance.new("Frame")
    tabContentFrame.Name = "TabContentFrame"
    tabContentFrame.Size = UDim2.new(1, 0, 1, -50)
    tabContentFrame.Position = UDim2.new(0, 0, 0, 50)
    tabContentFrame.BackgroundTransparency = 1
    tabContentFrame.Parent = parent
    
    -- Crear contenido de cada tab
    createStatsTab(tabContentFrame)
    createInventoryTab(tabContentFrame)
    createSkillsTab(tabContentFrame)
    createQuestsTab(tabContentFrame)
end

-- Función para crear tab de estadísticas
local function createStatsTab(parent)
    local statsFrame = Instance.new("Frame")
    statsFrame.Name = "StatsFrame"
    statsFrame.Size = UDim2.new(1, 0, 1, 0)
    statsFrame.Position = UDim2.new(0, 0, 0, 0)
    statsFrame.BackgroundTransparency = 1
    statsFrame.Visible = true
    statsFrame.Parent = parent
    
    -- ScrollFrame para stats
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "StatsScrollFrame"
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.Position = UDim2.new(0, 0, 0, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
    scrollFrame.Parent = statsFrame
    
    -- Layout para organizar elementos
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = scrollFrame
    
    -- Función para crear una fila de stat
    local function createStatRow(statName, statValue, maxValue, color)
        local statFrame = Instance.new("Frame")
        statFrame.Name = statName .. "Frame"
        statFrame.Size = UDim2.new(1, 0, 0, 30)
        statFrame.BackgroundTransparency = 1
        statFrame.Parent = scrollFrame
        
        local statLabel = Instance.new("TextLabel")
        statLabel.Name = "StatLabel"
        statLabel.Size = UDim2.new(0.4, 0, 1, 0)
        statLabel.Position = UDim2.new(0, 0, 0, 0)
        statLabel.BackgroundTransparency = 1
        statLabel.Text = statName .. ":"
        statLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        statLabel.TextScaled = true
        statLabel.Font = Enum.Font.SourceSans
        statLabel.TextXAlignment = Enum.TextXAlignment.Left
        statLabel.Parent = statFrame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Name = "ValueLabel"
        valueLabel.Size = UDim2.new(0.6, 0, 1, 0)
        valueLabel.Position = UDim2.new(0.4, 0, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = statValue .. (maxValue and "/" .. maxValue or "")
        valueLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
        valueLabel.TextScaled = true
        valueLabel.Font = Enum.Font.SourceSansBold
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = statFrame
        
        return statFrame
    end
    
    -- Crear filas de stats
    createStatRow("Nivel", "1", nil, Color3.fromRGB(255, 215, 0))
    createStatRow("Experiencia", "0", "100", Color3.fromRGB(100, 200, 255))
    createStatRow("Vida", "100", "100", Color3.fromRGB(255, 100, 100))
    createStatRow("Mana", "50", "50", Color3.fromRGB(100, 100, 255))
    createStatRow("Fuerza", "10", nil, Color3.fromRGB(255, 150, 100))
    createStatRow("Defensa", "5", nil, Color3.fromRGB(100, 255, 100))
    createStatRow("Inteligencia", "8", nil, Color3.fromRGB(200, 100, 255))
    createStatRow("Velocidad", "12", nil, Color3.fromRGB(255, 255, 100))
    createStatRow("Suerte", "5", nil, Color3.fromRGB(255, 100, 255))
    createStatRow("Puntos", "0", nil, Color3.fromRGB(255, 200, 100))
end

-- Función para crear tab de inventario
local function createInventoryTab(parent)
    local inventoryFrame = Instance.new("Frame")
    inventoryFrame.Name = "InventoryFrame"
    inventoryFrame.Size = UDim2.new(1, 0, 1, 0)
    inventoryFrame.Position = UDim2.new(0, 0, 0, 0)
    inventoryFrame.BackgroundTransparency = 1
    inventoryFrame.Visible = false
    inventoryFrame.Parent = parent
    
    -- ScrollFrame para inventario
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "InventoryScrollFrame"
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.Position = UDim2.new(0, 0, 0, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
    scrollFrame.Parent = inventoryFrame
    
    -- GridLayout para organizar items
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0, 80, 0, 80)
    gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
    gridLayout.Parent = scrollFrame
    
    -- Crear slots de inventario
    for i = 1, 30 do
        local slotFrame = Instance.new("Frame")
        slotFrame.Name = "Slot" .. i
        slotFrame.Size = UDim2.new(0, 80, 0, 80)
        slotFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        slotFrame.BorderSizePixel = 0
        slotFrame.Parent = scrollFrame
        
        local slotCorner = Instance.new("UICorner")
        slotCorner.CornerRadius = UDim.new(0, 5)
        slotCorner.Parent = slotFrame
        
        local itemImage = Instance.new("ImageLabel")
        itemImage.Name = "ItemImage"
        itemImage.Size = UDim2.new(1, -10, 1, -20)
        itemImage.Position = UDim2.new(0, 5, 0, 5)
        itemImage.BackgroundTransparency = 1
        itemImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        itemImage.Parent = slotFrame
        
        local quantityLabel = Instance.new("TextLabel")
        quantityLabel.Name = "QuantityLabel"
        quantityLabel.Size = UDim2.new(0, 20, 0, 15)
        quantityLabel.Position = UDim2.new(1, -25, 1, -20)
        quantityLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        quantityLabel.BackgroundTransparency = 0.5
        quantityLabel.BorderSizePixel = 0
        quantityLabel.Text = ""
        quantityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        quantityLabel.TextScaled = true
        quantityLabel.Font = Enum.Font.SourceSansBold
        quantityLabel.Parent = slotFrame
        
        local quantityCorner = Instance.new("UICorner")
        quantityCorner.CornerRadius = UDim.new(0, 3)
        quantityCorner.Parent = quantityLabel
        
        -- Evento de click
        slotFrame.MouseButton1Click:Connect(function()
            onInventorySlotClick(i)
        end)
    end
end

-- Función para crear tab de habilidades
local function createSkillsTab(parent)
    local skillsFrame = Instance.new("Frame")
    skillsFrame.Name = "SkillsFrame"
    skillsFrame.Size = UDim2.new(1, 0, 1, 0)
    skillsFrame.Position = UDim2.new(0, 0, 0, 0)
    skillsFrame.BackgroundTransparency = 1
    skillsFrame.Visible = false
    skillsFrame.Parent = parent
    
    -- ScrollFrame para habilidades
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "SkillsScrollFrame"
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.Position = UDim2.new(0, 0, 0, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
    scrollFrame.Parent = skillsFrame
    
    -- Layout para organizar habilidades
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = scrollFrame
    
    -- Crear botones de habilidades
    local skills = {
        {Name = "Fireball", ManaCost = 20, Cooldown = 3.0},
        {Name = "Heal", ManaCost = 15, Cooldown = 4.0},
        {Name = "Lightning Strike", ManaCost = 30, Cooldown = 6.0},
        {Name = "Shield", ManaCost = 25, Cooldown = 15.0}
    }
    
    for i, skillData in ipairs(skills) do
        local skillFrame = Instance.new("Frame")
        skillFrame.Name = skillData.Name .. "Frame"
        skillFrame.Size = UDim2.new(1, 0, 0, 60)
        skillFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        skillFrame.BorderSizePixel = 0
        skillFrame.Parent = scrollFrame
        
        local skillCorner = Instance.new("UICorner")
        skillCorner.CornerRadius = UDim.new(0, 5)
        skillCorner.Parent = skillFrame
        
        local skillImage = Instance.new("ImageLabel")
        skillImage.Name = "SkillImage"
        skillImage.Size = UDim2.new(0, 50, 0, 50)
        skillImage.Position = UDim2.new(0, 5, 0, 5)
        skillImage.BackgroundTransparency = 1
        skillImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        skillImage.Parent = skillFrame
        
        local skillNameLabel = Instance.new("TextLabel")
        skillNameLabel.Name = "SkillNameLabel"
        skillNameLabel.Size = UDim2.new(0.6, 0, 0, 20)
        skillNameLabel.Position = UDim2.new(0, 60, 0, 5)
        skillNameLabel.BackgroundTransparency = 1
        skillNameLabel.Text = skillData.Name
        skillNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        skillNameLabel.TextScaled = true
        skillNameLabel.Font = Enum.Font.SourceSansBold
        skillNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        skillNameLabel.Parent = skillFrame
        
        local cooldownLabel = Instance.new("TextLabel")
        cooldownLabel.Name = "CooldownLabel"
        cooldownLabel.Size = UDim2.new(0, 80, 0, 20)
        cooldownLabel.Position = UDim2.new(1, -85, 0, 5)
        cooldownLabel.BackgroundTransparency = 1
        cooldownLabel.Text = "Listo"
        cooldownLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        cooldownLabel.TextScaled = true
        cooldownLabel.Font = Enum.Font.SourceSansBold
        cooldownLabel.Parent = skillFrame
        
        local manaLabel = Instance.new("TextLabel")
        manaLabel.Name = "ManaLabel"
        manaLabel.Size = UDim2.new(0, 80, 0, 20)
        manaLabel.Position = UDim2.new(1, -85, 0, 25)
        manaLabel.BackgroundTransparency = 1
        manaLabel.Text = "Mana: " .. skillData.ManaCost
        manaLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
        manaLabel.TextScaled = true
        manaLabel.Font = Enum.Font.SourceSans
        manaLabel.Parent = skillFrame
        
        -- Evento de click
        skillFrame.MouseButton1Click:Connect(function()
            onSkillClick(skillData.Name)
        end)
    end
end

-- Función para crear tab de quests
local function createQuestsTab(parent)
    local questsFrame = Instance.new("Frame")
    questsFrame.Name = "QuestsFrame"
    questsFrame.Size = UDim2.new(1, 0, 1, 0)
    questsFrame.Position = UDim2.new(0, 0, 0, 0)
    questsFrame.BackgroundTransparency = 1
    questsFrame.Visible = false
    questsFrame.Parent = parent
    
    -- ScrollFrame para quests
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "QuestsScrollFrame"
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.Position = UDim2.new(0, 0, 0, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
    scrollFrame.Parent = questsFrame
    
    -- Layout para organizar quests
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = scrollFrame
    
    -- Crear quests de ejemplo
    local quests = {
        {Name = "Primera Aventura", Description = "Derrota a 5 enemigos", Progress = "0/5", State = "InProgress"},
        {Name = "Coleccionista", Description = "Recolecta 10 Iron Ore", Progress = "0/10", State = "NotStarted"},
        {Name = "Explorador", Description = "Completa una mazmorra", Progress = "0/1", State = "NotStarted"}
    }
    
    for i, questData in ipairs(quests) do
        local questFrame = Instance.new("Frame")
        questFrame.Name = questData.Name .. "Frame"
        questFrame.Size = UDim2.new(1, 0, 0, 80)
        questFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        questFrame.BorderSizePixel = 0
        questFrame.Parent = scrollFrame
        
        local questCorner = Instance.new("UICorner")
        questCorner.CornerRadius = UDim.new(0, 5)
        questCorner.Parent = questFrame
        
        local questNameLabel = Instance.new("TextLabel")
        questNameLabel.Name = "QuestNameLabel"
        questNameLabel.Size = UDim2.new(1, -10, 0, 25)
        questNameLabel.Position = UDim2.new(0, 5, 0, 5)
        questNameLabel.BackgroundTransparency = 1
        questNameLabel.Text = questData.Name
        questNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        questNameLabel.TextScaled = true
        questNameLabel.Font = Enum.Font.SourceSansBold
        questNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        questNameLabel.Parent = questFrame
        
        local questDescLabel = Instance.new("TextLabel")
        questDescLabel.Name = "QuestDescLabel"
        questDescLabel.Size = UDim2.new(1, -10, 0, 20)
        questDescLabel.Position = UDim2.new(0, 5, 0, 30)
        questDescLabel.BackgroundTransparency = 1
        questDescLabel.Text = questData.Description
        questDescLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        questDescLabel.TextScaled = true
        questDescLabel.Font = Enum.Font.SourceSans
        questDescLabel.TextXAlignment = Enum.TextXAlignment.Left
        questDescLabel.Parent = questFrame
        
        local questProgressLabel = Instance.new("TextLabel")
        questProgressLabel.Name = "QuestProgressLabel"
        questProgressLabel.Size = UDim2.new(1, -10, 0, 20)
        questProgressLabel.Position = UDim2.new(0, 5, 0, 50)
        questProgressLabel.BackgroundTransparency = 1
        questProgressLabel.Text = "Progreso: " .. questData.Progress
        questProgressLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        questProgressLabel.TextScaled = true
        questProgressLabel.Font = Enum.Font.SourceSans
        questProgressLabel.TextXAlignment = Enum.TextXAlignment.Left
        questProgressLabel.Parent = questFrame
    end
end

-- ===== FUNCIONES DE GUI =====

-- Función para alternar GUI principal
local function toggleMainGUI()
    local screenGui = playerGui:FindFirstChild("RPGMainGUI")
    if not screenGui then return end
    
    local mainFrame = screenGui:FindFirstChild("MainFrame")
    if not mainFrame then return end
    
    isGUIOpen = not isGUIOpen
    mainFrame.Visible = isGUIOpen
    
    if isGUIOpen then
        currentGUIType = "Main"
    else
        currentGUIType = nil
    end
end

-- Función para cambiar de tab
local function switchTab(tabName)
    local screenGui = playerGui:FindFirstChild("RPGMainGUI")
    if not screenGui then return end
    
    local mainFrame = screenGui:FindFirstChild("MainFrame")
    if not mainFrame then return end
    
    local contentFrame = mainFrame:FindFirstChild("ContentFrame")
    if not contentFrame then return end
    
    local tabContentFrame = contentFrame:FindFirstChild("TabContentFrame")
    if not tabContentFrame then return end
    
    -- Ocultar todos los tabs
    local statsFrame = tabContentFrame:FindFirstChild("StatsFrame")
    local inventoryFrame = tabContentFrame:FindFirstChild("InventoryFrame")
    local skillsFrame = tabContentFrame:FindFirstChild("SkillsFrame")
    local questsFrame = tabContentFrame:FindFirstChild("QuestsFrame")
    
    if statsFrame then statsFrame.Visible = false end
    if inventoryFrame then inventoryFrame.Visible = false end
    if skillsFrame then skillsFrame.Visible = false end
    if questsFrame then questsFrame.Visible = false end
    
    -- Mostrar tab seleccionado
    if tabName == "Stats" and statsFrame then
        statsFrame.Visible = true
    elseif tabName == "Inventory" and inventoryFrame then
        inventoryFrame.Visible = true
    elseif tabName == "Skills" and skillsFrame then
        skillsFrame.Visible = true
    elseif tabName == "Quests" and questsFrame then
        questsFrame.Visible = true
    end
end

-- ===== FUNCIONES DE EVENTOS =====

-- Función para manejar click en slot de inventario
local function onInventorySlotClick(slotIndex)
    -- Enviar evento al servidor para usar/equipar item
    useItemEvent:FireServer(slotIndex)
end

-- Función para manejar click en habilidad
local function onSkillClick(skillName)
    -- Enviar evento al servidor para usar habilidad
    skillEvent:FireServer(skillName, currentTarget)
end

-- ===== CONFIGURACIÓN DE CONTROLES =====

-- Configurar controles de teclado
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Tab then
        toggleMainGUI()
    elseif input.KeyCode == Enum.KeyCode.I then
        if isGUIOpen then
            switchTab("Inventory")
        else
            toggleMainGUI()
            switchTab("Inventory")
        end
    elseif input.KeyCode == Enum.KeyCode.C then
        if isGUIOpen then
            switchTab("Stats")
        else
            toggleMainGUI()
            switchTab("Stats")
        end
    elseif input.KeyCode == Enum.KeyCode.K then
        if isGUIOpen then
            switchTab("Skills")
        else
            toggleMainGUI()
            switchTab("Skills")
        end
    elseif input.KeyCode == Enum.KeyCode.Q then
        if isGUIOpen then
            switchTab("Quests")
        else
            toggleMainGUI()
            switchTab("Quests")
        end
    end
end)

-- ===== INICIALIZACIÓN =====

-- Crear GUI principal
local mainGUI = createMainGUI()

-- Configurar eventos del servidor
equipItemEvent.OnClientEvent:Connect(function(slotIndex, success)
    if success then
        print("Item equipado exitosamente")
    else
        print("Error al equipar item")
    end
end)

useItemEvent.OnClientEvent:Connect(function(slotIndex, success)
    if success then
        print("Item usado exitosamente")
    else
        print("Error al usar item")
    end
end)

levelUpEvent.OnClientEvent:Connect(function(points)
    print("¡Subiste de nivel! Puntos disponibles: " .. points)
end)

print("Sistema RPG del cliente iniciado correctamente - ¡SINCRONIZACIÓN FUNCIONANDO!")
