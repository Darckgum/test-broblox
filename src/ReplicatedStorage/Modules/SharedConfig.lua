-- Configuración Compartida para RPG
-- Configuración que se comparte entre servidor y cliente

local SharedConfig = {}

-- Configuración general del juego
SharedConfig.GAME = {
    Name = "RPG Adventure",
    Version = "1.0.0",
    MaxPlayers = 20,
    RespawnTime = 5,
    MaxLevel = 100
}

-- Configuración de experiencia
SharedConfig.EXPERIENCE = {
    BaseExpToNext = 100,
    ExpMultiplier = 1.2,
    ExpLossOnDeath = 0.1,
    MaxExpLoss = 1000
}

-- Configuración de combate
SharedConfig.COMBAT = {
    AttackRange = 10,
    CriticalChance = 0.1,
    CriticalMultiplier = 2.0,
    BlockChance = 0.15,
    DodgeChance = 0.1,
    AttackCooldown = 1.0,
    SkillCooldown = 5.0,
    MaxCombatDistance = 50
}

-- Configuración de inventario
SharedConfig.INVENTORY = {
    MaxSlots = 30,
    MaxStackSize = 99,
    DropDistance = 5,
    PickupRange = 10
}

-- Configuración de regeneración
SharedConfig.REGENERATION = {
    ManaRegenRate = 1,
    HealthRegenRate = 0.5,
    RegenInterval = 1,
    CombatRegenDelay = 5
}

-- Configuración de GUI
SharedConfig.GUI = {
    MainFrameSize = UDim2.new(0, 400, 0, 500),
    InventoryFrameSize = UDim2.new(0, 600, 0, 400),
    SkillFrameSize = UDim2.new(0, 500, 0, 300),
    AnimationDuration = 0.3,
    NotificationDuration = 3
}

-- Configuración de controles
SharedConfig.CONTROLS = {
    ToggleGUI = Enum.KeyCode.Tab,
    OpenInventory = Enum.KeyCode.I,
    OpenStats = Enum.KeyCode.C,
    OpenSkills = Enum.KeyCode.K,
    OpenQuests = Enum.KeyCode.Q,
    Attack = Enum.KeyCode.F,
    UseSkill1 = Enum.KeyCode.One,
    UseSkill2 = Enum.KeyCode.Two,
    UseSkill3 = Enum.KeyCode.Three,
    UseSkill4 = Enum.KeyCode.Four
}

-- Configuración de colores
SharedConfig.COLORS = {
    Background = Color3.fromRGB(40, 40, 40),
    Secondary = Color3.fromRGB(60, 60, 60),
    Accent = Color3.fromRGB(80, 80, 80),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    Success = Color3.fromRGB(100, 255, 100),
    Warning = Color3.fromRGB(255, 255, 100),
    Error = Color3.fromRGB(255, 100, 100),
    Info = Color3.fromRGB(100, 200, 255),
    Experience = Color3.fromRGB(100, 200, 255),
    Health = Color3.fromRGB(255, 100, 100),
    Mana = Color3.fromRGB(100, 100, 255),
    Gold = Color3.fromRGB(255, 215, 0)
}

-- Configuración de rarezas
SharedConfig.RARITIES = {
    COMMON = {
        Name = "Common",
        Color = Color3.fromRGB(255, 255, 255),
        DropRate = 0.7
    },
    UNCOMMON = {
        Name = "Uncommon",
        Color = Color3.fromRGB(100, 255, 100),
        DropRate = 0.2
    },
    RARE = {
        Name = "Rare",
        Color = Color3.fromRGB(100, 100, 255),
        DropRate = 0.07
    },
    EPIC = {
        Name = "Epic",
        Color = Color3.fromRGB(200, 100, 255),
        DropRate = 0.025
    },
    LEGENDARY = {
        Name = "Legendary",
        Color = Color3.fromRGB(255, 215, 0),
        DropRate = 0.005
    }
}

-- Configuración de elementos
SharedConfig.ELEMENTS = {
    FIRE = {
        Name = "Fire",
        Color = Color3.fromRGB(255, 100, 100),
        Weakness = "Ice",
        Resistance = "Fire"
    },
    ICE = {
        Name = "Ice",
        Color = Color3.fromRGB(100, 200, 255),
        Weakness = "Fire",
        Resistance = "Ice"
    },
    LIGHTNING = {
        Name = "Lightning",
        Color = Color3.fromRGB(255, 255, 100),
        Weakness = "Earth",
        Resistance = "Lightning"
    },
    EARTH = {
        Name = "Earth",
        Color = Color3.fromRGB(139, 69, 19),
        Weakness = "Lightning",
        Resistance = "Earth"
    },
    WATER = {
        Name = "Water",
        Color = Color3.fromRGB(100, 150, 255),
        Weakness = "Lightning",
        Resistance = "Water"
    },
    DARK = {
        Name = "Dark",
        Color = Color3.fromRGB(100, 100, 100),
        Weakness = "Light",
        Resistance = "Dark"
    },
    LIGHT = {
        Name = "Light",
        Color = Color3.fromRGB(255, 255, 200),
        Weakness = "Dark",
        Resistance = "Light"
    }
}

-- Configuración de tipos de items
SharedConfig.ITEM_TYPES = {
    WEAPON = "Weapon",
    ARMOR = "Armor",
    CONSUMABLE = "Consumable",
    MATERIAL = "Material",
    QUEST = "Quest",
    ACCESSORY = "Accessory"
}

-- Configuración de tipos de habilidades
SharedConfig.SKILL_TYPES = {
    OFFENSIVE = "Offensive",
    DEFENSIVE = "Defensive",
    SUPPORT = "Support",
    UTILITY = "Utility"
}

-- Configuración de estados de quest
SharedConfig.QUEST_STATES = {
    NOT_STARTED = "NotStarted",
    IN_PROGRESS = "InProgress",
    COMPLETED = "Completed",
    FAILED = "Failed",
    REWARDED = "Rewarded"
}

-- Configuración de tipos de objetivos de quest
SharedConfig.QUEST_OBJECTIVES = {
    KILL_ENEMIES = "KillEnemies",
    COLLECT_ITEMS = "CollectItems",
    REACH_LOCATION = "ReachLocation",
    TALK_TO_NPC = "TalkToNPC",
    COMPLETE_DUNGEON = "CompleteDungeon",
    USE_SKILL = "UseSkill",
    EQUIP_ITEM = "EquipItem",
    REACH_LEVEL = "ReachLevel"
}

-- Configuración de tipos de recompensas
SharedConfig.REWARD_TYPES = {
    EXPERIENCE = "Experience",
    GOLD = "Gold",
    ITEM = "Item",
    SKILL = "Skill",
    STAT_POINTS = "StatPoints"
}

-- Configuración de animaciones
SharedConfig.ANIMATIONS = {
    Attack = "rbxassetid://0",
    Cast = "rbxassetid://0",
    Heal = "rbxassetid://0",
    Death = "rbxassetid://0",
    Idle = "rbxassetid://0",
    Walk = "rbxassetid://0",
    Run = "rbxassetid://0"
}

-- Configuración de sonidos
SharedConfig.SOUNDS = {
    Attack = "rbxassetid://0",
    Hit = "rbxassetid://0",
    LevelUp = "rbxassetid://0",
    ItemPickup = "rbxassetid://0",
    QuestComplete = "rbxassetid://0",
    SkillCast = "rbxassetid://0",
    Death = "rbxassetid://0"
}

-- Configuración de efectos visuales
SharedConfig.EFFECTS = {
    Damage = "rbxassetid://0",
    Heal = "rbxassetid://0",
    Critical = "rbxassetid://0",
    LevelUp = "rbxassetid://0",
    QuestComplete = "rbxassetid://0",
    SkillCast = "rbxassetid://0"
}

-- Configuración de NPCs
SharedConfig.NPCS = {
    MERCHANT = {
        Name = "Merchant",
        Model = "rbxassetid://0",
        Dialogue = "Welcome to my shop!"
    },
    QUEST_GIVER = {
        Name = "Quest Giver",
        Model = "rbxassetid://0",
        Dialogue = "I have a quest for you!"
    },
    TRAINER = {
        Name = "Trainer",
        Model = "rbxassetid://0",
        Dialogue = "Let me help you improve your skills!"
    }
}

-- Configuración de enemigos
SharedConfig.ENEMIES = {
    GOBLIN = {
        Name = "Goblin",
        Level = 1,
        Health = 50,
        Damage = 10,
        Experience = 25,
        DropRate = 0.3
    },
    ORC = {
        Name = "Orc",
        Level = 5,
        Health = 150,
        Damage = 25,
        Experience = 75,
        DropRate = 0.4
    },
    DRAGON = {
        Name = "Dragon",
        Level = 20,
        Health = 1000,
        Damage = 100,
        Experience = 500,
        DropRate = 0.8
    }
}

-- Configuración de dungeons
SharedConfig.DUNGEONS = {
    TUTORIAL = {
        Name = "Tutorial Dungeon",
        Level = 1,
        MaxPlayers = 1,
        Duration = 300,
        Rewards = {
            Experience = 100,
            Gold = 50,
            Items = {{"Health Potion", 3}}
        }
    },
    FOREST = {
        Name = "Forest Dungeon",
        Level = 5,
        MaxPlayers = 4,
        Duration = 600,
        Rewards = {
            Experience = 300,
            Gold = 150,
            Items = {{"Steel Sword", 1}}
        }
    }
}

-- Configuración de eventos
SharedConfig.EVENTS = {
    DOUBLE_EXP = {
        Name = "Double Experience",
        Duration = 3600,
        Multiplier = 2.0,
        Active = false
    },
    DOUBLE_GOLD = {
        Name = "Double Gold",
        Duration = 3600,
        Multiplier = 2.0,
        Active = false
    },
    RARE_DROPS = {
        Name = "Increased Rare Drops",
        Duration = 1800,
        Multiplier = 3.0,
        Active = false
    }
}

-- Función para obtener configuración por categoría
function SharedConfig.GetConfig(category)
    return SharedConfig[category]
end

-- Función para obtener configuración específica
function SharedConfig.GetValue(category, key)
    local config = SharedConfig[category]
    if config then
        return config[key]
    end
    return nil
end

-- Función para verificar si una configuración existe
function SharedConfig.HasConfig(category, key)
    local config = SharedConfig[category]
    if config then
        return config[key] ~= nil
    end
    return false
end

-- Función para obtener color de rareza
function SharedConfig.GetRarityColor(rarity)
    local rarityConfig = SharedConfig.RARITIES[rarity]
    if rarityConfig then
        return rarityConfig.Color
    end
    return SharedConfig.COLORS.Text
end

-- Función para obtener color de elemento
function SharedConfig.GetElementColor(element)
    local elementConfig = SharedConfig.ELEMENTS[element]
    if elementConfig then
        return elementConfig.Color
    end
    return SharedConfig.COLORS.Text
end

-- Función para verificar si un evento está activo
function SharedConfig.IsEventActive(eventName)
    local event = SharedConfig.EVENTS[eventName]
    if event then
        return event.Active
    end
    return false
end

-- Función para obtener multiplicador de evento
function SharedConfig.GetEventMultiplier(eventName)
    local event = SharedConfig.EVENTS[eventName]
    if event and event.Active then
        return event.Multiplier
    end
    return 1.0
end

return SharedConfig
