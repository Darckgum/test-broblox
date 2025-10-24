-- Script simple para posicionar barras de vida y stamina arriba a la izquierda
-- Funciona buscando todos los elementos GUI

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

task.wait(1) -- Esperar a que todo cargue

print("🔧 Buscando y arreglando barras de vida y stamina...")

-- Buscar en todos los ScreenGuis
for _, screenGui in ipairs(playerGui:GetChildren()) do
	if screenGui:IsA("ScreenGui") then
		local nombre = screenGui.Name:lower()
		
		-- Si el ScreenGui contiene "vida" o "stamina"
		if nombre:find("vida") or nombre:find("stamina") or nombre:find("health") then
			print("✅ Encontrado ScreenGui:", screenGui.Name)
			
			-- Buscar todos los frames dentro
			for _, elemento in ipairs(screenGui:GetDescendants()) do
				if elemento:IsA("Frame") or elemento:IsA("ImageLabel") or elemento:IsA("TextLabel") then
					local nombreElemento = elemento.Name:lower()
					
					-- Detectar si es un contenedor principal (no una barra de relleno)
					local esContenedor = not (nombreElemento:find("fill") or 
					                         nombreElemento:find("barra") or
					                         nombreElemento:find("bar"))
					
					-- Si es vida
					if (nombreElemento:find("vida") or nombreElemento:find("health") or nombreElemento:find("hp")) and esContenedor then
						elemento.Position = UDim2.new(0, 20, 0, 20) -- Superior izquierda
						elemento.AnchorPoint = Vector2.new(0, 0)
						print("  → Barra de VIDA reposicionada:", elemento.Name)
					end
					
					-- Si es stamina
					if (nombreElemento:find("stamina") or nombreElemento:find("energia")) and esContenedor then
						elemento.Position = UDim2.new(0, 20, 0, 65) -- Debajo de vida
						elemento.AnchorPoint = Vector2.new(0, 0)
						elemento.Visible = true -- Asegurar que sea visible
						print("  → Barra de STAMINA reposicionada:", elemento.Name)
					end
					
					-- Si es icono de correr
					if nombreElemento:find("run") or nombreElemento:find("correr") then
						elemento.Position = UDim2.new(0, 280, 0, 70)
						elemento.AnchorPoint = Vector2.new(0, 0)
						print("  → Ícono de CORRER reposicionado:", elemento.Name)
					end
				end
			end
		end
	end
end

print("✅ Script de arreglo completado")

