# 🚀 Guía Completa de Instalación - Proyecto Roblox RPG

## 📋 Requisitos del Sistema

- **Sistema Operativo:** Windows 10/11
- **Memoria RAM:** Mínimo 4GB (Recomendado 8GB+)
- **Espacio en disco:** 2GB libres
- **Conexión a internet:** Requerida para descargas

## 🎯 Software Necesario

### 1. **Roblox Studio** (Obligatorio)
### 2. **Node.js** (Para Rojo)
### 3. **Git** (Para control de versiones)
### 4. **Rojo** (Para sincronización)
### 5. **Cursor/VS Code** (Editor de código - Opcional)

---

## 📥 Paso 1: Instalar Roblox Studio

### **Opción A: Desde el sitio web oficial**
1. Ve a [https://create.roblox.com/](https://create.roblox.com/)
2. Haz clic en **"Download Studio"**
3. Ejecuta el instalador descargado
4. Sigue las instrucciones del instalador
5. **¡Listo!** Roblox Studio estará instalado

### **Opción B: Desde Microsoft Store**
1. Abre **Microsoft Store**
2. Busca **"Roblox Studio"**
3. Haz clic en **"Instalar"**
4. Espera a que termine la instalación

### **Verificación:**
- Abre Roblox Studio
- Deberías ver la pantalla de inicio
- Si funciona, ¡instalación exitosa!

---

## 📥 Paso 2: Instalar Node.js

### **Método 1: Usando winget (Recomendado)**
```powershell
# Abrir PowerShell como administrador
winget install --id OpenJS.NodeJS -e --source winget
```

### **Método 2: Descarga manual**
1. Ve a [https://nodejs.org/](https://nodejs.org/)
2. Descarga la versión **LTS** (Long Term Support)
3. Ejecuta el instalador
4. **IMPORTANTE:** Marca la casilla "Add to PATH"
5. Completa la instalación

### **Verificación:**
```powershell
# Abrir PowerShell y ejecutar:
node --version
npm --version
```
**Deberías ver algo como:**
```
v20.10.0
10.2.3
```

---

## 📥 Paso 3: Instalar Git

### **Método 1: Usando winget (Recomendado)**
```powershell
# Abrir PowerShell como administrador
winget install --id Git.Git -e --source winget
```

### **Método 2: Descarga manual**
1. Ve a [https://git-scm.com/download/win](https://git-scm.com/download/win)
2. Descarga el instalador
3. Ejecuta el instalador con configuración por defecto
4. Completa la instalación

### **Configuración inicial:**
```powershell
# Configurar usuario (reemplaza con tus datos)
git config --global user.name "Tu Nombre"
git config --global user.email "tu.email@ejemplo.com"
```

### **Verificación:**
```powershell
git --version
git config --list
```

---

## 📥 Paso 4: Instalar Rojo

### **Instalación:**
```powershell
# Instalar Rojo globalmente
npm install -g rojo
```

### **Verificación:**
```powershell
rojo --version
```
**Deberías ver algo como:**
```
Rojo 7.5.1
```

---

## 📥 Paso 5: Instalar Editor de Código (Opcional)

### **Opción A: Cursor (Recomendado)**
1. Ve a [https://cursor.sh/](https://cursor.sh/)
2. Descarga e instala Cursor
3. Es un fork de VS Code con IA integrada

### **Opción B: Visual Studio Code**
1. Ve a [https://code.visualstudio.com/](https://code.visualstudio.com/)
2. Descarga e instala VS Code
3. Instala extensiones recomendadas:
   - **Lua** (por sumneko)
   - **GitLens**
   - **Rojo** (si está disponible)

---

## 🎮 Paso 6: Configurar Roblox Studio

### **Instalar Plugin de Rojo:**
1. Abre **Roblox Studio**
2. Ve a la pestaña **"Plugins"**
3. Busca **"Rojo"** en la tienda de plugins
4. Haz clic en **"Install"**
5. Reinicia Roblox Studio

### **Verificación del plugin:**
- Deberías ver el plugin de Rojo en la barra de herramientas
- Si no aparece, busca en **"Plugins"** → **"Manage Plugins"**

---

## 📁 Paso 7: Clonar el Proyecto

### **Crear carpeta de trabajo:**
```powershell
# Crear carpeta para proyectos
mkdir C:\ProyectosRoblox
cd C:\ProyectosRoblox
```

### **Clonar repositorio:**
```powershell
# Clonar el proyecto
git clone https://github.com/Darckgum/test-broblox.git
cd test-broblox
```

### **Verificar estructura:**
```powershell
# Ver archivos del proyecto
dir
dir src
```

---

## 🚀 Paso 8: Configurar el Proyecto

### **Instalar dependencias:**
```powershell
# Instalar dependencias de Node.js
npm install
```

### **Iniciar servidor Rojo:**
```powershell
# Iniciar servidor Rojo
rojo serve
```

**Deberías ver:**
```
Rojo server listening:
  Address: localhost
  Port:    34872
Visit http://localhost:34872/ in your browser for more information.
```

### **Conectar Roblox Studio:**
1. Abre **Roblox Studio**
2. Ve a **"Plugins"** → **"Rojo"** → **"Connect"**
3. Ingresa: `localhost:34872`
4. Haz clic en **"Connect"**

**¡Deberías ver que se conecta exitosamente!**

---

## 🎯 Paso 9: Probar el Proyecto

### **Opción A: Usar archivo .rbxlx**
1. Descarga `roblox-studio-actual.rbxlx` del repositorio
2. En Roblox Studio: **File** → **Open from File**
3. Selecciona el archivo .rbxlx
4. ¡El proyecto se carga!

### **Opción B: Usar sincronización Rojo**
1. Con Roblox Studio conectado a Rojo
2. Los archivos se sincronizan automáticamente
3. Cualquier cambio se refleja inmediatamente

### **Verificar funcionamiento:**
1. Presiona **F5** para ejecutar el juego
2. Deberías ver:
   - Barra de vida en esquina superior izquierda
   - Suelo gris plano
   - 4 esferas de colores (objetos de daño)
3. **¡Prueba el sistema!** Camina hacia las esferas

---

## 🔧 Solución de Problemas Comunes

### **❌ Error: "node no se reconoce"**
**Solución:**
```powershell
# Reiniciar PowerShell
# Verificar PATH
echo $env:PATH
# Si Node.js no está en PATH, reinstalar con "Add to PATH" marcado
```

### **❌ Error: "git no se reconoce"**
**Solución:**
```powershell
# Reiniciar PowerShell
# Verificar instalación
where git
# Si no encuentra, reinstalar Git
```

### **❌ Error: "rojo no se reconoce"**
**Solución:**
```powershell
# Reinstalar Rojo
npm uninstall -g rojo
npm install -g rojo
# Verificar
rojo --version
```

### **❌ Rojo no se conecta en Roblox Studio**
**Solución:**
1. Verificar que el servidor esté corriendo:
   ```powershell
   netstat -ano | findstr :34872
   ```
2. Reiniciar Roblox Studio
3. Verificar que el plugin esté instalado
4. Intentar reconectar

### **❌ Error de permisos en PowerShell**
**Solución:**
```powershell
# Ejecutar PowerShell como administrador
# O cambiar política de ejecución
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### **❌ Puerto 34872 ocupado**
**Solución:**
```powershell
# Ver qué usa el puerto
netstat -ano | findstr :34872
# Terminar proceso si es necesario
taskkill /PID [número_del_proceso] /F
# Reiniciar Rojo
rojo serve
```

---

## 📚 Comandos Útiles

### **Git:**
```powershell
# Ver estado
git status

# Agregar cambios
git add .

# Hacer commit
git commit -m "Descripción de cambios"

# Subir cambios
git push

# Descargar cambios
git pull
```

### **Rojo:**
```powershell
# Iniciar servidor
rojo serve

# Generar archivo .rbxlx
rojo build --output proyecto.rbxlx

# Ver ayuda
rojo --help
```

### **Node.js:**
```powershell
# Ver versión
node --version
npm --version

# Instalar paquete global
npm install -g [nombre-paquete]

# Ver paquetes globales
npm list -g --depth=0
```

---

## 🎉 ¡Instalación Completa!

### **✅ Checklist de verificación:**
- [ ] Roblox Studio instalado y funcionando
- [ ] Node.js instalado (`node --version`)
- [ ] Git instalado (`git --version`)
- [ ] Rojo instalado (`rojo --version`)
- [ ] Proyecto clonado de GitHub
- [ ] Servidor Rojo funcionando (`rojo serve`)
- [ ] Roblox Studio conectado a Rojo
- [ ] Proyecto cargado y funcionando

### **🚀 Próximos pasos:**
1. **Desarrollar:** Haz cambios en Roblox Studio
2. **Sincronizar:** Los cambios aparecen automáticamente en archivos
3. **Subir:** Usa `git push` para subir cambios
4. **Colaborar:** Otros pueden usar `git pull` para obtener cambios

### **📞 Soporte:**
Si tienes problemas:
1. Revisa esta guía paso a paso
2. Verifica que todos los requisitos estén instalados
3. Consulta los logs de error
4. Reinicia servicios si es necesario

---

**¡Disfruta desarrollando tu RPG en Roblox!** 🎮✨

**Repositorio:** [https://github.com/Darckgum/test-broblox](https://github.com/Darckgum/test-broblox)
