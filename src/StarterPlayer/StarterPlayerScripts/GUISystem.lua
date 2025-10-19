-- Sistema de Interfaz de Usuario para RPG
-- Módulo compartido para manejo de GUI

local GUISystem = {}

-- Configuración de GUI
GUISystem.CONFIG = {
    MainFrameSize = UDim2.new(0, 400, 0, 500),
    InventoryFrameSize = UDim2.new(0, 600, 0, 400),
    SkillFrameSize = UDim2.new(0, 500, 0, 300),
    AnimationDuration = 0.3
}

-- Colores del tema
GUISystem.COLORS = {
    Background = Color3.fromRGB(40, 40, 40),
    Secondary = Color3.fromRGB(60, 60, 60),
    Accent = Color3.fromRGB(80, 80, 80),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    Success = Color3.fromRGB(100, 255, 100),
    Warning = Color3.fromRGB(255, 255, 100),
    Error = Color3.fromRGB(255, 100, 100),
    Info = Color3.fromRGB(100, 200, 255)
}

-- Función para crear un frame con esquinas redondeadas
function GUISystem.CreateRoundedFrame(size, position, backgroundColor, parent)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = backgroundColor or GUISystem.COLORS.Background
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    return frame
end

-- Función para crear un botón con estilo
function GUISystem.CreateStyledButton(size, position, text, parent)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = GUISystem.COLORS.Secondary
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = GUISystem.COLORS.Text
    button.TextScaled = true
    button.Font = Enum.Font.SourceSans
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = button
    
    -- Efecto hover
    button.MouseEnter:Connect(function()
        local tween = game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = GUISystem.COLORS.Accent
        })
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = GUISystem.COLORS.Secondary
        })
        tween:Play()
    end)
    
    return button
end

-- Función para crear un label con estilo
function GUISystem.CreateStyledLabel(size, position, text, parent, textColor)
    local label = Instance.new("TextLabel")
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = textColor or GUISystem.COLORS.Text
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.Parent = parent
    
    return label
end

-- Función para crear un slot de inventario
function GUISystem.CreateInventorySlot(size, position, parent, slotIndex)
    local slotFrame = GUISystem.CreateRoundedFrame(size, position, GUISystem.COLORS.Secondary, parent)
    slotFrame.Name = "Slot" .. slotIndex
    
    local itemImage = Instance.new("ImageLabel")
    itemImage.Name = "ItemImage"
    itemImage.Size = UDim2.new(1, -10, 1, -20)
    itemImage.Position = UDim2.new(0, 5, 0, 5)
    itemImage.BackgroundTransparency = 1
    itemImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    itemImage.Parent = slotFrame
    
    local quantityLabel = GUISystem.CreateStyledLabel(
        UDim2.new(0, 20, 0, 15),
        UDim2.new(1, -25, 1, -20),
        "",
        slotFrame,
        GUISystem.COLORS.Text
    )
    quantityLabel.Name = "QuantityLabel"
    quantityLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    quantityLabel.BackgroundTransparency = 0.5
    quantityLabel.Font = Enum.Font.SourceSansBold
    
    local quantityCorner = Instance.new("UICorner")
    quantityCorner.CornerRadius = UDim.new(0, 3)
    quantityCorner.Parent = quantityLabel
    
    return slotFrame
end

-- Función para crear un botón de habilidad
function GUISystem.CreateSkillButton(size, position, skillData, parent)
    local skillFrame = GUISystem.CreateRoundedFrame(size, position, GUISystem.COLORS.Secondary, parent)
    skillFrame.Name = skillData.Name .. "Frame"
    
    local skillImage = Instance.new("ImageLabel")
    skillImage.Name = "SkillImage"
    skillImage.Size = UDim2.new(0, 50, 0, 50)
    skillImage.Position = UDim2.new(0, 5, 0, 5)
    skillImage.BackgroundTransparency = 1
    skillImage.Image = skillData.Icon or "rbxasset://textures/ui/GuiImagePlaceholder.png"
    skillImage.Parent = skillFrame
    
    local skillNameLabel = GUISystem.CreateStyledLabel(
        UDim2.new(0.6, 0, 0, 20),
        UDim2.new(0, 60, 0, 5),
        skillData.Name,
        skillFrame,
        GUISystem.COLORS.Text
    )
    skillNameLabel.Font = Enum.Font.SourceSansBold
    skillNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local skillDescLabel = GUISystem.CreateStyledLabel(
        UDim2.new(0.6, 0, 0, 35),
        UDim2.new(0, 60, 0, 25),
        skillData.Description or "",
        skillFrame,
        GUISystem.COLORS.TextSecondary
    )
    skillDescLabel.TextXAlignment = Enum.TextXAlignment.Left
    skillDescLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    local cooldownLabel = GUISystem.CreateStyledLabel(
        UDim2.new(0, 80, 0, 20),
        UDim2.new(1, -85, 0, 5),
        "Listo",
        skillFrame,
        GUISystem.COLORS.Success
    )
    cooldownLabel.Name = "CooldownLabel"
    cooldownLabel.Font = Enum.Font.SourceSansBold
    
    local manaLabel = GUISystem.CreateStyledLabel(
        UDim2.new(0, 80, 0, 20),
        UDim2.new(1, -85, 0, 25),
        "Mana: " .. (skillData.ManaCost or 0),
        skillFrame,
        GUISystem.COLORS.Info
    )
    manaLabel.Name = "ManaLabel"
    
    return skillFrame
end

-- Función para crear un frame de quest
function GUISystem.CreateQuestFrame(size, position, questData, parent)
    local questFrame = GUISystem.CreateRoundedFrame(size, position, GUISystem.COLORS.Secondary, parent)
    questFrame.Name = questData.Name .. "Frame"
    
    local questNameLabel = GUISystem.CreateStyledLabel(
        UDim2.new(1, -10, 0, 25),
        UDim2.new(0, 5, 0, 5),
        questData.Name,
        questFrame,
        GUISystem.COLORS.Text
    )
    questNameLabel.Font = Enum.Font.SourceSansBold
    questNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local questDescLabel = GUISystem.CreateStyledLabel(
        UDim2.new(1, -10, 0, 20),
        UDim2.new(0, 5, 0, 30),
        questData.Description or "",
        questFrame,
        GUISystem.COLORS.TextSecondary
    )
    questDescLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local questProgressLabel = GUISystem.CreateStyledLabel(
        UDim2.new(1, -10, 0, 20),
        UDim2.new(0, 5, 0, 50),
        "Progreso: " .. (questData.Progress or "0/0"),
        questFrame,
        GUISystem.COLORS.Success
    )
    questProgressLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    return questFrame
end

-- Función para crear una barra de progreso
function GUISystem.CreateProgressBar(size, position, parent, backgroundColor, fillColor)
    local progressFrame = GUISystem.CreateRoundedFrame(size, position, backgroundColor or GUISystem.COLORS.Secondary, parent)
    
    local progressFill = Instance.new("Frame")
    progressFill.Name = "ProgressFill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.Position = UDim2.new(0, 0, 0, 0)
    progressFill.BackgroundColor3 = fillColor or GUISystem.COLORS.Success
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressFrame
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 10)
    fillCorner.Parent = progressFill
    
    return progressFrame, progressFill
end

-- Función para crear una notificación
function GUISystem.CreateNotification(text, notificationType, duration)
    duration = duration or 3
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NotificationGui"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local notificationFrame = GUISystem.CreateRoundedFrame(
        UDim2.new(0, 300, 0, 50),
        UDim2.new(1, -320, 0, 20),
        GUISystem.COLORS.Background,
        screenGui
    )
    
    local notificationLabel = GUISystem.CreateStyledLabel(
        UDim2.new(1, -10, 1, 0),
        UDim2.new(0, 5, 0, 0),
        text,
        notificationFrame,
        GUISystem.COLORS.Text
    )
    
    -- Color según el tipo de notificación
    if notificationType == "success" then
        notificationFrame.BackgroundColor3 = GUISystem.COLORS.Success
    elseif notificationType == "warning" then
        notificationFrame.BackgroundColor3 = GUISystem.COLORS.Warning
    elseif notificationType == "error" then
        notificationFrame.BackgroundColor3 = GUISystem.COLORS.Error
    elseif notificationType == "info" then
        notificationFrame.BackgroundColor3 = GUISystem.COLORS.Info
    end
    
    -- Animar entrada
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local enterTween = game:GetService("TweenService"):Create(notificationFrame, tweenInfo, {
        Position = UDim2.new(1, -320, 0, 20)
    })
    enterTween:Play()
    
    -- Auto-destruir después del tiempo especificado
    spawn(function()
        wait(duration)
        
        local exitTween = game:GetService("TweenService"):Create(notificationFrame, tweenInfo, {
            Position = UDim2.new(1, 0, 0, 20)
        })
        exitTween:Play()
        
        exitTween.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end)
end

-- Función para crear un tooltip
function GUISystem.CreateTooltip(text, parent)
    local tooltip = GUISystem.CreateRoundedFrame(
        UDim2.new(0, 200, 0, 30),
        UDim2.new(0, 0, 0, 0),
        GUISystem.COLORS.Background,
        parent
    )
    tooltip.Name = "Tooltip"
    tooltip.Visible = false
    tooltip.ZIndex = 10
    
    local tooltipLabel = GUISystem.CreateStyledLabel(
        UDim2.new(1, -10, 1, 0),
        UDim2.new(0, 5, 0, 0),
        text,
        tooltip,
        GUISystem.COLORS.Text
    )
    
    return tooltip
end

-- Función para mostrar tooltip
function GUISystem.ShowTooltip(tooltip, position)
    if tooltip then
        tooltip.Position = position
        tooltip.Visible = true
    end
end

-- Función para ocultar tooltip
function GUISystem.HideTooltip(tooltip)
    if tooltip then
        tooltip.Visible = false
    end
end

-- Función para crear un modal de confirmación
function GUISystem.CreateConfirmationModal(title, message, onConfirm, onCancel)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ConfirmationModal"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Overlay
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Position = UDim2.new(0, 0, 0, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.BorderSizePixel = 0
    overlay.Parent = screenGui
    
    -- Modal frame
    local modalFrame = GUISystem.CreateRoundedFrame(
        UDim2.new(0, 400, 0, 200),
        UDim2.new(0.5, -200, 0.5, -100),
        GUISystem.COLORS.Background,
        screenGui
    )
    
    -- Título
    local titleLabel = GUISystem.CreateStyledLabel(
        UDim2.new(1, -20, 0, 40),
        UDim2.new(0, 10, 0, 10),
        title,
        modalFrame,
        GUISystem.COLORS.Text
    )
    titleLabel.Font = Enum.Font.SourceSansBold
    
    -- Mensaje
    local messageLabel = GUISystem.CreateStyledLabel(
        UDim2.new(1, -20, 0, 80),
        UDim2.new(0, 10, 0, 60),
        message,
        modalFrame,
        GUISystem.COLORS.TextSecondary
    )
    messageLabel.TextWrapped = true
    
    -- Botones
    local confirmButton = GUISystem.CreateStyledButton(
        UDim2.new(0, 100, 0, 30),
        UDim2.new(0.5, -110, 1, -50),
        "Confirmar",
        modalFrame
    )
    
    local cancelButton = GUISystem.CreateStyledButton(
        UDim2.new(0, 100, 0, 30),
        UDim2.new(0.5, 10, 1, -50),
        "Cancelar",
        modalFrame
    )
    
    -- Eventos
    confirmButton.MouseButton1Click:Connect(function()
        if onConfirm then onConfirm() end
        screenGui:Destroy()
    end)
    
    cancelButton.MouseButton1Click:Connect(function()
        if onCancel then onCancel() end
        screenGui:Destroy()
    end)
    
    overlay.MouseButton1Click:Connect(function()
        if onCancel then onCancel() end
        screenGui:Destroy()
    end)
    
    return screenGui
end

-- Función para crear un input de texto
function GUISystem.CreateTextInput(size, position, placeholder, parent)
    local inputFrame = GUISystem.CreateRoundedFrame(size, position, GUISystem.COLORS.Secondary, parent)
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -10, 1, -10)
    textBox.Position = UDim2.new(0, 5, 0, 5)
    textBox.BackgroundTransparency = 1
    textBox.Text = ""
    textBox.PlaceholderText = placeholder or ""
    textBox.TextColor3 = GUISystem.COLORS.Text
    textBox.PlaceholderColor3 = GUISystem.COLORS.TextSecondary
    textBox.TextScaled = true
    textBox.Font = Enum.Font.SourceSans
    textBox.Parent = inputFrame
    
    return inputFrame, textBox
end

-- Función para crear un dropdown
function GUISystem.CreateDropdown(size, position, options, parent)
    local dropdownFrame = GUISystem.CreateRoundedFrame(size, position, GUISystem.COLORS.Secondary, parent)
    dropdownFrame.Name = "Dropdown"
    
    local dropdownButton = GUISystem.CreateStyledButton(
        UDim2.new(1, -30, 1, 0),
        UDim2.new(0, 0, 0, 0),
        options[1] or "Seleccionar",
        dropdownFrame
    )
    dropdownButton.Name = "DropdownButton"
    
    local dropdownArrow = GUISystem.CreateStyledLabel(
        UDim2.new(0, 20, 1, 0),
        UDim2.new(1, -25, 0, 0),
        "▼",
        dropdownFrame,
        GUISystem.COLORS.Text
    )
    
    local dropdownList = GUISystem.CreateRoundedFrame(
        UDim2.new(1, 0, 0, #options * 30),
        UDim2.new(0, 0, 1, 5),
        GUISystem.COLORS.Background,
        dropdownFrame
    )
    dropdownList.Name = "DropdownList"
    dropdownList.Visible = false
    
    -- Crear opciones
    for i, option in ipairs(options) do
        local optionButton = GUISystem.CreateStyledButton(
            UDim2.new(1, -10, 0, 25),
            UDim2.new(0, 5, 0, (i-1) * 30 + 5),
            option,
            dropdownList
        )
        
        optionButton.MouseButton1Click:Connect(function()
            dropdownButton.Text = option
            dropdownList.Visible = false
        end)
    end
    
    -- Toggle dropdown
    dropdownButton.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
    end)
    
    return dropdownFrame, dropdownButton
end

return GUISystem
