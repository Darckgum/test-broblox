# 📁 Documentación de Estructura - Proyecto RPG Roblox

Esta documentación explica en detalle la estructura del proyecto, el propósito de cada archivo y cómo interactúan los diferentes componentes.

## 🏗️ Arquitectura General

El proyecto sigue una arquitectura modular con separación clara entre servidor y cliente:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   CLIENTE       │    │   COMPARTIDO     │    │   SERVIDOR      │
│                 │    │                 │    │                 │
│ • ClientMain    │◄──►│ • SharedConfig  │◄──►│ • MainServer    │
│ • GUISystem     │    │ • RemoteEvents  │    │ • ServerEvents   │
│ • PlayerGui     │    │                 │    │ • Modules       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 📂 Estructura Detallada

### 🖥️ Servidor (ServerScriptService)

#### `MainServer.server.lua`
**Propósito**: Script principal que inicializa todos los sistemas del servidor.

**Responsabilidades**:
- Inicializar módulos del servidor
- Configurar eventos de jugadores
- Crear contenido del mundo (NPCs, enemigos, cofres)
- Manejar regeneración de stats
- Auto-guardado de datos

**Dependencias**:
- Todos los módulos de `ServerStorage/Modules`
- Servicios de Roblox (Players, ReplicatedStorage, etc.)

#### `ServerEvents.server.lua`
**Propósito**: Maneja todos los RemoteEvents para comunicación cliente-servidor.

**Responsabilidades**:
- Procesar eventos de combate
- Manejar acciones de inventario
- Procesar eventos de stats
- Gestionar eventos de quests
- Crear RemoteEvents dinámicamente

**Eventos Manejados**:
- `AttackEvent`: Ataques básicos
- `SkillEvent`: Uso de habilidades
- `EquipItemEvent`: Equipamiento de items
- `UseItemEvent`: Uso de consumibles
- `StartQuestEvent`: Inicio de quests

### 🗄️ Módulos del Servidor (ServerStorage/Modules)

#### `PlayerStats.lua`
**Propósito**: Sistema completo de estadísticas del jugador.

**Características**:
- Gestión de niveles y experiencia
- Atributos del personaje (Fuerza, Defensa, etc.)
- Sistema de puntos de habilidad
- Regeneración de vida y mana
- Penalizaciones por muerte

**API Principal**:
```lua
PlayerStats.InitializePlayer(player)
PlayerStats.GetStats(player)
PlayerStats.AddExperience(player, amount)
PlayerStats.Heal(player, amount)
PlayerStats.UseMana(player, amount)
```

#### `InventorySystem.lua`
**Propósito**: Sistema completo de inventario y equipamiento.

**Características**:
- 30 slots de inventario
- Items apilables y no apilables
- Sistema de equipamiento
- Efectos de items equipados
- Uso de consumibles

**API Principal**:
```lua
InventorySystem.InitializePlayer(player)
InventorySystem.AddItem(player, itemName, quantity)
InventorySystem.EquipItem(player, slot)
InventorySystem.UseConsumable(player, slot)
```

#### `CombatSystem.lua`
**Propósito**: Sistema de combate y habilidades.

**Características**:
- Ataques básicos con cooldown
- Sistema de habilidades mágicas
- Cálculo de daño con críticos
- Sistema de buffs y debuffs
- Efectos visuales de combate

**API Principal**:
```lua
CombatSystem.InitializePlayer(player)
CombatSystem.BasicAttack(attacker, target)
CombatSystem.UseSkill(player, skillName, target)
CombatSystem.CalculateDamage(attacker, target, damageType)
```

#### `ItemDatabase.lua`
**Propósito**: Base de datos completa de items del juego.

**Características**:
- 20+ items predefinidos
- 5 niveles de rareza
- Sistema de tipos de items
- Valores de items para economía
- Funciones de búsqueda y filtrado

**Estructura de Items**:
```lua
{
    Name = "Item Name",
    Type = "Weapon/Armor/Consumable/Material",
    Rarity = "Common/Uncommon/Rare/Epic/Legendary",
    Damage = 15, -- Para armas
    Defense = 5, -- Para armadura
    HealAmount = 50, -- Para consumibles
    Stackable = true/false,
    Equippable = true/false,
    Value = 100 -- Precio en oro
}
```

#### `SkillDatabase.lua`
**Propósito**: Base de datos de habilidades mágicas.

**Características**:
- 15+ habilidades predefinidas
- 4 tipos de habilidades (Ofensiva, Defensiva, Soporte, Utilidad)
- 7 elementos mágicos
- Sistema de niveles requeridos
- Costos de mana y cooldowns

**Estructura de Habilidades**:
```lua
{
    Name = "Skill Name",
    Type = "Offensive/Defensive/Support/Utility",
    Element = "Fire/Ice/Lightning/Earth/Water/Dark/Light",
    ManaCost = 20,
    Damage = 40,
    Range = 15,
    Cooldown = 3.0,
    LevelRequired = 5,
    ExperienceCost = 500
}
```

#### `QuestSystem.lua`
**Propósito**: Sistema completo de quests y misiones.

**Características**:
- 8 quests predefinidas
- 8 tipos de objetivos diferentes
- Sistema de prerrequisitos
- Recompensas variadas
- Seguimiento de progreso

**Tipos de Objetivos**:
- `KillEnemies`: Matar enemigos
- `CollectItems`: Recolectar items
- `ReachLocation`: Llegar a ubicación
- `TalkToNPC`: Hablar con NPC
- `CompleteDungeon`: Completar mazmorra
- `UseSkill`: Usar habilidad
- `EquipItem`: Equipar item
- `ReachLevel`: Alcanzar nivel

### 🔄 Módulos Compartidos (ReplicatedStorage/Modules)

#### `SharedConfig.lua`
**Propósito**: Configuración compartida entre servidor y cliente.

**Secciones**:
- `GAME`: Configuración general
- `EXPERIENCE`: Sistema de experiencia
- `COMBAT`: Configuración de combate
- `INVENTORY`: Configuración de inventario
- `GUI`: Configuración de interfaz
- `CONTROLS`: Controles del juego
- `COLORS`: Paleta de colores
- `RARITIES`: Configuración de rarezas
- `ELEMENTS`: Elementos mágicos

### 👤 Cliente (StarterPlayer/StarterPlayerScripts)

#### `ClientMain.client.lua`
**Propósito**: Script principal del cliente que maneja la interfaz y eventos.

**Responsabilidades**:
- Crear y manejar la GUI principal
- Procesar eventos de teclado
- Comunicarse con el servidor via RemoteEvents
- Actualizar la interfaz en tiempo real
- Manejar interacciones del usuario

**Controles**:
- `Tab`: Toggle GUI principal
- `I`: Abrir inventario
- `C`: Abrir estadísticas
- `K`: Abrir habilidades
- `Q`: Abrir quests

#### `GUISystem.lua`
**Propósito**: Módulo de utilidades para crear elementos de GUI.

**Funciones Principales**:
- `CreateRoundedFrame()`: Crear frames con esquinas redondeadas
- `CreateStyledButton()`: Crear botones con estilo
- `CreateInventorySlot()`: Crear slots de inventario
- `CreateSkillButton()`: Crear botones de habilidades
- `CreateNotification()`: Crear notificaciones
- `CreateTooltip()`: Crear tooltips

## 🔗 Flujo de Datos

### Inicialización del Jugador

```
1. PlayerAdded → MainServer.server.lua
2. InitializePlayer() → Todos los módulos
3. SetupRegeneration() → Regeneración automática
4. SetupCombatEvents() → Eventos de combate
5. PlayerData[UserId] → Datos del jugador
```

### Comunicación Cliente-Servidor

```
Cliente                    Servidor
  │                          │
  ├─ AttackEvent ──────────► ServerEvents.server.lua
  │                          ├─ CombatSystem.BasicAttack()
  │                          └─ Response via RemoteEvent
  │
  ├─ SkillEvent ───────────► ServerEvents.server.lua
  │                          ├─ CombatSystem.UseSkill()
  │                          └─ Response via RemoteEvent
  │
  ├─ EquipItemEvent ───────► ServerEvents.server.lua
  │                          ├─ InventorySystem.EquipItem()
  │                          └─ Response via RemoteEvent
```

### Flujo de Combate

```
1. Cliente presiona tecla de ataque
2. ClientMain detecta input
3. Envía AttackEvent al servidor
4. ServerEvents procesa el evento
5. CombatSystem calcula daño
6. PlayerStats aplica daño
7. Servidor responde con resultado
8. Cliente muestra efectos visuales
```

## 🎨 Sistema de GUI

### Estructura de la GUI Principal

```
ScreenGui (RPGMainGUI)
└── MainFrame
    ├── TitleBar
    │   ├── TitleLabel
    │   └── CloseButton
    └── ContentFrame
        ├── TabFrame
        │   ├── StatsTab
        │   ├── InventoryTab
        │   ├── SkillsTab
        │   └── QuestsTab
        └── TabContentFrame
            ├── StatsFrame
            ├── InventoryFrame
            ├── SkillsFrame
            └── QuestsFrame
```

### Componentes de GUI

#### StatsFrame
- **ScrollFrame** con lista de estadísticas
- **UIListLayout** para organización vertical
- **Frames** individuales para cada stat
- **Labels** para nombres y valores

#### InventoryFrame
- **ScrollFrame** con grid de inventario
- **UIGridLayout** para organización en cuadrícula
- **Frames** para cada slot de inventario
- **ImageLabels** para iconos de items
- **Labels** para cantidades

#### SkillsFrame
- **ScrollFrame** con lista de habilidades
- **UIListLayout** para organización vertical
- **Frames** para cada habilidad
- **Labels** para nombres, descripciones y cooldowns

#### QuestsFrame
- **ScrollFrame** con lista de quests
- **UIListLayout** para organización vertical
- **Frames** para cada quest
- **Labels** para nombres, descripciones y progreso

## 🔧 Configuración de Rojo

### `default.project.json`

```json
{
  "name": "roblox-rpg-project",
  "tree": {
    "$className": "DataModel",
    "ServerScriptService": {
      "$className": "ServerScriptService",
      "ServerCore": {
        "$path": "src/ServerScriptService/ServerCore"
      }
    },
    "ServerStorage": {
      "$className": "ServerStorage",
      "Modules": {
        "$path": "src/ServerStorage/Modules"
      }
    },
    "ReplicatedStorage": {
      "$className": "ReplicatedStorage",
      "Modules": {
        "$path": "src/ReplicatedStorage/Modules"
      }
    },
    "StarterPlayer": {
      "$className": "StarterPlayer",
      "StarterPlayerScripts": {
        "$className": "StarterPlayerScripts",
        "$path": "src/StarterPlayer/StarterPlayerScripts"
      }
    },
    "StarterGui": {
      "$className": "StarterGui",
      "RPGGUI": {
        "$path": "src/StarterGui/RPGGUI"
      }
    }
  }
}
```

## 📊 Flujo de Datos de Persistencia

### Guardado de Datos

```
1. Auto-guardado cada 60 segundos
2. PlayerRemoving → SavePlayerData()
3. Datos del jugador → DataStore (futuro)
4. Confirmación de guardado
```

### Carga de Datos

```
1. PlayerAdded → LoadPlayerData()
2. DataStore → Datos del jugador (futuro)
3. InitializePlayer() → Aplicar datos cargados
4. Confirmación de carga
```

## 🎯 Extensiones Futuras

### Estructura Preparada Para

1. **Sistema de DataStore**:
   - Guardado persistente de datos
   - Sincronización entre servidores

2. **Sistema de Comercio**:
   - Intercambio entre jugadores
   - Economía del juego

3. **Sistema de Gremios**:
   - Organizaciones de jugadores
   - Quests grupales

4. **Sistema de Crafting**:
   - Creación de items
   - Recetas y materiales

5. **Sistema de Dungeons**:
   - Mazmorras instanciadas
   - Contenido cooperativo

## 🔍 Debugging y Logging

### Mensajes de Debug

- **Servidor**: `print()` statements en módulos
- **Cliente**: `print()` statements en scripts del cliente
- **Errores**: Capturados en consola de Roblox Studio

### Puntos de Verificación

1. **Inicialización**: Verificar que todos los módulos se carguen
2. **Eventos**: Verificar que RemoteEvents funcionen
3. **GUI**: Verificar que la interfaz se muestre correctamente
4. **Datos**: Verificar que los datos se actualicen en tiempo real

---

**Esta estructura modular permite fácil mantenimiento, extensión y colaboración en el desarrollo del proyecto RPG.**
