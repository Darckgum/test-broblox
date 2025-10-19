-- Script para hacer que un noob se mueva aleatoriamente
-- Este script debe ir dentro del noob existente

local noob = script.Parent -- El noob es el padre de este script
local humanoid = noob:FindFirstChild("Humanoid")
local rootPart = noob:FindFirstChild("HumanoidRootPart") or noob:FindFirstChild("Torso")

-- Verificar que el noob tenga los componentes necesarios
if not humanoid then
    warn("❌ No se encontró Humanoid en el noob")
    return
end

if not rootPart then
    warn("❌ No se encontró HumanoidRootPart o Torso en el noob")
    return
end

-- Configuración del movimiento
local MOVEMENT_SPEED = 16 -- Velocidad de caminata
local MOVEMENT_RANGE = 30 -- Rango máximo de movimiento desde spawn
local WAIT_TIME_MIN = 2 -- Tiempo mínimo de espera (segundos)
local WAIT_TIME_MAX = 5 -- Tiempo máximo de espera (segundos)

-- Guardar posición inicial
local spawnPosition = rootPart.Position
local currentTarget = spawnPosition

print("🤖 Iniciando movimiento aleatorio para:", noob.Name)
print("📍 Posición inicial:", spawnPosition)

-- Función para generar nueva posición aleatoria
local function getRandomPosition()
    local angle = math.random() * 2 * math.pi
    local distance = math.random() * MOVEMENT_RANGE
    
    local newX = spawnPosition.X + math.cos(angle) * distance
    local newZ = spawnPosition.Z + math.sin(angle) * distance
    
    return Vector3.new(newX, spawnPosition.Y, newZ)
end

-- Función para mover al noob
local function moveToRandomPosition()
    currentTarget = getRandomPosition()
    humanoid:MoveTo(currentTarget)
    
    print("🎯", noob.Name, "se mueve hacia:", math.floor(currentTarget.X), math.floor(currentTarget.Z))
end

-- Función principal del loop de movimiento
local function movementLoop()
    while noob.Parent do
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
        until not noob.Parent
        
        if not noob.Parent then break end
        
        -- Esperar un tiempo aleatorio antes del siguiente movimiento
        local waitTime = math.random(WAIT_TIME_MIN * 10, WAIT_TIME_MAX * 10) / 10
        print("⏰", noob.Name, "espera", waitTime, "segundos...")
        wait(waitTime)
    end
end

-- Iniciar el loop de movimiento
spawn(movementLoop)

print("✅ ¡Noob", noob.Name, "ahora se mueve aleatoriamente!")

