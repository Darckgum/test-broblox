-- Script de Prueba del Sistema de Vida
-- Verifica que todos los componentes estén funcionando correctamente

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- Función para verificar que todos los módulos estén disponibles
local function verifyModules()
    print("=== VERIFICACIÓN DE MÓDULOS ===")
    
    -- Verificar HealthSystem
    local modules = ServerStorage:WaitForChild("Modules")
    local healthSystem = modules:FindFirstChild("HealthSystem")
    if healthSystem then
        print("✅ HealthSystem.lua encontrado")
    else
        print("❌ HealthSystem.lua NO encontrado")
    end
    
    -- Verificar RemoteEvents
    local remoteEventsFolder = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if remoteEventsFolder then
        print("✅ RemoteEvents folder encontrado")
        
        local events = {"DamagePlayer", "RequestRespawn", "UpdateMaxHealth", "PlayerDied", "PlayerRespawned"}
        for _, eventName in ipairs(events) do
            local event = remoteEventsFolder:FindFirstChild(eventName)
            if event then
                print("✅ " .. eventName .. " RemoteEvent encontrado")
            else
                print("❌ " .. eventName .. " RemoteEvent NO encontrado")
            end
        end
    else
        print("❌ RemoteEvents folder NO encontrado")
    end
    
    print("=== FIN VERIFICACIÓN ===\n")
end

-- Función para mostrar información del sistema
local function showSystemInfo()
    print("=== INFORMACIÓN DEL SISTEMA DE VIDA ===")
    print("🎯 Características implementadas:")
    print("  • Barra de vida en GUI de pantalla")
    print("  • Regeneración automática (5 HP/seg después de 3 seg)")
    print("  • Pantalla de muerte con botón de respawn")
    print("  • Efectos visuales de daño (flash rojo, vignette, sacudida)")
    print("  • Sistema de vida variable")
    print("  • 4 objetos de daño con diferentes intensidades")
    print("  • Comunicación cliente-servidor con RemoteEvents")
    print("\n🎮 Objetos de daño disponibles:")
    print("  • Daño Ligero: 5 HP cada 2 seg (verde)")
    print("  • Daño Medio: 10 HP cada 2 seg (amarillo)")
    print("  • Daño Fuerte: 20 HP cada 2 seg (naranja)")
    print("  • Daño Extremo: 35 HP cada 2 seg (rojo)")
    print("\n📁 Archivos creados:")
    print("  Servidor:")
    print("    • src/ServerStorage/Modules/HealthSystem.lua")
    print("    • src/ServerScriptService/ServerCore/RemoteEventsSetup.server.lua")
    print("    • src/ServerScriptService/ServerCore/MainServer.server.lua")
    print("  Cliente:")
    print("    • src/StarterPlayer/StarterPlayerScripts/HealthBarClient.client.lua")
    print("    • src/StarterPlayer/StarterPlayerScripts/HealthRegenClient.client.lua")
    print("    • src/StarterPlayer/StarterPlayerScripts/DeathScreenClient.client.lua")
    print("    • src/StarterPlayer/StarterPlayerScripts/DamageEffectsClient.client.lua")
    print("=== FIN INFORMACIÓN ===\n")
end

-- Función para probar el sistema con un jugador
local function testWithPlayer(player)
    if not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    print("=== PRUEBA CON " .. player.Name .. " ===")
    print("Vida actual: " .. humanoid.Health .. "/" .. humanoid.MaxHealth)
    print("Sistema de vida inicializado: " .. tostring(ServerStorage.Modules.HealthSystem.GetHealthData(player) ~= nil))
    print("=== FIN PRUEBA ===\n")
end

-- Ejecutar verificaciones
spawn(function()
    wait(3) -- Esperar a que todo se cargue
    
    verifyModules()
    showSystemInfo()
    
    -- Probar con jugadores existentes
    for _, player in ipairs(Players:GetPlayers()) do
        testWithPlayer(player)
    end
    
    -- Probar con nuevos jugadores
    Players.PlayerAdded:Connect(function(player)
        wait(2)
        testWithPlayer(player)
    end)
end)

print("Sistema de Vida Avanzado - Script de verificación iniciado")
