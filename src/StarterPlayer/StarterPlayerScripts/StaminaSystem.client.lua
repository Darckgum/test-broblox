-- StaminaSystem.client.lua
-- Sistema completo de sprint con estamina

print("💨 INICIANDO SISTEMA DE ESTAMINA...")

-- ============================================================================
-- SERVICIOS
-- ============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- ============================================================================
-- CONFIGURACIÓN
-- ============================================================================

local Config = {
	-- Velocidades
	WalkSpeed = 16,
	SprintSpeed = 26,
	
	-- Estamina
	MaxStamina = 100,
	StaminaDrainRate = 15, -- por segundo
	StaminaRegenRate = 20, -- por segundo
	MinStaminaToSprint = 5, -- mínimo para empezar a correr
	
	-- Delays
	RegenDelay = 1, -- segundos antes de empezar a regenerar
}

-- ============================================================================
-- VARIABLES DE ESTADO
-- ============================================================================

local currentStamina = Config.MaxStamina
local isSprinting = false
local isShiftPressed = false
local lastSprintTime = 0
local canSprint = true

-- ============================================================================
-- ACTUALIZACIÓN DE UI
-- ============================================================================

-- Evento para actualizar la UI (se conectará desde otro script)
local staminaChanged = Instance.new("BindableEvent")
staminaChanged.Name = "StaminaChanged"
staminaChanged.Parent = player

-- Función para notificar cambios
local function updateUI()
	staminaChanged:Fire(currentStamina, Config.MaxStamina)
end

-- ============================================================================
-- FUNCIONES DE SPRINT
-- ============================================================================

-- Iniciar sprint
local function startSprint()
	if currentStamina >= Config.MinStaminaToSprint and canSprint then
		isSprinting = true
		humanoid.WalkSpeed = Config.SprintSpeed
	end
end

-- Detener sprint
local function stopSprint()
	isSprinting = false
	humanoid.WalkSpeed = Config.WalkSpeed
	lastSprintTime = tick()
end

-- ============================================================================
-- CONTROLES DE TECLADO
-- ============================================================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
		isShiftPressed = true
		startSprint()
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
		isShiftPressed = false
		stopSprint()
	end
end)

-- ============================================================================
-- ACTUALIZACIÓN CONTINUA
-- ============================================================================

RunService.Heartbeat:Connect(function(deltaTime)
	local isMoving = humanoid.MoveVector.Magnitude > 0
	
	-- Drenar estamina si está corriendo
	if isSprinting and isMoving then
		currentStamina = math.max(0, currentStamina - (Config.StaminaDrainRate * deltaTime))
		
		-- Detener sprint si se acabó la estamina
		if currentStamina <= 0 then
			stopSprint()
			canSprint = false
		end
		
		updateUI()
	else
		-- Regenerar estamina
		local timeSinceLastSprint = tick() - lastSprintTime
		
		if timeSinceLastSprint >= Config.RegenDelay then
			if currentStamina < Config.MaxStamina then
				currentStamina = math.min(Config.MaxStamina, currentStamina + (Config.StaminaRegenRate * deltaTime))
				updateUI()
			end
			
			-- Permitir sprint nuevamente si tiene suficiente estamina
			if currentStamina >= Config.MinStaminaToSprint then
				canSprint = true
				
				-- Si shift aún está presionado, reiniciar sprint
				if isShiftPressed and not isSprinting then
					startSprint()
				end
			end
		end
	end
end)

-- ============================================================================
-- MANEJO DE RESPAWN
-- ============================================================================

player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")
	
	-- Resetear valores
	currentStamina = Config.MaxStamina
	isSprinting = false
	canSprint = true
	humanoid.WalkSpeed = Config.WalkSpeed
	
	updateUI()
end)

-- ============================================================================
-- INICIALIZACIÓN
-- ============================================================================

-- Establecer velocidad inicial
humanoid.WalkSpeed = Config.WalkSpeed

-- Notificar UI inicial
updateUI()

print("✅ Sistema de estamina cargado")
print("💡 Mantén [SHIFT] para correr")

