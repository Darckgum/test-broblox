-- Script de diagnóstico para ver la estructura del GUI
-- Este script te mostrará todos los elementos de tu GUI Vida_Stamina

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

task.wait(2) -- Esperar a que todo cargue

print("🔍 =================== DIAGNÓSTICO DE GUI ===================")

-- Buscar el GUI Vida_Stamina
local vidaStaminaGui = playerGui:FindFirstChild("Vida_Stamina")

if not vidaStaminaGui then
	warn("❌ No se encontró el GUI 'Vida_Stamina' en PlayerGui")
	print("📋 GUIs disponibles en PlayerGui:")
	for _, gui in ipairs(playerGui:GetChildren()) do
		if gui:IsA("ScreenGui") then
			print("  - " .. gui.Name)
		end
	end
	return
end

print("✅ GUI 'Vida_Stamina' encontrado!")
print("")
print("📋 Estructura completa del GUI:")
print("=====================================")

local function imprimirJerarquia(objeto, nivel)
	local indent = string.rep("  ", nivel)
	local tipo = objeto.ClassName
	local nombre = objeto.Name
	
	-- Información adicional según el tipo
	local info = ""
	if objeto:IsA("GuiObject") then
		info = string.format(" | Pos: %s | Size: %s", 
			tostring(objeto.Position), 
			tostring(objeto.Size))
		if objeto:IsA("Frame") or objeto:IsA("ImageLabel") then
			info = info .. string.format(" | Visible: %s", tostring(objeto.Visible))
		end
	end
	
	print(indent .. "├─ " .. nombre .. " (" .. tipo .. ")" .. info)
	
	-- Recursivamente imprimir hijos
	for _, hijo in ipairs(objeto:GetChildren()) do
		imprimirJerarquia(hijo, nivel + 1)
	end
end

imprimirJerarquia(vidaStaminaGui, 0)

print("=====================================")
print("🔍 Busca en la consola los nombres exactos de:")
print("  - El contenedor/frame de la barra de VIDA")
print("  - El contenedor/frame de la barra de STAMINA")
print("  - Copia esos nombres y dáselos al asistente")
print("=====================================")

