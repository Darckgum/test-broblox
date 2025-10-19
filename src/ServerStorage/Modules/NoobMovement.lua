-- Sistema de movimiento aleatorio para NPCs
local NoobMovement = {}

-- Configuración del movimiento
local MOVEMENT_SPEED = 16 -- Velocidad de caminata
local MOVEMENT_RANGE = 50 -- Rango máximo de movimiento desde spawn
local WAIT_TIME_MIN = 2 -- Tiempo mínimo de espera (segundos)
local WAIT_TIME_MAX = 5 -- Tiempo máximo de espera (segundos)

function NoobMovement.startRandomMovement(npc)
    if not npc or not npc:FindFirstChild("Humanoid") then
        warn("NoobMovement: NPC no válido o sin Humanoid")
        return
    end
    
    local humanoid = npc.Humanoid
    local rootPart = npc:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then
        warn("NoobMovement: NPC sin HumanoidRootPart")
        return
    end
    
    -- Configurar animaciones
    local animator = humanoid:FindFirstChild("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end
    
    -- Cargar animación de caminata
    local walkAnimation = Instance.new("Animation")
    walkAnimation.AnimationId = "rbxassetid://913402848" -- Animación de caminata de Roblox
    local walkTrack = animator:LoadAnimation(walkAnimation)
    
    print("🤖 Iniciando movimiento aleatorio para:", npc.Name)
    
    -- Guardar posición inicial
    local spawnPosition = rootPart.Position
    local currentTarget = spawnPosition
    
    -- Función para generar nueva posición aleatoria
    local function getRandomPosition()
        local angle = math.random() * 2 * math.pi
        local distance = math.random() * MOVEMENT_RANGE
        
        local newX = spawnPosition.X + math.cos(angle) * distance
        local newZ = spawnPosition.Z + math.sin(angle) * distance
        
        return Vector3.new(newX, spawnPosition.Y, newZ)
    end
    
    -- Función para mover al NPC
    local function moveToRandomPosition()
        currentTarget = getRandomPosition()
        humanoid:MoveTo(currentTarget)
        
        -- Iniciar animación de caminata
        if walkTrack then
            walkTrack:Play()
        end
        
        print("🎯", npc.Name, "se mueve hacia:", math.floor(currentTarget.X), math.floor(currentTarget.Z))
    end
    
    -- Función principal del loop de movimiento
    local function movementLoop()
        while npc.Parent do
            -- Mover a nueva posición
            moveToRandomPosition()
            
            -- Esperar hasta que llegue o se agote el tiempo
            local startTime = tick()
            local maxWaitTime = 10 -- Máximo 10 segundos esperando
            
            repeat
                wait(0.1)
                local distance = (rootPart.Position - currentTarget).Magnitude
                
                -- Si está cerca del objetivo o ha esperado mucho tiempo
                if distance < 3 or (tick() - startTime) > maxWaitTime then
                    break
                end
            until not npc.Parent
            
            if not npc.Parent then break end
            
            -- Detener animación de caminata
            if walkTrack then
                walkTrack:Stop()
            end
            
            -- Esperar un tiempo aleatorio antes del siguiente movimiento
            local waitTime = math.random(WAIT_TIME_MIN * 10, WAIT_TIME_MAX * 10) / 10
            print("⏰", npc.Name, "espera", waitTime, "segundos...")
            wait(waitTime)
        end
    end
    
    -- Iniciar el loop de movimiento
    spawn(movementLoop)
end

-- Función para crear un noob con movimiento automático
function NoobMovement.createMovingNoob(spawnPosition)
    -- Crear el modelo del noob
    local noob = Instance.new("Model")
    noob.Name = "MovingNoob"
    
    -- Crear la parte del cuerpo
    local torso = Instance.new("Part")
    torso.Name = "Torso"
    torso.Size = Vector3.new(2, 2, 1)
    torso.Material = Enum.Material.Neon
    torso.BrickColor = BrickColor.new("Bright blue")
    torso.CanCollide = false
    torso.Parent = noob
    
    -- Crear HumanoidRootPart
    local rootPart = Instance.new("Part")
    rootPart.Name = "HumanoidRootPart"
    rootPart.Size = Vector3.new(2, 2, 1)
    rootPart.Material = Enum.Material.Neon
    rootPart.BrickColor = BrickColor.new("Bright red")
    rootPart.CanCollide = false
    rootPart.Anchored = false
    rootPart.Parent = noob
    
    -- Crear Humanoid
    local humanoid = Instance.new("Humanoid")
    humanoid.MaxHealth = 100
    humanoid.Health = 100
    humanoid.WalkSpeed = MOVEMENT_SPEED
    humanoid.Parent = noob
    
    -- Crear Animator para animaciones
    local animator = Instance.new("Animator")
    animator.Parent = humanoid
    
    -- Crear cabeza
    local head = Instance.new("Part")
    head.Name = "Head"
    head.Size = Vector3.new(2, 1, 1)
    head.Material = Enum.Material.Neon
    head.BrickColor = BrickColor.new("Bright yellow")
    head.CanCollide = false
    head.Parent = noob
    
    -- Posicionar el noob
    rootPart.CFrame = CFrame.new(spawnPosition)
    noob.Parent = workspace
    
    -- Iniciar movimiento aleatorio
    NoobMovement.startRandomMovement(noob)
    
    print("✅ Noob creado y moviéndose en:", spawnPosition)
    return noob
end

-- Sistema de daño del noob
local damageCooldowns = {} -- Tabla para rastrear cooldowns por jugador

function NoobMovement.setupDamageOnTouch(npc)
    if not npc or not npc:FindFirstChild("HumanoidRootPart") then
        warn("NoobMovement: NPC no válido para daño")
        return
    end
    
    local rootPart = npc.HumanoidRootPart
    local damageAmount = 10 -- Daño por toque
    local cooldownTime = 3 -- Cooldown en segundos
    
    print("⚔️ Configurando daño del noob:", npc.Name)
    
    rootPart.Touched:Connect(function(hit)
        print("🔍 Algo tocó al noob:", hit.Name, "de", hit.Parent.Name)
        
        local character = hit.Parent
        local humanoid = character:FindFirstChild("Humanoid")
        
        -- Verificar si es un jugador
        if not humanoid then 
            print("❌ No es un personaje con Humanoid")
            return 
        end
        
        local player = game.Players:GetPlayerFromCharacter(character)
        if not player then 
            print("❌ No es un jugador")
            return 
        end
        
        print("✅ Jugador detectado:", player.Name)
        
        -- Verificar cooldown
        local currentTime = tick()
        if damageCooldowns[player.UserId] and (currentTime - damageCooldowns[player.UserId]) < cooldownTime then
            return -- Aún en cooldown
        end
        
        -- Aplicar cooldown
        damageCooldowns[player.UserId] = currentTime
        
        -- Obtener stats del jugador
        local leaderstats = player:FindFirstChild("leaderstats")
        if not leaderstats then return end
        
        local health = leaderstats:FindFirstChild("Health")
        if not health then return end
        
        -- Aplicar daño
        local newHealth = math.max(0, health.Value - damageAmount)
        health.Value = newHealth
        humanoid.Health = newHealth
        
        print("💥", npc.Name, "hizo", damageAmount, "de daño a", player.Name, "- Vida restante:", newHealth)
        
        -- Efecto visual (opcional)
        local damageGui = Instance.new("BillboardGui")
        damageGui.Size = UDim2.new(0, 50, 0, 20)
        damageGui.StudsOffset = Vector3.new(0, 3, 0)
        damageGui.Parent = character:FindFirstChild("Head")
        
        local damageText = Instance.new("TextLabel")
        damageText.Size = UDim2.new(1, 0, 1, 0)
        damageText.BackgroundTransparency = 1
        damageText.Text = "-" .. damageAmount
        damageText.TextColor3 = Color3.new(1, 0, 0)
        damageText.TextScaled = true
        damageText.Font = Enum.Font.SourceSansBold
        damageText.Parent = damageGui
        
        -- Remover efecto después de 1 segundo
        game:GetService("Debris"):AddItem(damageGui, 1)
    end)
end

return NoobMovement

