-- Script para posicionar barras de vida y stamina en la esquina superior IZQUIERDA
-- Se ejecuta automáticamente al iniciar el juego

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Esperar al GUI de vida y stamina
local vidaStaminaGui = playerGui:WaitForChild("Vida_Stamina", 10)

if not vidaStaminaGui then
	warn("❌ No se encontró el GUI Vida_Stamina")
	return
end

print("📍 Posicionando barras en la esquina superior IZQUIERDA...")

-- Configuración de posición (SUPERIOR IZQUIERDA)
local POSICION_X = 0 -- Anclado a la izquierda (0 = 0%)
local OFFSET_X = 20 -- 20 píxeles desde el borde izquierdo
local OFFSET_Y_VIDA = 20 -- 20 píxeles desde arriba
local OFFSET_Y_STAMINA = 65 -- 65 píxeles desde arriba (debajo de la vida)

-- Buscar y reposicionar elementos
for _, elemento in ipairs(vidaStaminaGui:GetDescendants()) do
	if elemento:IsA("Frame") or elemento:IsA("ImageLabel") then
		local nombre = elemento.Name:lower()
		
		-- Detectar contenedor de vida
		if (nombre:find("vida") or nombre:find("health") or nombre:find("hp")) and not nombre:find("fill") then
			if not nombre:find("barra") or nombre:find("frame") then -- Contenedor principal
				elemento.Position = UDim2.new(POSICION_X, OFFSET_X, 0, OFFSET_Y_VIDA)
				elemento.AnchorPoint = Vector2.new(0, 0) -- Anclar desde la esquina superior izquierda
				print("✅ Posicionado:", elemento.Name, "→ Superior IZQUIERDA (Vida)")
			end
		end
		
		-- Detectar contenedor de stamina
		if (nombre:find("stamina") or nombre:find("energia")) and not nombre:find("fill") then
			if not nombre:find("barra") or nombre:find("frame") then -- Contenedor principal
				elemento.Position = UDim2.new(POSICION_X, OFFSET_X, 0, OFFSET_Y_STAMINA)
				elemento.AnchorPoint = Vector2.new(0, 0) -- Anclar desde la esquina superior izquierda
				print("✅ Posicionado:", elemento.Name, "→ Superior IZQUIERDA (Stamina)")
			end
		end
		
		-- Detectar ícono de correr
		if nombre:find("run") or nombre:find("correr") then
			-- Posicionarlo cerca de la barra de stamina (a la derecha de la barra)
			elemento.Position = UDim2.new(POSICION_X, OFFSET_X + 260, 0, OFFSET_Y_STAMINA + 5)
			elemento.AnchorPoint = Vector2.new(0, 0)
			print("✅ Posicionado:", elemento.Name, "→ Ícono de correr")
		end
	end
end

print("✅ Barras posicionadas en SUPERIOR IZQUIERDA correctamente")

