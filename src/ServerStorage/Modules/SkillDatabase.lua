-- Base de Datos de Habilidades para RPG
-- Contiene todas las habilidades disponibles en el juego

local SkillDatabase = {}

-- Tipos de habilidades
SkillDatabase.TYPES = {
    OFFENSIVE = "Offensive",
    DEFENSIVE = "Defensive",
    SUPPORT = "Support",
    UTILITY = "Utility"
}

-- Elementos
SkillDatabase.ELEMENTS = {
    FIRE = "Fire",
    ICE = "Ice",
    LIGHTNING = "Lightning",
    EARTH = "Earth",
    WATER = "Water",
    DARK = "Dark",
    LIGHT = "Light",
    PHYSICAL = "Physical"
}

-- Base de datos de habilidades
SkillDatabase.SKILLS = {
    -- Habilidades de Fuego
    ["Fireball"] = {
        Name = "Fireball",
        Type = SkillDatabase.TYPES.OFFENSIVE,
        Element = SkillDatabase.ELEMENTS.FIRE,
        ManaCost = 20,
        Damage = 40,
        Range = 15,
        Cooldown = 3.0,
        Description = "Lanza una bola de fuego que causa daño mágico",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Animation = "rbxassetid://0",
        LevelRequired = 1,
        ExperienceCost = 0
    },
    
    ["Fire Storm"] = {
        Name = "Fire Storm",
        Type = SkillDatabase.TYPES.OFFENSIVE,
        Element = SkillDatabase.ELEMENTS.FIRE,
        ManaCost = 50,
        Damage = 80,
        Range = 20,
        Cooldown = 8.0,
        Description = "Crea una tormenta de fuego que daña a múltiples enemigos",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Animation = "rbxassetid://0",
        LevelRequired = 10,
        ExperienceCost = 1000
    },
    
    -- Habilidades de Curación
    ["Heal"] = {
        Name = "Heal",
        Type = SkillDatabase.TYPES.SUPPORT,
        Element = SkillDatabase.ELEMENTS.LIGHT,
        ManaCost = 15,
        HealAmount = 60,
        Range = 0,
        Cooldown = 4.0,
        Description = "Restaura puntos de vida",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Animation = "rbxassetid://0",
        LevelRequired = 1,
        ExperienceCost = 0
    },
    
    ["Greater Heal"] = {
        Name = "Greater Heal",
        Type = SkillDatabase.TYPES.SUPPORT,
        Element = SkillDatabase.ELEMENTS.LIGHT,
        ManaCost = 35,
        HealAmount = 150,
        Range = 0,
        Cooldown = 6.0,
        Description = "Restaura una gran cantidad de puntos de vida",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Animation = "rbxassetid://0",
        LevelRequired = 8,
        ExperienceCost = 800
    },
    
    -- Habilidades de Rayo
    ["Lightning Strike"] = {
        Name = "Lightning Strike",
        Type = SkillDatabase.TYPES.OFFENSIVE,
        Element = SkillDatabase.ELEMENTS.LIGHTNING,
        ManaCost = 30,
        Damage = 60,
        Range = 20,
        Cooldown = 6.0,
        Description = "Golpea con un rayo que causa daño masivo",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Animation = "rbxassetid://0",
        LevelRequired = 5,
        ExperienceCost = 500
    },
    
    ["Chain Lightning"] = {
        Name = "Chain Lightning",
        Type = SkillDatabase.TYPES.OFFENSIVE,
        Element = SkillDatabase.ELEMENTS.LIGHTNING,
        ManaCost = 40,
        Damage = 50,
        Range = 15,
        Cooldown = 7.0,
        Description = "Un rayo que salta entre múltiples enemigos",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Animation = "rbxassetid://0",
        LevelRequired = 12,
        ExperienceCost = 1200
    },
    
    -- Habilidades Defensivas
    ["Shield"] = {
        Name = "Shield",
        Type = SkillDatabase.TYPES.DEFENSIVE,
        Element = SkillDatabase.ELEMENTS.LIGHT,
        ManaCost = 25,
        Duration = 10.0,
        DefenseBonus = 20,
        Cooldown = 15.0,
        Description = "Aumenta la defensa temporalmente",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Animation = "rbxassetid://0",
        LevelRequired = 3,
        ExperienceCost = 300
    },
    
    ["Magic Barrier"] = {
        Name = "Magic Barrier",
        Type = SkillDatabase.TYPES.DEFENSIVE,
        Element = SkillDatabase.ELEMENTS.LIGHT,
        ManaCost = 40,
        Duration = 15.0,
        DefenseBonus = 35,
        MagicResistance = 50,
        Cooldown = 20.0,
        Description = "Crea una barrera mágica que reduce el daño recibido",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Animation = "rbxassetid://0",
        LevelRequired = 15,
        ExperienceCost = 1500
    },
    
    -- Habilidades de Hielo
    ["Ice Shard"] = {
        Name = "Ice Shard",
        Type = SkillDatabase.TYPES.OFFENSIVE,
        Element = SkillDatabase.ELEMENTS.ICE,
        ManaCost = 25,
        Damage = 35,
        Range = 12,
        Cooldown = 4.0,
        SlowEffect = 0.5,
        SlowDuration = 3.0,
        Description = "Lanza una esquirlas de hielo que ralentiza al enemigo",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Animation = "rbxassetid://0",
        LevelRequired = 6,
        ExperienceCost = 600
    },
    
    ["Blizzard"] = {
        Name = "Blizzard",
        Type = SkillDatabase.TYPES.OFFENSIVE,
        Element = SkillDatabase.ELEMENTS.ICE,
        ManaCost = 60,
        Damage = 100,
        Range = 25,
        Cooldown = 12.0,
        SlowEffect = 0.3,
        SlowDuration = 5.0,
        Description = "Crea una ventisca que daña y ralentiza a todos los enemigos en el área",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Animation = "rbxassetid://0",
        LevelRequired = 18,
        ExperienceCost = 1800
    },
    
    -- Habilidades de Tierra
    ["Earth Spike"] = {
        Name = "Earth Spike",
        Type = SkillDatabase.TYPES.OFFENSIVE,
        Element = SkillDatabase.ELEMENTS.EARTH,
        ManaCost = 30,
        Damage = 45,
        Range = 10,
        Cooldown = 5.0,
        Description = "Hace emerger una estaca de tierra del suelo",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Animation = "rbxassetid://0",
        LevelRequired = 7,
        ExperienceCost = 700
    },
    
    -- Habilidades de Utilidad
    ["Teleport"] = {
        Name = "Teleport",
        Type = SkillDatabase.TYPES.UTILITY,
        Element = SkillDatabase.ELEMENTS.LIGHT,
        ManaCost = 20,
        Range = 30,
        Cooldown = 10.0,
        Description = "Teletransporta al jugador a una ubicación cercana",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Animation = "rbxassetid://0",
        LevelRequired = 9,
        ExperienceCost = 900
    },
    
    ["Mana Shield"] = {
        Name = "Mana Shield",
        Type = SkillDatabase.TYPES.DEFENSIVE,
        Element = SkillDatabase.ELEMENTS.LIGHT,
        ManaCost = 0,
        Duration = 8.0,
        ManaPerDamage = 2,
        Cooldown = 12.0,
        Description = "Convierte el daño recibido en pérdida de mana",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Animation = "rbxassetid://0",
        LevelRequired = 14,
        ExperienceCost = 1400
    },
    
    -- Habilidades de Oscuridad
    ["Shadow Bolt"] = {
        Name = "Shadow Bolt",
        Type = SkillDatabase.TYPES.OFFENSIVE,
        Element = SkillDatabase.ELEMENTS.DARK,
        ManaCost = 35,
        Damage = 55,
        Range = 18,
        Cooldown = 5.0,
        Description = "Lanza un rayo de energía oscura",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Animation = "rbxassetid://0",
        LevelRequired = 11,
        ExperienceCost = 1100
    },
    
    ["Life Drain"] = {
        Name = "Life Drain",
        Type = SkillDatabase.TYPES.OFFENSIVE,
        Element = SkillDatabase.ELEMENTS.DARK,
        ManaCost = 25,
        Damage = 30,
        HealAmount = 30,
        Range = 12,
        Cooldown = 6.0,
        Description = "Drena la vida del enemigo y la transfiere al jugador",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Animation = "rbxassetid://0",
        LevelRequired = 13,
        ExperienceCost = 1300
    }
}

-- Función para obtener habilidad por nombre
function SkillDatabase.GetSkill(skillName)
    return SkillDatabase.SKILLS[skillName]
end

-- Función para obtener todas las habilidades
function SkillDatabase.GetAllSkills()
    return SkillDatabase.SKILLS
end

-- Función para obtener habilidades por tipo
function SkillDatabase.GetSkillsByType(skillType)
    local skills = {}
    for name, data in pairs(SkillDatabase.SKILLS) do
        if data.Type == skillType then
            skills[name] = data
        end
    end
    return skills
end

-- Función para obtener habilidades por elemento
function SkillDatabase.GetSkillsByElement(element)
    local skills = {}
    for name, data in pairs(SkillDatabase.SKILLS) do
        if data.Element == element then
            skills[name] = data
        end
    end
    return skills
end

-- Función para obtener habilidades por nivel requerido
function SkillDatabase.GetSkillsByLevel(level)
    local skills = {}
    for name, data in pairs(SkillDatabase.SKILLS) do
        if data.LevelRequired <= level then
            skills[name] = data
        end
    end
    return skills
end

-- Función para obtener habilidades ofensivas
function SkillDatabase.GetOffensiveSkills()
    return SkillDatabase.GetSkillsByType(SkillDatabase.TYPES.OFFENSIVE)
end

-- Función para obtener habilidades defensivas
function SkillDatabase.GetDefensiveSkills()
    return SkillDatabase.GetSkillsByType(SkillDatabase.TYPES.DEFENSIVE)
end

-- Función para obtener habilidades de apoyo
function SkillDatabase.GetSupportSkills()
    return SkillDatabase.GetSkillsByType(SkillDatabase.TYPES.SUPPORT)
end

-- Función para obtener habilidades de utilidad
function SkillDatabase.GetUtilitySkills()
    return SkillDatabase.GetSkillsByType(SkillDatabase.TYPES.UTILITY)
end

-- Función para verificar si una habilidad existe
function SkillDatabase.SkillExists(skillName)
    return SkillDatabase.SKILLS[skillName] ~= nil
end

-- Función para obtener habilidades disponibles para aprender
function SkillDatabase.GetLearnableSkills(playerLevel, playerExperience)
    local learnableSkills = {}
    for name, data in pairs(SkillDatabase.SKILLS) do
        if data.LevelRequired <= playerLevel and data.ExperienceCost <= playerExperience then
            learnableSkills[name] = data
        end
    end
    return learnableSkills
end

-- Función para calcular el costo total de aprender todas las habilidades
function SkillDatabase.GetTotalSkillCost()
    local totalCost = 0
    for name, data in pairs(SkillDatabase.SKILLS) do
        totalCost = totalCost + data.ExperienceCost
    end
    return totalCost
end

-- Función para obtener habilidades por rango de daño
function SkillDatabase.GetSkillsByDamageRange(minDamage, maxDamage)
    local skills = {}
    for name, data in pairs(SkillDatabase.SKILLS) do
        if data.Damage and data.Damage >= minDamage and data.Damage <= maxDamage then
            skills[name] = data
        end
    end
    return skills
end

-- Función para obtener habilidades por costo de mana
function SkillDatabase.GetSkillsByManaCost(maxManaCost)
    local skills = {}
    for name, data in pairs(SkillDatabase.SKILLS) do
        if data.ManaCost <= maxManaCost then
            skills[name] = data
        end
    end
    return skills
end

return SkillDatabase
