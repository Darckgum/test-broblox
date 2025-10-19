# Script para iniciar Rojo
Write-Host "Iniciando servidor de Rojo..." -ForegroundColor Green

# Agregar Node.js al PATH
$env:PATH += ";C:\Program Files\nodejs\"

# Ejecutar Rojo
& "C:\Program Files\nodejs\node.exe" "C:\Users\PC\AppData\Roaming\npm\node_modules\rojo\dist\main.js" serve

Write-Host "Servidor de Rojo iniciado en puerto 34872" -ForegroundColor Yellow
Write-Host "Presiona Ctrl+C para detener el servidor" -ForegroundColor Red
