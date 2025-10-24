-- Script para reposicionar barras de vida y stamina a la esquina superior derecha
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

print("📍 Reposicionando barras a la esquina superior derecha...")

-- Configuración de posición
local POSICION_X = 1 -- Anclado a la derecha (1 = 100%)
local OFFSET_X = -320 -- 320 píxeles desde el borde derecho
local OFFSET_Y_VIDA = 20 -- 20 píxeles desde arriba
local OFFSET_Y_STAMINA = 65 -- 65 píxeles desde arriba (debajo de la vida)

-- Buscar y reposicionar elementos
for _, elemento in ipairs(vidaStaminaGui:GetDescendants()) do
	if elemento:IsA("Frame") or elemento:IsA("ImageLabel") then
		local nombre = elemento.Name:lower()
		
		-- Detectar contenedor de vida
		if nombre:find("vida") or nombre:find("health") or nombre:find("hp") then
			if not nombre:find("barra") then -- Contenedor principal, no la barra interna
				elemento.Position = UDim2.new(POSICION_X, OFFSET_X, 0, OFFSET_Y_VIDA)
				elemento.AnchorPoint = Vector2.new(1, 0)
				print("✅ Reposicionado:", elemento.Name, "→ Superior Derecha (Vida)")
			end
		end
		
		-- Detectar contenedor de stamina
		if nombre:find("stamina") or nombre:find("energia") then
			if not nombre:find("barra") then -- Contenedor principal, no la barra interna
				elemento.Position = UDim2.new(POSICION_X, OFFSET_X, 0, OFFSET_Y_STAMINA)
				elemento.AnchorPoint = Vector2.new(1, 0)
				print("✅ Reposicionado:", elemento.Name, "→ Superior Derecha (Stamina)")
			end
		end
		
		-- Detectar ícono de correr
		if nombre:find("run") or nombre:find("correr") then
			-- Posicionarlo cerca de la barra de stamina
			elemento.Position = UDim2.new(POSICION_X, OFFSET_X - 40, 0, OFFSET_Y_STAMINA + 5)
			elemento.AnchorPoint = Vector2.new(1, 0)
			print("✅ Reposicionado:", elemento.Name, "→ Ícono de correr")
		end
	end
end

print("✅ Barras reposicionadas correctamente")

