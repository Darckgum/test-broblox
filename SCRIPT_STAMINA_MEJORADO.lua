--[ SISTEMA DE SPRINT CON STAMINA - MEJORADO ]
-- Reemplaza tu script actual con este

--[ Servicios ] 
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

--[ Variables ]
local Jugador = game.Players.LocalPlayer
local Character = Jugador.Character or Jugador.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Buscar elementos del GUI de forma más robusta
local PlayerGui = Jugador:WaitForChild("PlayerGui")
local vidaStaminaGui = PlayerGui:WaitForChild("Vida_Stamina", 10)

if not vidaStaminaGui then
	warn("❌ No se encontró el GUI Vida_Stamina")
	return
end

-- Buscar barras (ajusta los nombres si son diferentes)
local barraStamina = vidaStaminaGui:FindFirstChild("barraStamina", true) -- búsqueda recursiva
local run_Icon = vidaStaminaGui:FindFirstChild("run_Icon", true)

-- Si tienes un evento remoto para el servidor
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local eventoCorrer = ReplicatedStorage:FindFirstChild("CorrerEvento")

local corriendo = false

--{Variables Configurables}
local tecla = "LeftShift"
local velocidadCaminando = 16
local velocidadCorriendo = velocidadCaminando * 1.5
local staminaTotal = 100
local velocidadRegeneracion = 15 -- stamina por segundo
local velocidadGasto = 20 -- stamina por segundo
--{-----------------------}

local stamina = staminaTotal
local ultimoTiempo = tick()

-- [ Funciones ]

local function actualizarBarraStamina()
	if not barraStamina then return end
	
	local porcentaje = math.clamp(stamina / staminaTotal, 0, 1)
	barraStamina:TweenSize(
		UDim2.new(porcentaje, 0, 1, 0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.1,
		true
	)
end

local function cambiarFOV(valor)
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local tween = TweenService:Create(
		workspace.CurrentCamera,
		tweenInfo,
		{FieldOfView = valor}
	)
	tween:Play()
end

local function iniciarSprint()
	if stamina <= 0 then return end
	
	corriendo = true
	Humanoid.WalkSpeed = velocidadCorriendo
	cambiarFOV(85)
	
	if run_Icon then
		run_Icon.Visible = true
	end
	
	if eventoCorrer then
		eventoCorrer:FireServer("Prendido")
	end
	
	print("🏃 Corriendo...")
end

local function detenerSprint()
	corriendo = false
	Humanoid.WalkSpeed = velocidadCaminando
	cambiarFOV(70)
	
	if run_Icon then
		run_Icon.Visible = false
	end
end

-- [ Eventos de Teclado ]

UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode[tecla] then
		-- Solo correr si se está moviendo y tiene stamina
		if Humanoid.MoveVector.Magnitude > 0 and stamina > 0 then
			iniciarSprint()
		end
	end
end)

UIS.InputEnded:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode[tecla] then
		detenerSprint()
	end
end)

-- [ Actualización Continua - Más eficiente que wait() ]

RunService.Heartbeat:Connect(function()
	local ahora = tick()
	local deltaTime = ahora - ultimoTiempo
	ultimoTiempo = ahora
	
	local estaMoviendose = Humanoid.MoveVector.Magnitude > 0
	
	if corriendo and estaMoviendose then
		-- Gastar stamina
		stamina = math.max(0, stamina - (velocidadGasto * deltaTime))
		actualizarBarraStamina()
		
		-- Si se acabó la stamina, detener sprint
		if stamina <= 0 then
			detenerSprint()
		end
	else
		-- Regenerar stamina cuando no está corriendo
		if stamina < staminaTotal then
			stamina = math.min(staminaTotal, stamina + (velocidadRegeneracion * deltaTime))
			actualizarBarraStamina()
		end
		
		-- Si dejó de moverse mientras corre, detener
		if corriendo and not estaMoviendose then
			detenerSprint()
		end
	end
end)

-- [ Manejo de Respawn ]

Jugador.CharacterAdded:Connect(function(newCharacter)
	Character = newCharacter
	Humanoid = Character:WaitForChild("Humanoid")
	
	-- Resetear valores
	stamina = staminaTotal
	corriendo = false
	Humanoid.WalkSpeed = velocidadCaminando
	actualizarBarraStamina()
	
	if run_Icon then
		run_Icon.Visible = false
	end
end)

-- [ Inicialización ]

Humanoid.WalkSpeed = velocidadCaminando
actualizarBarraStamina()

print("✅ Sistema de Sprint cargado")
print("💡 Mantén [LEFT SHIFT] para correr")

