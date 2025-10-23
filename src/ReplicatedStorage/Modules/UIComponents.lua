-- UIComponents.lua
-- Componentes reutilizables y utilidades para el sistema de inventario moderno

local TweenService = game:GetService("TweenService")

local UIComponents = {}

-- ============================================================================
-- PALETA DE COLORES
-- ============================================================================

UIComponents.Colors = {
	-- Base
	Background = Color3.fromRGB(15, 15, 20),
	SlotEmpty = Color3.fromRGB(25, 25, 30),
	SlotFilled = Color3.fromRGB(35, 35, 40),
	Text = Color3.fromRGB(240, 240, 245),
	TextSecondary = Color3.fromRGB(180, 180, 190),
	
	-- Acentos
	Primary = Color3.fromRGB(0, 200, 255),
	PrimaryHover = Color3.fromRGB(100, 220, 255),
	PrimaryActive = Color3.fromRGB(0, 150, 255),
	
	-- Rareza
	Rarity = {
		Common = Color3.fromRGB(150, 150, 150),
		Uncommon = Color3.fromRGB(0, 255, 100),
		Rare = Color3.fromRGB(0, 150, 255),
		Epic = Color3.fromRGB(180, 0, 255),
		Legendary = Color3.fromRGB(255, 215, 0)
	},
	
	-- Estados
	Success = Color3.fromRGB(0, 255, 100),
	Warning = Color3.fromRGB(255, 200, 0),
	Error = Color3.fromRGB(255, 50, 50),
	
	-- Overlays
	Overlay = Color3.fromRGB(0, 0, 0),
	OverlayLight = Color3.fromRGB(255, 255, 255)
}

-- ============================================================================
-- CONFIGURACIÓN DE ANIMACIONES
-- ============================================================================

UIComponents.TweenInfo = {
	Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Normal = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Slow = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Bounce = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	Smooth = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
}

-- ============================================================================
-- FUNCIONES DE ANIMACIÓN
-- ============================================================================

-- Animar escala al hacer hover
function UIComponents.AnimateHover(element, scale)
	scale = scale or 1.05
	local tween = TweenService:Create(element, UIComponents.TweenInfo.Fast, {
		Size = UDim2.new(scale, 0, scale, 0)
	})
	tween:Play()
	return tween
end

-- Animar escala al hacer click
function UIComponents.AnimateClick(element, callback)
	local originalScale = element.Size
	
	-- Reducir escala
	local shrink = TweenService:Create(element, UIComponents.TweenInfo.Fast, {
		Size = UDim2.new(0.95, 0, 0.95, 0)
	})
	
	shrink.Completed:Connect(function()
		-- Volver a escala original
		local grow = TweenService:Create(element, UIComponents.TweenInfo.Bounce, {
			Size = originalScale
		})
		grow:Play()
		
		if callback then
			callback()
		end
	end)
	
	shrink:Play()
end

-- Animar fade in/out
function UIComponents.AnimateFade(element, targetTransparency, duration)
	duration = duration or 0.25
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	if element:IsA("Frame") or element:IsA("ImageLabel") or element:IsA("ImageButton") then
		local tween = TweenService:Create(element, tweenInfo, {
			BackgroundTransparency = targetTransparency
		})
		tween:Play()
		return tween
	elseif element:IsA("TextLabel") or element:IsA("TextButton") then
		local tween = TweenService:Create(element, tweenInfo, {
			TextTransparency = targetTransparency
		})
		tween:Play()
		return tween
	end
end

-- Animar apertura/cierre de ventana
function UIComponents.AnimateWindow(window, isOpening, callback)
	if isOpening then
		window.Visible = true
		window.Size = UDim2.new(0, 0, 0, 0)
		window.Position = UDim2.new(0.5, 0, 0.5, 0)
		
		local tween = TweenService:Create(window, UIComponents.TweenInfo.Bounce, {
			Size = UDim2.new(0, 800, 0, 600),
			Position = UDim2.new(0.5, -400, 0.5, -300)
		})
		
		tween.Completed:Connect(function()
			if callback then callback() end
		end)
		
		tween:Play()
	else
		local tween = TweenService:Create(window, UIComponents.TweenInfo.Fast, {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		})
		
		tween.Completed:Connect(function()
			window.Visible = false
			if callback then callback() end
		end)
		
		tween:Play()
	end
end

-- ============================================================================
-- COMPONENTES UI
-- ============================================================================

-- Crear esquinas redondeadas
function UIComponents.CreateCorner(parent, radius)
	radius = radius or 12
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent
	return corner
end

-- Crear borde de neón
function UIComponents.CreateStroke(parent, color, thickness)
	color = color or UIComponents.Colors.Primary
	thickness = thickness or 2
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = thickness
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = parent
	return stroke
end

-- Crear efecto de sombra
function UIComponents.CreateShadow(parent)
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.Size = UDim2.new(1, 20, 1, 20)
	shadow.Position = UDim2.new(0, -10, 0, -10)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = 0.7
	shadow.ZIndex = parent.ZIndex - 1
	shadow.Parent = parent
	return shadow
end

-- Crear slot de inventario
function UIComponents.CreateSlot(parent, slotIndex, size)
	size = size or 60
	
	local slot = Instance.new("Frame")
	slot.Name = "Slot" .. slotIndex
	slot.Size = UDim2.new(0, size, 0, size)
	slot.BackgroundColor3 = UIComponents.Colors.SlotEmpty
	slot.BorderSizePixel = 0
	slot.Parent = parent
	
	-- Esquinas redondeadas
	UIComponents.CreateCorner(slot, 8)
	
	-- Borde
	local stroke = UIComponents.CreateStroke(slot, Color3.fromRGB(60, 60, 70), 1)
	
	-- Icono del item
	local icon = Instance.new("ImageLabel")
	icon.Name = "Icon"
	icon.Size = UDim2.new(1, -8, 1, -8)
	icon.Position = UDim2.new(0, 4, 0, 4)
	icon.BackgroundTransparency = 1
	icon.Image = ""
	icon.ScaleType = Enum.ScaleType.Fit
	icon.Parent = slot
	
	-- Cantidad
	local quantity = Instance.new("TextLabel")
	quantity.Name = "Quantity"
	quantity.Size = UDim2.new(0, 25, 0, 18)
	quantity.Position = UDim2.new(1, -28, 1, -20)
	quantity.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	quantity.BackgroundTransparency = 0.3
	quantity.BorderSizePixel = 0
	quantity.Text = ""
	quantity.TextColor3 = UIComponents.Colors.Text
	quantity.TextSize = 14
	quantity.Font = Enum.Font.GothamBold
	quantity.Parent = slot
	
	UIComponents.CreateCorner(quantity, 4)
	
	-- Almacenar datos del slot
	slot:SetAttribute("SlotIndex", slotIndex)
	slot:SetAttribute("ItemId", "")
	slot:SetAttribute("Quantity", 0)
	
	return slot
end

-- Crear botón moderno
function UIComponents.CreateButton(parent, text, size, position)
	local button = Instance.new("TextButton")
	button.Size = size or UDim2.new(0, 150, 0, 40)
	button.Position = position or UDim2.new(0, 0, 0, 0)
	button.BackgroundColor3 = UIComponents.Colors.Primary
	button.BorderSizePixel = 0
	button.Text = text
	button.TextColor3 = UIComponents.Colors.Text
	button.TextSize = 16
	button.Font = Enum.Font.GothamBold
	button.AutoButtonColor = false
	button.Parent = parent
	
	UIComponents.CreateCorner(button, 8)
	
	-- Efectos hover
	button.MouseEnter:Connect(function()
		TweenService:Create(button, UIComponents.TweenInfo.Fast, {
			BackgroundColor3 = UIComponents.Colors.PrimaryHover
		}):Play()
	end)
	
	button.MouseLeave:Connect(function()
		TweenService:Create(button, UIComponents.TweenInfo.Fast, {
			BackgroundColor3 = UIComponents.Colors.Primary
		}):Play()
	end)
	
	return button
end

-- Crear pestaña
function UIComponents.CreateTab(parent, text, index, totalTabs)
	local tabWidth = 1 / totalTabs
	
	local tab = Instance.new("TextButton")
	tab.Name = "Tab" .. text
	tab.Size = UDim2.new(tabWidth, -4, 1, 0)
	tab.Position = UDim2.new(tabWidth * (index - 1), 2, 0, 0)
	tab.BackgroundColor3 = UIComponents.Colors.SlotEmpty
	tab.BorderSizePixel = 0
	tab.Text = text
	tab.TextColor3 = UIComponents.Colors.TextSecondary
	tab.TextSize = 16
	tab.Font = Enum.Font.GothamBold
	tab.AutoButtonColor = false
	tab.Parent = parent
	
	UIComponents.CreateCorner(tab, 8)
	
	-- Estado inicial
	tab:SetAttribute("Active", false)
	
	return tab
end

-- Actualizar estado de pestaña
function UIComponents.SetTabActive(tab, active)
	tab:SetAttribute("Active", active)
	
	if active then
		TweenService:Create(tab, UIComponents.TweenInfo.Fast, {
			BackgroundColor3 = UIComponents.Colors.Primary,
			TextColor3 = UIComponents.Colors.Text
		}):Play()
		
		-- Añadir borde de neón
		local stroke = tab:FindFirstChildOfClass("UIStroke")
		if not stroke then
			UIComponents.CreateStroke(tab, UIComponents.Colors.PrimaryHover, 2)
		end
	else
		TweenService:Create(tab, UIComponents.TweenInfo.Fast, {
			BackgroundColor3 = UIComponents.Colors.SlotEmpty,
			TextColor3 = UIComponents.Colors.TextSecondary
		}):Play()
		
		-- Remover borde
		local stroke = tab:FindFirstChildOfClass("UIStroke")
		if stroke then
			stroke:Destroy()
		end
	end
end

-- Crear campo de búsqueda
function UIComponents.CreateSearchBox(parent, size, position)
	local searchFrame = Instance.new("Frame")
	searchFrame.Size = size or UDim2.new(0, 300, 0, 40)
	searchFrame.Position = position or UDim2.new(0, 0, 0, 0)
	searchFrame.BackgroundColor3 = UIComponents.Colors.SlotEmpty
	searchFrame.BorderSizePixel = 0
	searchFrame.Parent = parent
	
	UIComponents.CreateCorner(searchFrame, 8)
	UIComponents.CreateStroke(searchFrame, Color3.fromRGB(60, 60, 70), 1)
	
	local searchBox = Instance.new("TextBox")
	searchBox.Name = "SearchBox"
	searchBox.Size = UDim2.new(1, -50, 1, 0)
	searchBox.Position = UDim2.new(0, 10, 0, 0)
	searchBox.BackgroundTransparency = 1
	searchBox.PlaceholderText = "Buscar items..."
	searchBox.PlaceholderColor3 = UIComponents.Colors.TextSecondary
	searchBox.Text = ""
	searchBox.TextColor3 = UIComponents.Colors.Text
	searchBox.TextSize = 14
	searchBox.Font = Enum.Font.Gotham
	searchBox.TextXAlignment = Enum.TextXAlignment.Left
	searchBox.ClearTextOnFocus = false
	searchBox.Parent = searchFrame
	
	-- Icono de búsqueda
	local icon = Instance.new("TextLabel")
	icon.Size = UDim2.new(0, 30, 0, 30)
	icon.Position = UDim2.new(1, -38, 0.5, -15)
	icon.BackgroundTransparency = 1
	icon.Text = "🔍"
	icon.TextColor3 = UIComponents.Colors.TextSecondary
	icon.TextSize = 18
	icon.Parent = searchFrame
	
	return searchBox
end

-- Crear tooltip
function UIComponents.CreateTooltip(parent, itemData)
	local tooltip = Instance.new("Frame")
	tooltip.Name = "Tooltip"
	tooltip.Size = UDim2.new(0, 250, 0, 0) -- La altura se ajustará dinámicamente
	tooltip.BackgroundColor3 = UIComponents.Colors.Background
	tooltip.BorderSizePixel = 0
	tooltip.Visible = false
	tooltip.ZIndex = 1000
	tooltip.Parent = parent
	
	UIComponents.CreateCorner(tooltip, 8)
	
	-- Borde según rareza
	local rarityColor = UIComponents.Colors.Rarity[itemData.rarity] or UIComponents.Colors.Rarity.Common
	UIComponents.CreateStroke(tooltip, rarityColor, 2)
	
	-- Contenedor para contenido
	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, -20, 1, -20)
	content.Position = UDim2.new(0, 10, 0, 10)
	content.BackgroundTransparency = 1
	content.Parent = tooltip
	
	local yOffset = 0
	
	-- Nombre del item
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 0, 25)
	nameLabel.Position = UDim2.new(0, 0, 0, yOffset)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = itemData.name
	nameLabel.TextColor3 = rarityColor
	nameLabel.TextSize = 18
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextYAlignment = Enum.TextYAlignment.Top
	nameLabel.Parent = content
	yOffset = yOffset + 30
	
	-- Rareza
	local rarityLabel = Instance.new("TextLabel")
	rarityLabel.Size = UDim2.new(1, 0, 0, 18)
	rarityLabel.Position = UDim2.new(0, 0, 0, yOffset)
	rarityLabel.BackgroundTransparency = 1
	rarityLabel.Text = itemData.rarity
	rarityLabel.TextColor3 = rarityColor
	rarityLabel.TextSize = 14
	rarityLabel.Font = Enum.Font.GothamMedium
	rarityLabel.TextXAlignment = Enum.TextXAlignment.Left
	rarityLabel.TextYAlignment = Enum.TextYAlignment.Top
	rarityLabel.Parent = content
	yOffset = yOffset + 25
	
	-- Descripción
	local descLabel = Instance.new("TextLabel")
	descLabel.Size = UDim2.new(1, 0, 0, 40)
	descLabel.Position = UDim2.new(0, 0, 0, yOffset)
	descLabel.BackgroundTransparency = 1
	descLabel.Text = itemData.description
	descLabel.TextColor3 = UIComponents.Colors.TextSecondary
	descLabel.TextSize = 13
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.TextYAlignment = Enum.TextYAlignment.Top
	descLabel.TextWrapped = true
	descLabel.Parent = content
	yOffset = yOffset + 45
	
	-- Stats adicionales
	if itemData.damage then
		local damageLabel = Instance.new("TextLabel")
		damageLabel.Size = UDim2.new(1, 0, 0, 18)
		damageLabel.Position = UDim2.new(0, 0, 0, yOffset)
		damageLabel.BackgroundTransparency = 1
		damageLabel.Text = "⚔️ Daño: " .. itemData.damage
		damageLabel.TextColor3 = UIComponents.Colors.Text
		damageLabel.TextSize = 13
		damageLabel.Font = Enum.Font.Gotham
		damageLabel.TextXAlignment = Enum.TextXAlignment.Left
		damageLabel.Parent = content
		yOffset = yOffset + 20
	end
	
	if itemData.healAmount then
		local healLabel = Instance.new("TextLabel")
		healLabel.Size = UDim2.new(1, 0, 0, 18)
		healLabel.Position = UDim2.new(0, 0, 0, yOffset)
		healLabel.BackgroundTransparency = 1
		healLabel.Text = "💚 Curación: +" .. itemData.healAmount .. " HP"
		healLabel.TextColor3 = UIComponents.Colors.Success
		healLabel.TextSize = 13
		healLabel.Font = Enum.Font.Gotham
		healLabel.TextXAlignment = Enum.TextXAlignment.Left
		healLabel.Parent = content
		yOffset = yOffset + 20
	end
	
	-- Ajustar altura total
	tooltip.Size = UDim2.new(0, 250, 0, yOffset + 20)
	
	return tooltip
end

-- ============================================================================
-- UTILIDADES
-- ============================================================================

-- Obtener color de rareza
function UIComponents.GetRarityColor(rarity)
	return UIComponents.Colors.Rarity[rarity] or UIComponents.Colors.Rarity.Common
end

-- Formatear número con separador de miles
function UIComponents.FormatNumber(number)
	local formatted = tostring(number)
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if k == 0 then break end
	end
	return formatted
end

-- Crear notificación
function UIComponents.ShowNotification(parent, message, notifType, duration)
	notifType = notifType or "info"
	duration = duration or 3
	
	local notification = Instance.new("Frame")
	notification.Size = UDim2.new(0, 300, 0, 60)
	notification.Position = UDim2.new(0.5, -150, 0, -70)
	notification.BackgroundColor3 = UIComponents.Colors.Background
	notification.BorderSizePixel = 0
	notification.ZIndex = 2000
	notification.Parent = parent
	
	UIComponents.CreateCorner(notification, 8)
	
	local color = UIComponents.Colors.Primary
	if notifType == "success" then
		color = UIComponents.Colors.Success
	elseif notifType == "error" then
		color = UIComponents.Colors.Error
	elseif notifType == "warning" then
		color = UIComponents.Colors.Warning
	end
	
	UIComponents.CreateStroke(notification, color, 2)
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 1, -20)
	label.Position = UDim2.new(0, 10, 0, 10)
	label.BackgroundTransparency = 1
	label.Text = message
	label.TextColor3 = UIComponents.Colors.Text
	label.TextSize = 14
	label.Font = Enum.Font.GothamMedium
	label.TextWrapped = true
	label.Parent = notification
	
	-- Animar entrada
	TweenService:Create(notification, UIComponents.TweenInfo.Bounce, {
		Position = UDim2.new(0.5, -150, 0, 20)
	}):Play()
	
	-- Auto-destruir después de duración
	task.delay(duration, function()
		local fadeOut = TweenService:Create(notification, UIComponents.TweenInfo.Fast, {
			Position = UDim2.new(0.5, -150, 0, -70),
			BackgroundTransparency = 1
		})
		fadeOut.Completed:Connect(function()
			notification:Destroy()
		end)
		fadeOut:Play()
	end)
	
	return notification
end

return UIComponents


