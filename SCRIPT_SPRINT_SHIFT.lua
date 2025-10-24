-- SCRIPT_SPRINT_SHIFT.lua
-- Pon este script como LocalScript en StarterPlayer > StarterPlayerScripts
-- Sistema completo de sprint con SHIFT y estamina

print("🏃 Iniciando sistema de sprint con SHIFT...")

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
	WalkSpeed = 16,           -- Velocidad normal
	SprintSpeed = 26,         -- Velocidad corriendo
	MaxStamina = 100,         -- Estamina máxima
	StaminaDrain = 15,        -- Estamina que se gasta por segundo
	StaminaRegen = 20,        -- Estamina que se regenera por segundo
	MinStaminaToSprint = 5,   -- Mínimo para poder correr
	RegenDelay = 1,           -- Segundos antes de regenerar
}

-- ============================================================================
-- VARIABLES
-- ============================================================================

local currentStamina = Config.MaxStamina
local isSprinting = false
local shiftPressed = false
local lastSprintTime = 0
local canSprint = true

-- Referencias a la UI (asumiendo que tu barra de estamina está en Vida_Stamina)
local playerGui = player:WaitForChild("PlayerGui")
local vidaStaminaGui = playerGui:WaitForChild("Vida_Stamina", 5)
local staminaBar = nil

-- Buscar la barra de estamina
if vidaStaminaGui then
	-- Busca un Frame que tenga "stamina" o "Stamina" en el nombre
	for _, child in ipairs(vidaStaminaGui:GetDescendants()) do
		if child:IsA("Frame") and child.Name:lower():find("stamina") then
			staminaBar = child
			print("✅ Barra de estamina encontrada:", child.Name)
			break
		end
	end
end

-- ============================================================================
-- FUNCIONES
-- ============================================================================

-- Actualizar barra de estamina
local function updateStaminaBar()
	if staminaBar then
		local percentage = currentStamina / Config.MaxStamina
		staminaBar:TweenSize(
			UDim2.new(percentage, 0, 1, 0),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.1,
			true
		)
	end
end

-- Iniciar sprint
local function startSprint()
	if currentStamina >= Config.MinStaminaToSprint and canSprint then
		isSprinting = true
		humanoid.WalkSpeed = Config.SprintSpeed
		print("🏃 Corriendo...")
	end
end

-- Detener sprint
local function stopSprint()
	isSprinting = false
	humanoid.WalkSpeed = Config.WalkSpeed
	lastSprintTime = tick()
end

-- ============================================================================
-- EVENTOS DE TECLADO
-- ============================================================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	-- Detectar SHIFT (izquierdo o derecho)
	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
		shiftPressed = true
		startSprint()
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	-- Detectar cuando se suelta SHIFT
	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
		shiftPressed = false
		stopSprint()
	end
end)

-- ============================================================================
-- ACTUALIZACIÓN CONTINUA (ESTAMINA)
-- ============================================================================

RunService.Heartbeat:Connect(function(deltaTime)
	local isMoving = humanoid.MoveVector.Magnitude > 0
	
	-- Si está corriendo y moviéndose
	if isSprinting and isMoving then
		-- Drenar estamina
		currentStamina = math.max(0, currentStamina - (Config.StaminaDrain * deltaTime))
		updateStaminaBar()
		
		-- Si se acabó la estamina, detener sprint
		if currentStamina <= 0 then
			stopSprint()
			canSprint = false
		end
	else
		-- Regenerar estamina después del delay
		local timeSinceLastSprint = tick() - lastSprintTime
		
		if timeSinceLastSprint >= Config.RegenDelay then
			if currentStamina < Config.MaxStamina then
				currentStamina = math.min(Config.MaxStamina, currentStamina + (Config.StaminaRegen * deltaTime))
				updateStaminaBar()
			end
			
			-- Permitir sprint nuevamente
			if currentStamina >= Config.MinStaminaToSprint then
				canSprint = true
				
				-- Si SHIFT sigue presionado, reanudar sprint
				if shiftPressed and not isSprinting then
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
	
	updateStaminaBar()
end)

-- ============================================================================
-- INICIALIZACIÓN
-- ============================================================================

humanoid.WalkSpeed = Config.WalkSpeed
updateStaminaBar()

print("✅ Sistema de sprint con SHIFT activado")
print("💡 Mantén [SHIFT] presionado para correr")

