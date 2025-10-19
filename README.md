# 🎮 Proyecto RPG Completo para Roblox Studio

Un sistema RPG completo y profesional desarrollado con Rojo para Roblox Studio, que incluye todas las características esenciales de un juego de rol.

## 📋 Tabla de Contenidos

- [Características](#-características)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Instalación](#-instalación)
- [Uso](#-uso)
- [API](#-api)
- [Contribución](#-contribución)
- [Licencia](#-licencia)

## ✨ Características

### 🎯 Sistema de Estadísticas
- **Niveles y Experiencia**: Sistema de progresión con niveles ilimitados
- **Atributos**: Fuerza, Defensa, Inteligencia, Velocidad, Suerte
- **Puntos de Habilidad**: Sistema para mejorar atributos
- **Regeneración**: Regeneración automática de vida y mana

### 🎒 Sistema de Inventario
- **30 Slots**: Inventario expandible con 30 espacios
- **Items Apilables**: Sistema de stacks para consumibles y materiales
- **Equipamiento**: Sistema de armas y armadura con efectos
- **Raridades**: 5 niveles de rareza (Common, Uncommon, Rare, Epic, Legendary)

### ⚔️ Sistema de Combate
- **Ataques Básicos**: Sistema de combate cuerpo a cuerpo
- **Habilidades Mágicas**: 15+ habilidades con diferentes elementos
- **Críticos y Bloques**: Sistema de probabilidades avanzado
- **Cooldowns**: Sistema de enfriamiento para habilidades

### 🎨 Interfaz de Usuario
- **GUI Moderna**: Interfaz limpia y profesional
- **Tabs Organizados**: Stats, Inventario, Habilidades, Quests
- **Notificaciones**: Sistema de notificaciones en tiempo real
- **Tooltips**: Información detallada de items y habilidades

### 🎯 Sistema de Quests
- **8 Quests Incluidas**: Desde tutorial hasta contenido avanzado
- **Objetivos Variados**: Matar enemigos, recolectar items, explorar
- **Recompensas**: Experiencia, oro, items y habilidades
- **Progreso**: Seguimiento automático del progreso

### 🌍 Contenido del Mundo
- **NPCs**: Comerciantes, maestros de quests, entrenadores
- **Enemigos**: Goblins, Orcs, Dragones con IA básica
- **Cofres de Tesoro**: Sistema de loot con items aleatorios
- **Áreas de Spawn**: Zonas de enemigos configurables

## 📁 Estructura del Proyecto

```
testt/
├── src/
│   ├── ServerScriptService/
│   │   └── ServerCore/
│   │       ├── MainServer.server.lua      # Script principal del servidor
│   │       └── ServerEvents.server.lua    # Manejo de eventos
│   ├── ServerStorage/
│   │   └── Modules/
│   │       ├── PlayerStats.lua             # Sistema de estadísticas
│   │       ├── InventorySystem.lua        # Sistema de inventario
│   │       ├── CombatSystem.lua           # Sistema de combate
│   │       ├── ItemDatabase.lua           # Base de datos de items
│   │       ├── SkillDatabase.lua          # Base de datos de habilidades
│   │       └── QuestSystem.lua            # Sistema de quests
│   ├── ReplicatedStorage/
│   │   └── Modules/
│   │       └── SharedConfig.lua           # Configuración compartida
│   ├── StarterPlayer/
│   │   └── StarterPlayerScripts/
│   │       ├── ClientMain.client.lua      # Script principal del cliente
│   │       └── GUISystem.lua              # Sistema de interfaz
│   └── StarterGui/
│       └── RPGGUI/
│           └── MainGUI.lua                # GUI principal
├── default.project.json                   # Configuración de Rojo
├── package.json                           # Metadatos del proyecto
├── .gitignore                             # Archivos a ignorar
├── README.md                              # Este archivo
├── INSTALACION.md                         # Guía de instalación
└── ESTRUCTURA.md                          # Documentación de estructura
```

## 🚀 Instalación

### Prerrequisitos

- **Roblox Studio**: Versión más reciente
- **Rojo**: Herramienta de sincronización
- **Node.js**: Para gestión de dependencias (opcional)

### Pasos de Instalación

1. **Instalar Rojo**:
   ```bash
   npm install -g @rojo/cli
   ```

2. **Clonar el proyecto**:
   ```bash
   git clone <tu-repositorio>
   cd testt
   ```

3. **Sincronizar con Roblox Studio**:
   ```bash
   rojo serve
   ```

4. **Conectar desde Roblox Studio**:
   - Abrir Roblox Studio
   - Instalar el plugin de Rojo
   - Conectar al servidor local

### Configuración Inicial

1. **Abrir Roblox Studio**
2. **Crear un nuevo lugar**
3. **Ejecutar `rojo serve` en la terminal**
4. **Conectar desde Studio usando el plugin de Rojo**

## 🎮 Uso

### Controles del Juego

| Tecla | Acción |
|-------|--------|
| `Tab` | Abrir/Cerrar GUI principal |
| `I` | Abrir inventario |
| `C` | Abrir estadísticas |
| `K` | Abrir habilidades |
| `Q` | Abrir quests |
| `F` | Atacar objetivo |
| `1-4` | Usar habilidades |

### Flujo de Juego

1. **Crear Personaje**: El sistema inicializa automáticamente
2. **Completar Tutorial**: Primera quest para aprender mecánicas
3. **Explorar Mundo**: Encontrar enemigos, cofres y NPCs
4. **Subir de Nivel**: Ganar experiencia y mejorar atributos
5. **Completar Quests**: Seguir la historia principal
6. **Personalizar**: Equipar items y aprender habilidades

## 🔧 API

### PlayerStats

```lua
-- Inicializar jugador
PlayerStats.InitializePlayer(player)

-- Obtener estadísticas
local stats = PlayerStats.GetStats(player)

-- Agregar experiencia
PlayerStats.AddExperience(player, 100)

-- Curar jugador
PlayerStats.Heal(player, 50)

-- Usar mana
PlayerStats.UseMana(player, 20)
```

### InventorySystem

```lua
-- Inicializar inventario
InventorySystem.InitializePlayer(player)

-- Agregar item
InventorySystem.AddItem(player, "Health Potion", 5)

-- Equipar item
InventorySystem.EquipItem(player, slotIndex)

-- Usar consumible
InventorySystem.UseConsumable(player, slotIndex)
```

### CombatSystem

```lua
-- Inicializar combate
CombatSystem.InitializePlayer(player)

-- Ataque básico
CombatSystem.BasicAttack(attacker, target)

-- Usar habilidad
CombatSystem.UseSkill(player, "Fireball", target)
```

### QuestSystem

```lua
-- Inicializar quests
QuestSystem.InitializePlayer(player)

-- Iniciar quest
QuestSystem.StartQuest(player, "First Adventure")

-- Actualizar progreso
QuestSystem.UpdateQuestProgress(player, "First Adventure", 1)
```

## 🎨 Personalización

### Agregar Nuevos Items

1. **Editar `ItemDatabase.lua`**:
   ```lua
   ["Nuevo Item"] = {
       Name = "Nuevo Item",
       Type = ItemDatabase.TYPES.WEAPON,
       Rarity = ItemDatabase.RARITIES.RARE,
       Damage = 30,
       Description = "Un item nuevo",
       Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
       Stackable = false,
       Equippable = true,
       Value = 200
   }
   ```

### Agregar Nuevas Habilidades

1. **Editar `SkillDatabase.lua`**:
   ```lua
   ["Nueva Habilidad"] = {
       Name = "Nueva Habilidad",
       Type = SkillDatabase.TYPES.OFFENSIVE,
       Element = SkillDatabase.ELEMENTS.FIRE,
       ManaCost = 25,
       Damage = 45,
       Range = 15,
       Cooldown = 4.0,
       Description = "Una nueva habilidad",
       Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
       Animation = "rbxassetid://0",
       LevelRequired = 8,
       ExperienceCost = 800
   }
   ```

### Agregar Nuevas Quests

1. **Editar `QuestSystem.lua`**:
   ```lua
   ["Nueva Quest"] = {
       Name = "Nueva Quest",
       Description = "Descripción de la quest",
       Objective = QuestSystem.OBJECTIVE_TYPES.KILL_ENEMIES,
       Target = 10,
       TargetName = "Enemy",
       Reward = {
           Experience = 300,
           Gold = 150,
           Items = {{"Nuevo Item", 1}}
       },
       LevelRequired = 5,
       State = QuestSystem.QUEST_STATES.NOT_STARTED,
       QuestGiver = "NPC_QuestGiver",
       Prerequisites = {}
   }
   ```

## 🐛 Solución de Problemas

### Problemas Comunes

1. **Rojo no se conecta**:
   - Verificar que el servidor esté ejecutándose
   - Comprobar la configuración del firewall
   - Reiniciar Roblox Studio

2. **Scripts no se cargan**:
   - Verificar la estructura de carpetas
   - Comprobar que los módulos estén en la ubicación correcta
   - Revisar la consola de errores

3. **GUI no aparece**:
   - Verificar que el script del cliente esté ejecutándose
   - Comprobar que no haya errores en la consola
   - Reiniciar el juego

### Logs y Debugging

- **Consola del Servidor**: Revisar errores del servidor
- **Consola del Cliente**: Revisar errores del cliente
- **Output**: Mensajes de debug del sistema

## 🤝 Contribución

### Cómo Contribuir

1. **Fork del proyecto**
2. **Crear rama de feature**: `git checkout -b feature/nueva-caracteristica`
3. **Commit cambios**: `git commit -m 'Agregar nueva característica'`
4. **Push a la rama**: `git push origin feature/nueva-caracteristica`
5. **Crear Pull Request**

### Estándares de Código

- **Lua**: Seguir convenciones de Roblox
- **Comentarios**: Documentar funciones complejas
- **Nombres**: Usar nombres descriptivos
- **Estructura**: Mantener organización modular

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 📞 Soporte

- **Issues**: Reportar bugs en GitHub Issues
- **Discusiones**: Usar GitHub Discussions para preguntas
- **Documentación**: Consultar archivos de documentación

## 🎉 Agradecimientos

- **Roblox Corporation**: Por la plataforma
- **Rojo Team**: Por la herramienta de sincronización
- **Comunidad Roblox**: Por el apoyo y feedback

---

**¡Disfruta creando tu RPG! 🎮✨**
