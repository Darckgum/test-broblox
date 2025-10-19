# 📥 Guía de Instalación - Proyecto RPG Roblox

Esta guía te llevará paso a paso para instalar y configurar el proyecto RPG completo en tu entorno de desarrollo.

## 📋 Prerrequisitos

### Software Requerido

- **Roblox Studio** (versión más reciente)
- **Node.js** (versión 16 o superior)
- **Git** (para clonar el repositorio)
- **Editor de código** (VS Code recomendado)

### Cuentas Necesarias

- **Cuenta de Roblox** (gratuita)
- **Cuenta de GitHub** (para clonar el repositorio)

## 🚀 Instalación Paso a Paso

### Paso 1: Instalar Node.js

1. **Descargar Node.js**:
   - Ve a [nodejs.org](https://nodejs.org/)
   - Descarga la versión LTS (recomendada)
   - Ejecuta el instalador y sigue las instrucciones

2. **Verificar instalación**:
   ```bash
   node --version
   npm --version
   ```

### Paso 2: Instalar Rojo

1. **Instalar Rojo globalmente**:
   ```bash
   npm install -g @rojo/cli
   ```

2. **Verificar instalación**:
   ```bash
   rojo --version
   ```

### Paso 3: Clonar el Proyecto

1. **Crear directorio de trabajo**:
   ```bash
   mkdir roblox-projects
   cd roblox-projects
   ```

2. **Clonar el repositorio**:
   ```bash
   git clone <URL_DEL_REPOSITORIO>
   cd testt
   ```

### Paso 4: Configurar Roblox Studio

1. **Abrir Roblox Studio**:
   - Inicia Roblox Studio
   - Crea un nuevo lugar (Baseplate)

2. **Instalar Plugin de Rojo**:
   - Ve a [rojo.space](https://rojo.space/)
   - Descarga el plugin de Rojo
   - Instálalo en Roblox Studio

### Paso 5: Sincronizar el Proyecto

1. **Iniciar servidor Rojo**:
   ```bash
   rojo serve
   ```
   
   Deberías ver algo como:
   ```
   Rojo server listening on port 34872
   ```

2. **Conectar desde Roblox Studio**:
   - En Roblox Studio, busca el plugin de Rojo
   - Haz clic en "Connect"
   - Ingresa `localhost:34872`
   - Haz clic en "Connect"

3. **Verificar sincronización**:
   - Deberías ver todas las carpetas del proyecto en Roblox Studio
   - Los archivos se sincronizarán automáticamente

## 🔧 Configuración Avanzada

### Configuración de VS Code (Opcional)

1. **Instalar extensiones recomendadas**:
   - **Lua Language Server**
   - **Roblox LSP**
   - **Rojo**

2. **Configurar workspace**:
   ```json
   {
       "folders": [
           {
               "path": "."
           }
       ],
       "settings": {
           "Lua.workspace.library": [
               "C:/Users/[TU_USUARIO]/AppData/Local/Roblox/Versions/[VERSION]/content"
           ]
       }
   }
   ```

### Configuración de Git

1. **Configurar usuario**:
   ```bash
   git config --global user.name "Tu Nombre"
   git config --global user.email "tu@email.com"
   ```

2. **Crear .gitignore**:
   ```gitignore
   # Rojo
   *.rbxlx
   *.rbxl
   
   # Node
   node_modules/
   package-lock.json
   
   # IDE
   .vscode/
   .idea/
   
   # OS
   .DS_Store
   Thumbs.db
   ```

## 🎮 Primera Ejecución

### Paso 1: Verificar Estructura

Asegúrate de que la estructura de carpetas sea correcta:

```
testt/
├── src/
│   ├── ServerScriptService/
│   ├── ServerStorage/
│   ├── ReplicatedStorage/
│   ├── StarterPlayer/
│   └── StarterGui/
├── default.project.json
└── README.md
```

### Paso 2: Ejecutar el Juego

1. **En Roblox Studio**:
   - Haz clic en "Play" para ejecutar el juego
   - Deberías ver mensajes en la consola del servidor

2. **Verificar funcionamiento**:
   - Presiona `Tab` para abrir la GUI
   - Verifica que los controles funcionen
   - Revisa la consola para errores

### Paso 3: Probar Características

1. **Sistema de Stats**:
   - Presiona `C` para ver estadísticas
   - Verifica que se muestren correctamente

2. **Sistema de Inventario**:
   - Presiona `I` para abrir inventario
   - Verifica que los items iniciales aparezcan

3. **Sistema de Habilidades**:
   - Presiona `K` para ver habilidades
   - Verifica que las habilidades estén disponibles

4. **Sistema de Quests**:
   - Presiona `Q` para ver quests
   - Verifica que las quests estén listadas

## 🐛 Solución de Problemas

### Problema: Rojo no se conecta

**Síntomas**:
- Error de conexión en Roblox Studio
- Servidor no responde

**Soluciones**:
1. **Verificar puerto**:
   ```bash
   netstat -an | findstr 34872
   ```

2. **Reiniciar servidor**:
   ```bash
   rojo serve --port 34873
   ```

3. **Verificar firewall**:
   - Permitir Node.js en el firewall
   - Permitir Roblox Studio

### Problema: Scripts no se cargan

**Síntomas**:
- Errores en la consola
- Funcionalidad no disponible

**Soluciones**:
1. **Verificar estructura**:
   - Asegúrate de que los archivos estén en las carpetas correctas
   - Verifica que los nombres de archivo sean exactos

2. **Revisar dependencias**:
   - Verifica que todos los módulos estén presentes
   - Comprueba que no haya errores de sintaxis

3. **Reiniciar sincronización**:
   - Detén el servidor Rojo (`Ctrl+C`)
   - Reinicia con `rojo serve`
   - Reconecta desde Studio

### Problema: GUI no aparece

**Síntomas**:
- Los controles no funcionan
- No se muestra la interfaz

**Soluciones**:
1. **Verificar script del cliente**:
   - Asegúrate de que `ClientMain.client.lua` esté en `StarterPlayerScripts`
   - Verifica que no haya errores en la consola del cliente

2. **Revisar PlayerGui**:
   - Verifica que el script tenga acceso a `PlayerGui`
   - Comprueba que no haya conflictos con otros scripts

### Problema: Errores de módulos

**Síntomas**:
- Errores de "Module not found"
- Funcionalidad específica no funciona

**Soluciones**:
1. **Verificar rutas**:
   - Asegúrate de que los módulos estén en `ServerStorage/Modules`
   - Verifica que las rutas de `require()` sean correctas

2. **Revisar sintaxis**:
   - Comprueba que todos los módulos tengan `return` al final
   - Verifica que no haya errores de sintaxis

## 📚 Recursos Adicionales

### Documentación Oficial

- **Rojo**: [rojo.space/docs](https://rojo.space/docs)
- **Roblox**: [developer.roblox.com](https://developer.roblox.com)
- **Lua**: [lua.org/manual](https://www.lua.org/manual/5.1/)

### Herramientas Útiles

- **Roblox LSP**: Para autocompletado en VS Code
- **Selene**: Linter para Lua
- **StyLua**: Formateador de código Lua

### Comunidad

- **Discord de Rojo**: Para soporte técnico
- **Foros de Roblox**: Para preguntas generales
- **GitHub Issues**: Para reportar bugs

## ✅ Verificación Final

Una vez completada la instalación, deberías poder:

- [ ] Ejecutar `rojo serve` sin errores
- [ ] Conectar desde Roblox Studio
- [ ] Ver la estructura del proyecto en Studio
- [ ] Ejecutar el juego sin errores
- [ ] Usar todos los controles (`Tab`, `I`, `C`, `K`, `Q`)
- [ ] Ver la GUI funcionando correctamente
- [ ] Ver mensajes de inicialización en la consola

## 🆘 Soporte

Si encuentras problemas que no están cubiertos en esta guía:

1. **Revisa los logs** de la consola
2. **Busca en GitHub Issues** si ya fue reportado
3. **Crea un nuevo issue** con detalles del problema
4. **Incluye información del sistema** (OS, versiones, etc.)

---

**¡Felicitaciones! 🎉 Tu proyecto RPG está listo para desarrollar.**
