-- Servidor principal del RPG
print("🎮 Servidor RPG iniciado correctamente!")
print("✅ Sincronización con Rojo funcionando!")
print("🔄 PRUEBA DE SINCRONIZACIÓN: " .. os.date("%H:%M:%S"))

-- Servicios
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- Cargar módulos principales (siempre necesarios)
local HealthSystem = require(ServerStorage.Modules.HealthSystem)
local NoobMovement = require(ServerStorage.Modules.NoobMovement)

-- Cargar módulos del inventario con manejo de errores
local InventorySystem = nil
local InventoryRemotes = nil
local inventoryEnabled = false

local success, err = pcall(function()
    InventorySystem = require(ServerStorage.Modules.InventorySystem)
    InventoryRemotes = require(ServerStorage.Modules.InventoryRemotes)
    inventoryEnabled = true
    print("✅ Módulos de inventario cargados correctamente")
end)

if not success then
    warn("⚠️ Error al cargar inventario:", err)
    warn("⚠️ El juego continuará sin inventario")
end

-- Función para inicializar jugador
local function onPlayerAdded(player)
    print("👤 Jugador conectado:", player.Name)
    
    -- Crear stats básicos
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local level = Instance.new("IntValue")
    level.Name = "Level"
    level.Value = 1
    level.Parent = leaderstats
    
    -- Calcular vida basada en nivel (nivel * 50)
    local maxHealth = level.Value * 50
    local health = Instance.new("IntValue")
    health.Name = "Health"
    health.Value = maxHealth
    health.Parent = leaderstats
    
    print("💚 Vida inicial calculada:", maxHealth, "para nivel", level.Value)
    
    -- Crear inventario del jugador (solo si está disponible)
    if inventoryEnabled and InventorySystem then
        local invSuccess, invErr = pcall(function()
            InventorySystem.createInventory(player)
            
            -- Dar item inicial: Rama
            wait(0.5) -- Pequeño delay para asegurar que el inventario esté creado
            InventorySystem.addItem(player, "branch", 1)
            print("🎁 Item inicial dado: Rama")
            
            -- Dar algunas pociones de inicio
            InventorySystem.addItem(player, "small_health_potion", 3)
            print("🎁 Items adicionales: 3x Poción Pequeña de Vida")
        end)
        
        if not invSuccess then
            warn("⚠️ Error al crear inventario para", player.Name, ":", invErr)
        end
    end
    
    -- Crear barra de salud
    player.CharacterAdded:Connect(function(character)
        wait(1) -- Esperar a que se cargue completamente
        
        -- Actualizar vida del Humanoid basada en el nivel
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.MaxHealth = maxHealth
        humanoid.Health = maxHealth
        
        -- Crear barra de salud con vida máxima correcta
        HealthSystem.createHealthBar(player, maxHealth)
    end)
end

-- Función para encontrar y hacer mover al noob existente
local function findAndMoveExistingNoob()
    print("🔍 Buscando noob existente en el workspace...")
    
    -- Buscar el noob existente (puede tener diferentes nombres)
    local possibleNames = {"Noob", "noob", "NPC", "npc", "Character", "Player"}
    local foundNoob = nil
    
    for _, name in ipairs(possibleNames) do
        foundNoob = workspace:FindFirstChild(name)
        if foundNoob and foundNoob:FindFirstChild("Humanoid") then
            print("✅ Noob encontrado:", foundNoob.Name)
            break
        end
    end
    
    -- Si no se encuentra con nombres comunes, buscar cualquier modelo con Humanoid
    if not foundNoob then
        print("🔍 Buscando cualquier modelo con Humanoid...")
        for _, child in pairs(workspace:GetChildren()) do
            if child:IsA("Model") and child:FindFirstChild("Humanoid") and child.Name ~= "Terrain" then
                foundNoob = child
                print("✅ Modelo con Humanoid encontrado:", foundNoob.Name)
                break
            end
        end
    end
    
    if foundNoob then
        print("🔍 Analizando noob encontrado:", foundNoob.Name)
        print("🔍 Partes del noob:")
        for _, child in pairs(foundNoob:GetChildren()) do
            print("  -", child.Name, "(" .. child.ClassName .. ")")
        end
        
        -- Buscar HumanoidRootPart o crear uno si no existe
        local rootPart = foundNoob:FindFirstChild("HumanoidRootPart")
        if not rootPart then
            print("⚠️ No se encontró HumanoidRootPart, buscando Torso...")
            local torso = foundNoob:FindFirstChild("Torso")
            if torso then
                print("✅ Encontrado Torso, creando HumanoidRootPart...")
                -- Crear HumanoidRootPart basado en el Torso
                rootPart = Instance.new("Part")
                rootPart.Name = "HumanoidRootPart"
                rootPart.Size = torso.Size
                rootPart.CFrame = torso.CFrame
                rootPart.Material = torso.Material
                rootPart.BrickColor = torso.BrickColor
                rootPart.CanCollide = true -- IMPORTANTE: Debe ser true para detectar colisiones
                rootPart.Anchored = false
                rootPart.Transparency = 1 -- Hacerlo invisible
                rootPart.Parent = foundNoob
                
                -- Conectar Torso al HumanoidRootPart
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = rootPart
                weld.Part1 = torso
                weld.Parent = rootPart
                
                print("✅ HumanoidRootPart creado y conectado al Torso")
            else
                print("❌ No se encontró ni HumanoidRootPart ni Torso")
                return
            end
        end
        
        if rootPart then
            local spawnPosition = rootPart.Position
            print("📍 Posición inicial del noob:", spawnPosition)
            print("📍 CanCollide del noob:", rootPart.CanCollide)
            
            -- Asegurar que CanCollide esté activado para detectar colisiones
            if not rootPart.CanCollide then
                rootPart.CanCollide = true
                print("✅ CanCollide activado en HumanoidRootPart")
            end
            
            -- Iniciar movimiento aleatorio con animaciones
            NoobMovement.startRandomMovement(foundNoob)
            print("🤖 ¡Noob existente ahora se mueve aleatoriamente!")
            
            -- Configurar sistema de daño
            NoobMovement.setupDamageOnTouch(foundNoob)
            print("⚔️ ¡Noob ahora hace daño al tocarlo!")
        else
            print("❌ No se pudo crear o encontrar HumanoidRootPart")
        end
    else
        print("❌ No se encontró ningún noob en el workspace")
        print("💡 Asegúrate de que el noob esté en el workspace y tenga un Humanoid")
    end
end

-- Inicializar RemoteEvents del inventario (solo si está disponible)
if inventoryEnabled and InventoryRemotes then
    local remoteSuccess, remoteErr = pcall(function()
        InventoryRemotes.init()
        print("✅ RemoteEvents del inventario inicializados")
    end)
    
    if not remoteSuccess then
        warn("⚠️ Error al inicializar RemoteEvents del inventario:", remoteErr)
        inventoryEnabled = false
    end
end

-- Conectar eventos
Players.PlayerAdded:Connect(onPlayerAdded)

-- Buscar y hacer mover al noob existente después de un breve delay
wait(2)
findAndMoveExistingNoob()

print("🚀 Sistema RPG listo para jugadores!")
print("🤖 Buscando noob existente para movimiento aleatorio...")

if inventoryEnabled then
    print("📦 Sistema de inventario activo - Presiona 'I' o 'E' para abrir")
else
    print("⚠️ Sistema de inventario desactivado")
end

print("")
print("═══════════════════════════════════════")
print("✅ Sistemas activos:")
print("  💚 Sistema de vida y barra de HP")
print("  ⚔️  Sistema de daño del noob")
if inventoryEnabled then
    print("  📦 Sistema de inventario")
end
print("═══════════════════════════════════════")