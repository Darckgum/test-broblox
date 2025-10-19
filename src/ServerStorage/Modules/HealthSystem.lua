-- Sistema de salud para el RPG
local HealthSystem = {}

function HealthSystem.createHealthBar(player, maxHealth)
    print("🏥 Creando barra de vida para:", player.Name, "con vida máxima:", maxHealth)
    
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then 
        print("❌ No se encontró leaderstats para", player.Name)
        return 
    end
    
    local health = leaderstats:FindFirstChild("Health")
    if not health then 
        print("❌ No se encontró Health en leaderstats para", player.Name)
        return 
    end
    
    -- Obtener el personaje del jugador
    local character = player.Character
    if not character then 
        print("❌ No se encontró Character para", player.Name)
        return 
    end
    
    local head = character:FindFirstChild("Head")
    if not head then 
        print("❌ No se encontró Head para", player.Name)
        return 
    end
    
    print("✅ Todos los componentes encontrados para", player.Name)
    
    -- Crear BillboardGui que se adjunte a la cabeza
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "HealthBar"
    billboardGui.Size = UDim2.new(0, 100, 0, 20)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0) -- 2 studs arriba de la cabeza
    billboardGui.Parent = head
    
    -- Frame principal (fondo negro)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.new(1, 1, 1)
    frame.Parent = billboardGui
    
    -- Barra de vida
    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.new(0, 1, 0) -- Verde por defecto
    healthBar.Parent = frame
    
    -- Texto de vida
    local healthText = Instance.new("TextLabel")
    healthText.Size = UDim2.new(1, 0, 1, 0)
    healthText.BackgroundTransparency = 1
    healthText.Text = "HP: " .. health.Value .. "/" .. maxHealth
    healthText.TextColor3 = Color3.new(1, 1, 1)
    healthText.TextScaled = true
    healthText.Font = Enum.Font.SourceSansBold
    healthText.Parent = frame
    
    -- Función para actualizar la barra
    local function updateHealthBar()
        local currentHealth = health.Value
        local healthPercentage = currentHealth / maxHealth
        
        -- Actualizar tamaño de la barra
        healthBar.Size = UDim2.new(healthPercentage, 0, 1, 0)
        healthText.Text = "HP: " .. currentHealth .. "/" .. maxHealth
        
        -- Cambiar color según el porcentaje de vida
        if healthPercentage > 0.66 then
            healthBar.BackgroundColor3 = Color3.new(0, 1, 0) -- Verde
        elseif healthPercentage > 0.33 then
            healthBar.BackgroundColor3 = Color3.new(1, 1, 0) -- Amarillo
        else
            healthBar.BackgroundColor3 = Color3.new(1, 0, 0) -- Rojo
        end
    end
    
    -- Actualizar barra cuando cambie la salud (leaderstats)
    health.Changed:Connect(updateHealthBar)
    
    -- Sincronizar Humanoid.Health con leaderstats.Health
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.HealthChanged:Connect(function(newHealth)
            -- Actualizar leaderstats cuando cambie el Humanoid
            local currentLeaderstatsHealth = health.Value
            if math.abs(currentLeaderstatsHealth - newHealth) > 0.1 then
                health.Value = math.floor(newHealth)
                print("🔄 Sincronización: Humanoid.Health =", newHealth, "→ leaderstats.Health =", health.Value)
            end
        end)
        
        -- Cuando el personaje muere
        humanoid.Died:Connect(function()
            health.Value = 0
            print("💀", player.Name, "ha muerto")
        end)
    end
    
    -- Actualizar inicialmente
    updateHealthBar()
    
    print("💚 Barra de vida creada sobre", player.Name, "con vida máxima:", maxHealth)
end

return HealthSystem