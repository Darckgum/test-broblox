# 🎒 Sistema de Inventario con Crafteo y Fusión

## 🚀 Características Implementadas

### ✨ Sistema de Inventario Completo
- **30 slots** de inventario con persistencia en DataStore
- **Interfaz moderna** con pestañas por categorías
- **Sistema de rareza** con colores (Común, Poco común, Raro, Épico, Legendario)
- **Items stackables** y no stackables
- **Drag & drop** entre slots
- **Animaciones suaves** y efectos visuales

### 🔨 Sistema de Crafteo Avanzado
- **Recetas predefinidas** (7 recetas básicas)
- **Sistema de descubrimiento** - experimenta para encontrar nuevas recetas
- **Validación de materiales** en tiempo real
- **Panel de crafteo** con lista de recetas disponibles
- **Efectos visuales** al craftear

### ✨ Sistema de Fusión
- **Fusión simple** de 2 items del mismo tipo
- **Items mejorados** con niveles de fusión
- **Validación automática** de compatibilidad
- **Efectos de partículas** durante la fusión

### 🎮 Interfaz de Usuario
- **Diseño moderno** con bordes brillantes
- **Pestañas por categorías**: All, Materials, Weapons, Consumables, Tools, Equipment
- **Grid de 5x6** para 30 slots de inventario
- **Tooltips** con información de items
- **Animaciones de entrada/salida**
- **Efectos hover** y selección

## 🎯 Controles

### Teclado
- **E** - Abrir/Cerrar inventario
- **ESC** - Cerrar inventario

### Mouse
- **Click izquierdo** - Seleccionar item
- **Click derecho** - Usar/Equipar item
- **Hover** - Efectos visuales y tooltips

## 🧪 Comandos de Testing

### Comandos de Chat
```
/give [item] [cantidad] - Agregar item al inventario
/clear - Limpiar inventario
/items - Listar todos los items disponibles
/recipes - Listar todas las recetas
/discover [recipe] - Descubrir receta específica
/fuse [item1] [item2] - Fusionar dos items
/test - Obtener items de prueba
/help - Mostrar ayuda
```

### Items Disponibles
- **Materiales**: wood, stone, iron, gold, crystal
- **Armas**: wooden_sword, iron_sword, golden_sword, bow
- **Consumibles**: health_potion, speed_potion, strength_potion

### Recetas de Crafteo
1. **Espada de Madera**: 5x Madera
2. **Espada de Hierro**: 3x Hierro + 2x Madera
3. **Espada Dorada**: 2x Oro + 1x Hierro
4. **Arco**: 3x Madera + 1x Piedra
5. **Poción de Vida**: 1x Cristal + 2x Madera
6. **Poción de Velocidad**: 2x Cristal + 1x Hierro (descubrir)
7. **Poción de Fuerza**: 3x Cristal + 1x Oro (descubrir)

### Items Fusionables
- **Espada de Madera** + **Espada de Madera** = **Espada de Madera+**
- **Espada de Hierro** + **Espada de Hierro** = **Espada de Hierro+**
- **Espada Dorada** + **Espada Dorada** = **Espada Dorada+**
- **Arco** + **Arco** = **Arco+**

## 🏗️ Arquitectura del Sistema

### Servidor (ServerScriptService)
- **MainServer.server.lua** - Servidor principal
- **InventoryServer.server.lua** - Manejo de peticiones del inventario
- **TestingCommands.server.lua** - Comandos de testing

### Módulos (ServerStorage/Modules)
- **ItemDatabase.lua** - Base de datos de items
- **InventoryManager.lua** - Gestión del inventario
- **CraftingSystem.lua** - Sistema de crafteo
- **FusionSystem.lua** - Sistema de fusión

### Cliente (StarterPlayerScripts)
- **InventoryClient.client.lua** - Interfaz de usuario

### Comunicación
- **RemoteEvents** en ReplicatedStorage/RemoteEvents/InventoryEvents/
- **DataStore** para persistencia de inventarios
- **Cooldowns** para prevenir spam

## 🎨 Efectos Visuales

### Animaciones
- **Entrada/Salida** del inventario con efecto Back
- **Hover** en slots con cambio de tamaño
- **Selección** con efecto de brillo
- **Botones** con animación de presión

### Partículas
- **Apertura** del inventario
- **Uso** de items (verde)
- **Crafteo** (verde)
- **Fusión** (dorado)

### Colores de Rareza
- **Común** (Gris) - Items básicos
- **Poco común** (Verde) - Items mejorados
- **Raro** (Azul) - Items especiales
- **Épico** (Morado) - Items poderosos
- **Legendario** (Dorado) - Items únicos

## 🔧 Configuración

### Tamaño del Inventario
```lua
local INVENTORY_SIZE = 30 -- Cambiar en InventoryManager.lua
```

### Intervalo de Guardado
```lua
local SAVE_INTERVAL = 30 -- segundos en InventoryManager.lua
```

### Cooldown de Acciones
```lua
local COOLDOWN_TIME = 0.5 -- segundos en InventoryServer.server.lua
```

## 🚀 Cómo Usar

1. **Ejecutar el juego** en Roblox Studio
2. **Esperar 5 segundos** para que se cargue todo
3. **Presionar E** para abrir el inventario
4. **Escribir /test** en chat para obtener items de prueba
5. **Experimentar** con crafteo y fusión

## 🐛 Solución de Problemas

### El inventario no se abre
- Verificar que el cliente esté cargado
- Revisar la consola de errores
- Verificar conexión con Rojo

### Items no se guardan
- Verificar DataStore habilitado
- Revisar permisos de DataStore
- Verificar conexión a internet

### Errores de crafteo
- Verificar que tengas los materiales necesarios
- Revisar que la receta esté descubierta
- Verificar que el inventario no esté lleno

## 📝 Notas de Desarrollo

- **Seguridad**: Todas las validaciones en el servidor
- **Performance**: Cache de inventarios en memoria
- **Escalabilidad**: Sistema modular fácil de extender
- **Mantenibilidad**: Código bien documentado y organizado

---

**¡Disfruta tu sistema de inventario completo!** 🎮✨



