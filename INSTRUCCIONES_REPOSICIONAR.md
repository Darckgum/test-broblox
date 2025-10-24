# 📍 Cómo Reposicionar las Barras a la Esquina Superior Derecha

## Opción 1: Manual (Más Fácil)

1. **En Roblox Studio:**
   - Ve a **StarterGui > Vida_Stamina**
   - Busca el **Frame principal** que contiene las barras
   
2. **Selecciona el Frame principal** y en las propiedades:
   - **Position:** `{1, -320}, {0, 20}`
   - **AnchorPoint:** `1, 0`
   
   O en formato UDim2:
   ```
   Position = UDim2.new(1, -320, 0, 20)
   AnchorPoint = Vector2.new(1, 0)
   ```

3. **Si las barras están separadas** (no en un Frame contenedor):
   - Selecciona la **barra de vida**:
     - Position: `{1, -320}, {0, 20}`
     - AnchorPoint: `1, 0`
   
   - Selecciona la **barra de stamina**:
     - Position: `{1, -320}, {0, 65}`
     - AnchorPoint: `1, 0`

---

## Opción 2: Script Automático

Si prefieres que un script lo haga automáticamente:

1. **Crea un LocalScript** en **StarterPlayer > StarterPlayerScripts**

2. **Pega este código:**

```lua
-- Script para reposicionar barras automáticamente
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Esperar al GUI
local vidaStaminaGui = playerGui:WaitForChild("Vida_Stamina", 10)

if vidaStaminaGui then
	print("✅ Reposicionando barras...")
	
	-- Buscar todos los Frames
	for _, frame in ipairs(vidaStaminaGui:GetChildren()) do
		if frame:IsA("Frame") or frame:IsA("ImageLabel") then
			-- Obtener la posición Y actual
			local posY = frame.Position.Y.Scale
			local offsetY = frame.Position.Y.Offset
			
			-- Mover a la derecha
			frame.Position = UDim2.new(1, -320, posY, offsetY)
			frame.AnchorPoint = Vector2.new(1, 0)
			
			print("📍 Reposicionado:", frame.Name)
		end
	end
	
	print("✅ Barras movidas a la esquina superior derecha")
end
```

---

## Valores Ajustables

Si quieres cambiar la posición:

- **Más a la izquierda:** Cambia `-320` por un número mayor (ej: `-400`)
- **Más a la derecha:** Cambia `-320` por un número menor (ej: `-250`)
- **Más abajo:** Cambia `20` por un número mayor (ej: `50`)
- **Más arriba:** Cambia `20` por un número menor (ej: `10`)

---

## 🎯 Resultado Esperado

Las barras deberían aparecer así:

```
                                    [====== Vida ======]
                                    [==== Stamina ====]
```

En la esquina superior derecha de la pantalla.

