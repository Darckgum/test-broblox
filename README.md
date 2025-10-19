# 🎮 Proyecto Roblox RPG - Sistema de Vida Avanzado

## 📋 Estado Actual del Proyecto

Este repositorio contiene un sistema de vida avanzado para Roblox Studio con las siguientes características:

### ✨ Características Implementadas
- ✅ **Barra de vida en GUI** - Interfaz moderna en pantalla
- ✅ **Regeneración automática** - 5 HP/seg después de 3 segundos sin daño
- ✅ **Pantalla de muerte** - Interfaz elegante con botón de respawn
- ✅ **Efectos visuales** - Flash rojo, vignette, sacudida de cámara
- ✅ **Múltiples objetos de daño** - 4 intensidades diferentes
- ✅ **Sistema de vida variable** - Escalable para futuras mejoras
- ✅ **Comunicación cliente-servidor** - RemoteEvents para sincronización

### 🎯 Objetos de Daño Disponibles
- **Daño Ligero:** 5 HP cada 2 seg (verde)
- **Daño Medio:** 10 HP cada 2 seg (amarillo) 
- **Daño Fuerte:** 20 HP cada 2 seg (naranja)
- **Daño Extremo:** 35 HP cada 2 seg (rojo)

## 🚀 Cómo Usar el Proyecto

### Opción 1: Abrir Archivo .rbxlx
1. Descarga `roblox-studio-actual.rbxlx` del repositorio
2. En Roblox Studio: `File` → `Open from File`
3. Selecciona el archivo .rbxlx
4. ¡Listo! El proyecto se carga con todos los sistemas

### Opción 2: Sincronización con Rojo (Recomendado)
1. **Instalar Rojo:**
   ```bash
   npm install -g rojo
   ```

2. **Iniciar servidor Rojo:**
   ```bash
   rojo serve
   ```

3. **En Roblox Studio:**
   - Instalar plugin de Rojo
   - Conectar a `localhost:34872`
   - Los archivos se sincronizan automáticamente

4. **Para subir cambios:**
   ```bash
   git add .
   git commit -m "Descripción de cambios"
   git push
   ```

## 📁 Estructura del Proyecto

```
src/
├── ServerScriptService/ServerCore/
│   └── MainServer.server.lua
├── ServerStorage/Modules/
│   └── HealthSystem.lua
├── ReplicatedStorage/Modules/
├── StarterPlayer/StarterPlayerScripts/
│   └── HealthBarClient.client.lua
└── StarterGui/RPGGUI/
```

## 🔧 Archivos de Configuración

- `default.project.json` - Configuración de Rojo
- `package.json` - Dependencias de Node.js
- `.gitignore` - Archivos ignorados por Git

## 📚 Documentación

- `INSTALACION.md` - Guía de instalación paso a paso
- `ESTRUCTURA.md` - Explicación detallada de la arquitectura

## 🎮 Cómo Probar el Sistema

1. **Ejecutar el juego** (F5 en Roblox Studio)
2. **Esperar 5 segundos** para que se cargue todo
3. **Verás:**
   - Barra de vida moderna en esquina superior izquierda
   - Suelo gris plano
   - 4 esferas de colores diferentes (objetos de daño)
4. **Probar:**
   - Camina hacia las esferas para recibir daño
   - Observa efectos visuales (flash, sacudida)
   - Cuando la vida baje, verás vignette
   - Al morir, aparecerá pantalla de muerte
   - Presiona "RESPAWNEAR" para revivir
   - Espera 3 segundos sin daño para ver regeneración

## 🔄 Flujo de Desarrollo

### Para Desarrolladores Individuales:
```
Roblox Studio ↔ Archivos Locales ↔ GitHub
```

### Para Equipos:
```
Desarrollador A (Roblox Studio) ┐
                                ├→ GitHub → Desarrollador B (Roblox Studio)
Desarrollador C (Roblox Studio) ┘
```

## 📝 Comandos Útiles

```bash
# Ver estado del repositorio
git status

# Agregar cambios
git add .

# Hacer commit
git commit -m "Descripción de cambios"

# Subir a GitHub
git push

# Descargar cambios
git pull

# Generar archivo .rbxlx
rojo build --output proyecto.rbxlx
```

## 🐛 Solución de Problemas

### Rojo no se conecta:
1. Verificar que el servidor esté corriendo: `rojo serve`
2. Verificar puerto 34872: `netstat -ano | findstr :34872`
3. Reiniciar Roblox Studio y reconectar

### Archivos no se sincronizan:
1. Verificar conexión a Rojo en Roblox Studio
2. Verificar que los archivos existan en la estructura local
3. Reiniciar servidor Rojo

### Errores de Git:
1. Verificar configuración: `git config --list`
2. Verificar credenciales de GitHub
3. Verificar permisos del repositorio

## 📞 Soporte

Si tienes problemas:
1. Revisa la documentación en `INSTALACION.md`
2. Verifica que todos los servicios estén funcionando
3. Consulta los logs de Rojo y Roblox Studio

---

**¡Disfruta desarrollando tu RPG en Roblox!** 🎮✨