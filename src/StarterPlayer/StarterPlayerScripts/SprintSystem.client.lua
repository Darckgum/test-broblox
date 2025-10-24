--[ SISTEMA DE SPRINT CON STAMINA - OPTIMIZADO ]
-- Este script reemplaza el anterior con mejor rendimiento

--[ Servicios ] 
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

--[ Variables ]
local Jugador = game.Players.LocalPlayer
local Character = Jugador.Character or Jugador.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Buscar elementos del GUI
local PlayerGui = Jugador:WaitForChild("PlayerGui")
local vidaStaminaGui = PlayerGui:WaitForChild("Vida_Stamina", 10)

if not vidaStaminaGui then
	warn("❌ No se encontró el GUI Vida_Stamina")
	return
end

-- Buscar barras (búsqueda recursiva para encontrarlas sin importar la estructura)
local barraStamina = nil
local run_Icon = nil

for _, descendant in ipairs(vidaStaminaGui:GetDescendants()) do
	if descendant:IsA("Frame") or descendant:IsA("ImageLabel") then
		local nombre = descendant.Name:lower()
		if nombre:find("stamina") and not nombre:find("contenedor") then
			barraStamina = descendant
			print("✅ Barra de stamina encontrada:", descendant.Name)
		elseif nombre:find("run") or nombre:find("correr") then
			run_Icon = descendant
			print("✅ Icono de correr encontrado:", descendant.Name)
		end
	end
end

-- Buscar evento remoto si existe
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local eventoCorrer = ReplicatedStorage:FindFirstChild("CorrerEvento", true)

local corriendo = false

--{Variables Configurables}
local tecla = "LeftShift"
local velocidadCaminando = 16
local velocidadCorriendo = velocidadCaminando * 1.5
local staminaTotal = 100
local velocidadRegeneracion = 17 -- stamina por segundo (similar a tu 5 cada 0.3s)
local velocidadGasto = 17 -- stamina por segundo (similar a tu 5 cada 0.3s)
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
	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
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
		if Humanoid.MoveDirection.Magnitude > 0 and stamina > 0 then
			iniciarSprint()
		end
	end
end)

UIS.InputEnded:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode[tecla] then
		detenerSprint()
	end
end)

-- [ Actualización Continua - MÁS EFICIENTE ]
-- Usa RunService.Heartbeat en vez de loops con wait()
-- Esto previene múltiples loops corriendo al mismo tiempo

RunService.Heartbeat:Connect(function()
	local ahora = tick()
	local deltaTime = ahora - ultimoTiempo
	ultimoTiempo = ahora
	
	local estaMoviendose = Humanoid.MoveDirection.Magnitude > 0
	
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

print("✅ Sistema de Sprint OPTIMIZADO cargado")
print("💡 Mantén [LEFT SHIFT] para correr")

