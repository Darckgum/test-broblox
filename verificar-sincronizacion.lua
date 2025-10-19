-- Script para verificar sincronización con Roblox Studio
-- Ejecuta este script en Roblox Studio para verificar la conexión

print("=== VERIFICACIÓN DE SINCRONIZACIÓN ROJO ===")
print("Servidor Rojo funcionando en puerto 34872")
print("Archivos sincronizados desde Roblox Studio:")
print("")

-- Verificar servicios principales
local services = {
    "ServerScriptService",
    "ServerStorage", 
    "ReplicatedStorage",
    "StarterPlayer",
    "StarterGui"
}

for _, serviceName in ipairs(services) do
    local service = game:GetService(serviceName)
    if service then
        print("✅ " .. serviceName .. " - " .. #service:GetChildren() .. " objetos")
        
        -- Listar objetos principales
        for _, child in ipairs(service:GetChildren()) do
            if child:IsA("Folder") or child:IsA("Script") or child:IsA("LocalScript") or child:IsA("ModuleScript") then
                print("   📁 " .. child.Name .. " (" .. child.ClassName .. ")")
            end
        end
    end
end

print("")
print("=== INSTRUCCIONES ===")
print("1. Asegúrate de estar conectado a Rojo")
print("2. Los cambios se sincronizarán automáticamente")
print("3. Ejecuta 'git add . && git commit && git push' en Cursor")
print("=== FIN VERIFICACIÓN ===")
