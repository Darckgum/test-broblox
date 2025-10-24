-- SCRIPT_REPOSICIONAR_BARRAS.lua
-- Pon este script como LocalScript en StarterPlayer > StarterPlayerScripts
-- Esto moverá automáticamente las barras a la esquina superior derecha

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Esperar a que cargue el GUI
local vidaStaminaGui = playerGui:WaitForChild("Vida_Stamina", 10)

if vidaStaminaGui then
	print("✅ Encontré el GUI de Vida_Stamina")
	
	-- Buscar el contenedor principal (Frame que contiene las barras)
	-- Ajusta estos nombres según los nombres reales de tus Frames
	
	-- Si el ScreenGui tiene un Frame principal
	local mainFrame = vidaStaminaGui:FindFirstChildOfClass("Frame")
	
	if mainFrame then
		-- Mover a esquina superior derecha
		mainFrame.Position = UDim2.new(1, -320, 0, 20)  -- 20 píxeles desde arriba, 320 desde la derecha
		mainFrame.AnchorPoint = Vector2.new(1, 0)  -- Anclar desde la esquina superior derecha
		
		print("✅ Barras reposicionadas a la esquina superior derecha")
	else
		-- Si las barras están directamente en el ScreenGui sin Frame contenedor
		for _, child in ipairs(vidaStaminaGui:GetChildren()) do
			if child:IsA("Frame") then
				-- Ajustar posición de cada Frame
				local currentY = child.Position.Y.Offset
				child.Position = UDim2.new(1, -320, 0, currentY)
				child.AnchorPoint = Vector2.new(1, 0)
			end
		end
		
		print("✅ Barras individuales reposicionadas a la esquina superior derecha")
	end
else
	warn("❌ No se encontró el GUI Vida_Stamina")
end

