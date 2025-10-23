-- HealthStaminaUI.client.lua
-- UI de barras de vida y estamina

print("❤️ INICIANDO UI DE VIDA Y ESTAMINA...")

-- ============================================================================
-- SERVICIOS
-- ============================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================================================
-- CONFIGURACIÓN DE COLORES
-- ============================================================================

local Colors = {
	Health = Color3.fromRGB(231, 76, 60),      -- Rojo
	HealthBg = Color3.fromRGB(40, 40, 45),
	Stamina = Color3.fromRGB(52, 211, 153),    -- Verde agua
	StaminaBg = Color3.fromRGB(40, 40, 45),
	Text = Color3.fromRGB(240, 240, 245),
}

-- ============================================================================
-- VARIABLES
-- ============================================================================

local screenGui = nil
local healthBar = nil
local healthFill = nil
local healthText = nil
local staminaBar = nil
local staminaFill = nil
local staminaText = nil

-- ============================================================================
-- FUNCIONES DE CREACIÓN DE UI
-- ============================================================================

local function createCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent
	return corner
end

local function createStroke(parent, color, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = thickness
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = parent
	return stroke
end

-- Crear barra de vida
local function createHealthBar(parent)
	-- Contenedor de la barra
	local container = Instance.new("Frame")
	container.Name = "HealthBar"
	container.Size = UDim2.new(0, 350, 0, 35)
	container.Position = UDim2.new(0.5, -175, 0, 20)
	container.BackgroundColor3 = Colors.HealthBg
	container.BorderSizePixel = 0
	container.ZIndex = 1  -- IMPORTANTE: Debajo del inventario
	container.Parent = parent
	
	createCorner(container, 8)
	createStroke(container, Color3.fromRGB(60, 60, 65), 2)
	
	-- Barra de relleno (vida actual)
	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.new(1, -4, 1, -4)
	fill.Position = UDim2.new(0, 2, 0, 2)
	fill.BackgroundColor3 = Colors.Health
	fill.BorderSizePixel = 0
	fill.ZIndex = 2
	fill.Parent = container
	
	createCorner(fill, 6)
	
	-- Texto de HP
	local text = Instance.new("TextLabel")
	text.Name = "Text"
	text.Size = UDim2.new(1, 0, 1, 0)
	text.BackgroundTransparency = 1
	text.Text = "❤️ 100 / 100"
	text.TextColor3 = Colors.Text
	text.TextSize = 16
	text.Font = Enum.Font.GothamBold
	text.ZIndex = 3
	text.Parent = container
	
	-- Sombra para el texto
	local textShadow = Instance.new("TextLabel")
	textShadow.Size = text.Size
	textShadow.Position = UDim2.new(0, 1, 0, 1)
	textShadow.BackgroundTransparency = 1
	textShadow.Text = text.Text
	textShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
	textShadow.TextSize = text.TextSize
	textShadow.Font = text.Font
	textShadow.TextTransparency = 0.5
	textShadow.ZIndex = 2
	textShadow.Parent = container
	
	return container, fill, text, textShadow
end

-- Crear barra de estamina
local function createStaminaBar(parent)
	-- Contenedor de la barra
	local container = Instance.new("Frame")
	container.Name = "StaminaBar"
	container.Size = UDim2.new(0, 350, 0, 30)
	container.Position = UDim2.new(0.5, -175, 0, 60)
	container.BackgroundColor3 = Colors.StaminaBg
	container.BorderSizePixel = 0
	container.ZIndex = 1  -- IMPORTANTE: Debajo del inventario
	container.Parent = parent
	
	createCorner(container, 8)
	createStroke(container, Color3.fromRGB(60, 60, 65), 2)
	
	-- Barra de relleno (estamina actual)
	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.new(1, -4, 1, -4)
	fill.Position = UDim2.new(0, 2, 0, 2)
	fill.BackgroundColor3 = Colors.Stamina
	fill.BorderSizePixel = 0
	fill.ZIndex = 2
	fill.Parent = container
	
	createCorner(fill, 6)
	
	-- Texto de estamina
	local text = Instance.new("TextLabel")
	text.Name = "Text"
	text.Size = UDim2.new(1, 0, 1, 0)
	text.BackgroundTransparency = 1
	text.Text = "💨 100 / 100"
	text.TextColor3 = Colors.Text
	text.TextSize = 14
	text.Font = Enum.Font.GothamBold
	text.ZIndex = 3
	text.Parent = container
	
	-- Sombra para el texto
	local textShadow = Instance.new("TextLabel")
	textShadow.Size = text.Size
	textShadow.Position = UDim2.new(0, 1, 0, 1)
	textShadow.BackgroundTransparency = 1
	textShadow.Text = text.Text
	textShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
	textShadow.TextSize = text.TextSize
	textShadow.Font = text.Font
	textShadow.TextTransparency = 0.5
	textShadow.ZIndex = 2
	textShadow.Parent = container
	
	return container, fill, text, textShadow
end

-- ============================================================================
-- ACTUALIZACIÓN DE BARRAS
-- ============================================================================

local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Actualizar barra de vida
local function updateHealthBar()
	local currentHealth = humanoid.Health
	local maxHealth = humanoid.MaxHealth
	local percentage = currentHealth / maxHealth
	
	-- Animar el relleno
	local goal = {Size = UDim2.new(percentage, -4, 1, -4)}
	TweenService:Create(healthFill, tweenInfo, goal):Play()
	
	-- Actualizar texto
	local text = string.format("❤️ %d / %d", math.floor(currentHealth), math.floor(maxHealth))
	healthText.Text = text
	healthText.Parent:FindFirstChild("TextLabel").Text = text -- Shadow
	
	-- Cambiar color según porcentaje
	if percentage > 0.6 then
		healthFill.BackgroundColor3 = Colors.Health
	elseif percentage > 0.3 then
		healthFill.BackgroundColor3 = Color3.fromRGB(243, 156, 18) -- Amarillo
	else
		healthFill.BackgroundColor3 = Color3.fromRGB(192, 57, 43) -- Rojo oscuro
	end
end

-- Actualizar barra de estamina
local function updateStaminaBar(current, max)
	local percentage = current / max
	
	-- Animar el relleno
	local goal = {Size = UDim2.new(percentage, -4, 1, -4)}
	TweenService:Create(staminaFill, tweenInfo, goal):Play()
	
	-- Actualizar texto
	local text = string.format("💨 %d / %d", math.floor(current), math.floor(max))
	staminaText.Text = text
	staminaText.Parent:FindFirstChild("TextLabel").Text = text -- Shadow
	
	-- Cambiar color según porcentaje
	if percentage > 0.5 then
		staminaFill.BackgroundColor3 = Colors.Stamina
	elseif percentage > 0.2 then
		staminaFill.BackgroundColor3 = Color3.fromRGB(241, 196, 15) -- Amarillo
	else
		staminaFill.BackgroundColor3 = Color3.fromRGB(230, 126, 34) -- Naranja
	end
end

-- ============================================================================
-- INICIALIZACIÓN
-- ============================================================================

-- Crear ScreenGui
screenGui = Instance.new("ScreenGui")
screenGui.Name = "HealthStaminaUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 1  -- Debajo del inventario (el inventario tendrá mayor DisplayOrder)
screenGui.Parent = playerGui

-- Crear barras
local healthBarContainer, hFill, hText, hShadow = createHealthBar(screenGui)
healthBar = healthBarContainer
healthFill = hFill
healthText = hText

local staminaBarContainer, sFill, sText, sShadow = createStaminaBar(screenGui)
staminaBar = staminaBarContainer
staminaFill = sFill
staminaText = sText

-- Conectar eventos de vida
humanoid.HealthChanged:Connect(function()
	updateHealthBar()
end)

-- Conectar eventos de estamina (desde el sistema de estamina)
local staminaEvent = player:WaitForChild("StaminaChanged", 5)
if staminaEvent then
	staminaEvent.Event:Connect(function(current, max)
		updateStaminaBar(current, max)
	end)
end

-- Actualización inicial
updateHealthBar()
updateStaminaBar(100, 100)

-- ============================================================================
-- MANEJO DE RESPAWN
-- ============================================================================

player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")
	
	-- Reconectar eventos
	humanoid.HealthChanged:Connect(function()
		updateHealthBar()
	end)
	
	-- Actualizar barras
	updateHealthBar()
	updateStaminaBar(100, 100)
end)

print("✅ UI de vida y estamina cargada")

