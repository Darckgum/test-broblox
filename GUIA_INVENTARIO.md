# 🎒 Sistema de Inventario Moderno - Guía Completa

## 📋 Descripción

Sistema completo de inventario con diseño moderno y minimalista que incluye:
- **Inventario interactivo** con drag & drop
- **Sistema de crafteo** con recetas
- **Sistema de fusión** de items
- **Filtros y búsqueda** en tiempo real
- **Tooltips detallados** con información de items
- **Animaciones suaves** y efectos visuales

---

## 🎮 Controles

### Teclado
- **[E]** - Abrir/Cerrar inventario
- **[ESC]** - Cerrar inventario

### Ratón
- **Click Izquierdo + Arrastrar** - Mover items (drag & drop)
- **Click Derecho** - Usar item consumible
- **Hover** - Mostrar tooltip del item

---

## 🎨 Características de la UI

### Diseño Moderno
- Paleta de colores oscura con acentos cyan/azul
- Bordes redondeados y efectos de neón
- Transparencias y sombras sutiles
- Animaciones fluidas con TweenService

### Pestañas Integradas

#### 1. 📦 Inventario
- Grid de 30 slots (6 filas × 5 columnas)
- Barra de búsqueda para filtrar items
- Botones de filtro por categoría:
  - Todos
  - Materials (Materiales)
  - Weapons (Armas)
  - Consumables (Consumibles)
  - Tools (Herramientas)
  - Equipment (Equipo)

#### 2. 🔨 Crafteo
- Panel izquierdo con lista de recetas disponibles
- Panel derecho con detalles de la receta seleccionada
- Muestra materiales necesarios
- Indica si tienes suficientes recursos
- Botón "CRAFTEAR" para crear el item

#### 3. ✨ Fusión
- Dos slots para colocar items a fusionar
- Preview del resultado
- Requiere dos items idénticos
- Crea versiones mejoradas (+) de armas

---

## 📦 Items Disponibles

### Materiales
| Item | ID | Rareza | Stack |
|------|-----|--------|-------|
| Madera | `wood` | Common | 999 |
| Piedra | `stone` | Common | 999 |
| Hierro | `iron` | Uncommon | 999 |
| Oro | `gold` | Rare | 999 |
| Cristal | `crystal` | Epic | 99 |

### Armas
| Item | ID | Rareza | Daño |
|------|-----|--------|------|
| Espada de Madera | `wooden_sword` | Common | 10 |
| Espada de Hierro | `iron_sword` | Uncommon | 25 |
| Espada Dorada | `golden_sword` | Rare | 50 |
| Arco | `bow` | Uncommon | 20 |

### Consumibles
| Item | ID | Rareza | Efecto |
|------|-----|--------|--------|
| Poción de Vida | `health_potion` | Common | +50 HP |
| Poción de Velocidad | `speed_potion` | Uncommon | Velocidad ×1.5 |
| Poción de Fuerza | `strength_potion` | Rare | Daño ×2.0 |

---

## 🔨 Recetas de Crafteo

### Armas
```lua
Espada de Madera:
  - Madera × 5

Espada de Hierro:
  - Hierro × 3
  - Madera × 2

Espada Dorada:
  - Oro × 2
  - Hierro × 1

Arco:
  - Madera × 3
  - Piedra × 1
```

### Consumibles
```lua
Poción de Vida:
  - Cristal × 1
  - Madera × 2

Poción de Velocidad:
  - Cristal × 2
  - Hierro × 1

Poción de Fuerza:
  - Cristal × 3
  - Oro × 1
```

---

## ✨ Sistema de Fusión

### Armas Fusionables

| Item Base | + | Item Base | = | Resultado |
|-----------|---|-----------|---|-----------|
| Espada de Madera | + | Espada de Madera | = | Espada de Madera+ (Daño: 15) |
| Espada de Hierro | + | Espada de Hierro | = | Espada de Hierro+ (Daño: 35) |
| Espada Dorada | + | Espada Dorada | = | Espada Dorada+ (Daño: 70) |
| Arco | + | Arco | = | Arco+ (Daño: 30) |

**Nota:** Solo se pueden fusionar items idénticos. Se necesitan 2 unidades del mismo item.

---

## 💻 Comandos de Chat (Pruebas)

### Comandos Disponibles

```
/give [itemId] [cantidad]
Ejemplo: /give wood 50
Descripción: Añade items a tu inventario

/clear
Descripción: Limpia todo tu inventario

/items
Descripción: Muestra la lista de todos los items disponibles
```

### Ejemplos de Uso

```lua
-- Obtener materiales
/give wood 100
/give stone 50
/give iron 25

-- Obtener armas
/give wooden_sword 1
/give iron_sword 1

-- Obtener consumibles
/give health_potion 5
/give speed_potion 3
```

---

## 🏗️ Arquitectura del Sistema

### Archivos del Cliente
```
StarterPlayer/StarterPlayerScripts/
└── InventoryUI.client.lua    # UI completa del inventario
```

### Archivos del Servidor
```
ServerScriptService/ServerCore/
└── InventoryServer.server.lua # Servidor principal

ServerStorage/Modules/
├── InventoryManager.lua       # Gestión de inventarios
├── CraftingSystem.lua         # Sistema de crafteo
├── FusionSystem.lua          # Sistema de fusión
└── ItemDatabase.lua          # Base de datos de items
```

### Archivos Compartidos
```
ReplicatedStorage/Modules/
└── UIComponents.lua          # Componentes reutilizables
```

---

## 🔄 Eventos Remotos

### Server → Client
- `UpdateInventory` - Actualiza el inventario del jugador
- `UpdateRecipes` - Actualiza las recetas disponibles

### Client → Server
- `MoveItem` - Mover item entre slots (drag & drop)
- `UseItem` - Usar item consumible
- `CraftItem` - Craftear una receta
- `FuseItems` - Fusionar dos items
- `GetRecipes` - Solicitar recetas disponibles

---

## 🎯 Cómo Usar

### 1. Abrir el Inventario
Presiona **[E]** en cualquier momento para abrir tu inventario.

### 2. Organizar Items
- Arrastra items entre slots para reorganizarlos
- Usa la búsqueda para encontrar items específicos
- Filtra por categoría para ver solo ciertos tipos

### 3. Usar Consumibles
- Click derecho en una poción para usarla
- Los efectos se aplicarán inmediatamente
- El item se consumirá y desaparecerá

### 4. Craftear Items
1. Ve a la pestaña "Crafteo"
2. Selecciona una receta de la lista
3. Verifica que tengas los materiales
4. Click en "CRAFTEAR"
5. El item aparecerá en tu inventario

### 5. Fusionar Items
1. Ve a la pestaña "Fusión"
2. Arrastra dos items iguales a los slots
3. Verifica el resultado en el slot inferior
4. Click en "FUSIONAR"
5. El item mejorado aparecerá en tu inventario

---

## ✨ Características Avanzadas

### Sistema de Rareza
Los items tienen colores según su rareza:
- 🔲 **Common** (Gris)
- 🟢 **Uncommon** (Verde)
- 🔵 **Rare** (Azul)
- 🟣 **Epic** (Morado)
- 🟡 **Legendary** (Dorado)

### Tooltips Informativos
Al pasar el cursor sobre un item, verás:
- Nombre del item
- Nivel de rareza
- Descripción
- Estadísticas (daño, curación, etc.)
- Cantidad

### Animaciones
- Hover: Los slots se iluminan al pasar el cursor
- Click: Feedback visual al hacer click
- Drag: Icono flotante sigue el cursor
- Transiciones: Suaves entre pestañas

---

## 🔧 Personalización

### Modificar Colores
Edita `ReplicatedStorage/Modules/UIComponents.lua`:
```lua
UIComponents.Colors = {
    Primary = Color3.fromRGB(0, 200, 255), -- Color principal
    Background = Color3.fromRGB(15, 15, 20), -- Fondo
    -- ... más colores
}
```

### Añadir Nuevos Items
Edita `ServerStorage/Modules/ItemDatabase.lua`:
```lua
{
    id = "nuevo_item",
    name = "Nuevo Item",
    description = "Descripción del item",
    category = "Materials",
    rarity = "Common",
    stackable = true,
    maxStack = 999,
    icon = "rbxassetid://..."
}
```

### Crear Nuevas Recetas
Edita `ServerStorage/Modules/CraftingSystem.lua`:
```lua
{
    id = "nueva_receta",
    name = "Nueva Receta",
    result = "item_resultado",
    resultQuantity = 1,
    materials = {
        {id = "material1", quantity = 5},
        {id = "material2", quantity = 3}
    },
    category = "Weapons",
    discovered = true
}
```

---

## 🐛 Solución de Problemas

### El inventario no se abre
- Verifica que Rojo esté conectado
- Revisa la consola para errores
- Asegúrate de que todos los módulos estén cargados

### Los items no se mueven
- Verifica que los eventos remotos existan
- Revisa la conexión del servidor
- Comprueba que el inventario esté sincronizado

### No puedo craftear
- Verifica que tengas los materiales necesarios
- Asegúrate de que la receta esté desbloqueada
- Revisa que haya espacio en el inventario

### La UI no se ve bien
- Verifica la resolución de pantalla
- Ajusta el UIScale si es necesario
- Revisa que UIComponents esté cargado

---

## 📝 Notas Importantes

1. **Guardado Automático**: El inventario se guarda automáticamente cada 30 segundos
2. **Persistencia**: Los items se guardan en DataStore y persisten entre sesiones
3. **Seguridad**: Todas las acciones se validan en el servidor
4. **Performance**: Sistema optimizado con object pooling y debouncing

---

## 🚀 Próximas Mejoras

- [ ] Sistema de comercio entre jugadores
- [ ] Tienda NPC para comprar/vender items
- [ ] Más recetas y items
- [ ] Sistema de mejora de items (enchantments)
- [ ] Inventario compartido (banco/cofre)
- [ ] Iconos personalizados para items
- [ ] Efectos de partículas para fusiones
- [ ] Sonidos para acciones

---

## 📞 Soporte

Si encuentras errores o tienes sugerencias:
1. Revisa la consola de Roblox Studio
2. Verifica los logs del servidor
3. Consulta esta guía
4. Revisa el código fuente

---

**¡Disfruta del sistema de inventario moderno!** 🎮✨


