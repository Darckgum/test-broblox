-- Sistema de Quests para RPG
-- Maneja todas las quests disponibles en el juego

local QuestSystem = {}

-- Tipos de objetivos
QuestSystem.OBJECTIVE_TYPES = {
    KILL_ENEMIES = "KillEnemies",
    COLLECT_ITEMS = "CollectItems",
    REACH_LOCATION = "ReachLocation",
    TALK_TO_NPC = "TalkToNPC",
    COMPLETE_DUNGEON = "CompleteDungeon",
    USE_SKILL = "UseSkill",
    EQUIP_ITEM = "EquipItem",
    REACH_LEVEL = "ReachLevel"
}

-- Estados de quest
QuestSystem.QUEST_STATES = {
    NOT_STARTED = "NotStarted",
    IN_PROGRESS = "InProgress",
    COMPLETED = "Completed",
    FAILED = "Failed",
    REWARDED = "Rewarded"
}

-- Tipos de recompensas
QuestSystem.REWARD_TYPES = {
    EXPERIENCE = "Experience",
    GOLD = "Gold",
    ITEM = "Item",
    SKILL = "Skill",
    STAT_POINTS = "StatPoints"
}

-- Base de datos de quests
QuestSystem.QUESTS = {
    -- Quest inicial
    ["First Adventure"] = {
        Name = "Primera Aventura",
        Description = "Derrota a 5 enemigos para probar tu valía como aventurero",
        Objective = QuestSystem.OBJECTIVE_TYPES.KILL_ENEMIES,
        Target = 5,
        TargetName = "Enemy",
        Reward = {
            Experience = 100,
            Gold = 50,
            Items = {{"Health Potion", 3}}
        },
        LevelRequired = 1,
        State = QuestSystem.QUEST_STATES.NOT_STARTED,
        QuestGiver = "NPC_Tutorial",
        Prerequisites = {}
    },
    
    -- Quest de recolección
    ["Collector"] = {
        Name = "Coleccionista",
        Description = "Recolecta 10 Iron Ore para el herrero del pueblo",
        Objective = QuestSystem.OBJECTIVE_TYPES.COLLECT_ITEMS,
        Target = 10,
        TargetName = "Iron Ore",
        Reward = {
            Experience = 200,
            Gold = 100,
            Items = {{"Steel Sword", 1}}
        },
        LevelRequired = 2,
        State = QuestSystem.QUEST_STATES.NOT_STARTED,
        QuestGiver = "NPC_Blacksmith",
        Prerequisites = {"First Adventure"}
    },
    
    -- Quest de exploración
    ["Dungeon Explorer"] = {
        Name = "Explorador de Mazmorras",
        Description = "Completa tu primera mazmorra y derrota al jefe final",
        Objective = QuestSystem.OBJECTIVE_TYPES.COMPLETE_DUNGEON,
        Target = 1,
        TargetName = "Tutorial Dungeon",
        Reward = {
            Experience = 500,
            Gold = 250,
            Items = {{"Magic Staff", 1}, {"Greater Health Potion", 5}}
        },
        LevelRequired = 5,
        State = QuestSystem.QUEST_STATES.NOT_STARTED,
        QuestGiver = "NPC_DungeonMaster",
        Prerequisites = {"Collector"}
    },
    
    -- Quest de nivel
    ["Rising Star"] = {
        Name = "Estrella en Ascenso",
        Description = "Alcanza el nivel 10 para demostrar tu crecimiento",
        Objective = QuestSystem.OBJECTIVE_TYPES.REACH_LEVEL,
        Target = 10,
        TargetName = "Level",
        Reward = {
            Experience = 300,
            Gold = 200,
            StatPoints = 5,
            Items = {{"Chain Mail", 1}}
        },
        LevelRequired = 8,
        State = QuestSystem.QUEST_STATES.NOT_STARTED,
        QuestGiver = "NPC_Trainer",
        Prerequisites = {"Dungeon Explorer"}
    },
    
    -- Quest de habilidades
    ["Magic Apprentice"] = {
        Name = "Aprendiz de Magia",
        Description = "Usa la habilidad Fireball 10 veces para dominar el fuego",
        Objective = QuestSystem.OBJECTIVE_TYPES.USE_SKILL,
        Target = 10,
        TargetName = "Fireball",
        Reward = {
            Experience = 250,
            Gold = 150,
            Skills = {{"Fire Storm", 1}}
        },
        LevelRequired = 6,
        State = QuestSystem.QUEST_STATES.NOT_STARTED,
        QuestGiver = "NPC_Mage",
        Prerequisites = {"First Adventure"}
    },
    
    -- Quest de equipamiento
    ["Warrior's Path"] = {
        Name = "Camino del Guerrero",
        Description = "Equipa una espada de acero para seguir el camino del guerrero",
        Objective = QuestSystem.OBJECTIVE_TYPES.EQUIP_ITEM,
        Target = 1,
        TargetName = "Steel Sword",
        Reward = {
            Experience = 150,
            Gold = 100,
            Items = {{"Plate Armor", 1}}
        },
        LevelRequired = 4,
        State = QuestSystem.QUEST_STATES.NOT_STARTED,
        QuestGiver = "NPC_Warrior",
        Prerequisites = {"Collector"}
    },
    
    -- Quest de ubicación
    ["Sacred Grounds"] = {
        Name = "Tierras Sagradas",
        Description = "Visita el templo sagrado en las montañas del norte",
        Objective = QuestSystem.OBJECTIVE_TYPES.REACH_LOCATION,
        Target = 1,
        TargetName = "Sacred Temple",
        Reward = {
            Experience = 400,
            Gold = 300,
            Items = {{"Magic Crystal", 3}}
        },
        LevelRequired = 12,
        State = QuestSystem.QUEST_STATES.NOT_STARTED,
        QuestGiver = "NPC_Priest",
        Prerequisites = {"Rising Star"}
    },
    
    -- Quest de conversación
    ["Merchant's Tale"] = {
        Name = "Historia del Comerciante",
        Description = "Habla con el comerciante para conocer las historias del reino",
        Objective = QuestSystem.OBJECTIVE_TYPES.TALK_TO_NPC,
        Target = 1,
        TargetName = "NPC_Merchant",
        Reward = {
            Experience = 100,
            Gold = 50,
            Items = {{"Elixir of Life", 1}}
        },
        LevelRequired = 3,
        State = QuestSystem.QUEST_STATES.NOT_STARTED,
        QuestGiver = "NPC_Villager",
        Prerequisites = {"First Adventure"}
    }
}

-- Tabla para almacenar progreso de quests de jugadores
local playerQuestProgress = {}

-- Función para inicializar sistema de quests para un jugador
function QuestSystem.InitializePlayer(player)
    playerQuestProgress[player.UserId] = {}
    
    -- Inicializar progreso de todas las quests
    for questName, questData in pairs(QuestSystem.QUESTS) do
        playerQuestProgress[player.UserId][questName] = {
            Progress = 0,
            State = QuestSystem.QUEST_STATES.NOT_STARTED,
            StartTime = 0,
            CompleteTime = 0
        }
    end
    
    print("Sistema de quests inicializado para " .. player.Name)
end

-- Función para obtener quest por nombre
function QuestSystem.GetQuest(questName)
    return QuestSystem.QUESTS[questName]
end

-- Función para obtener todas las quests
function QuestSystem.GetAllQuests()
    return QuestSystem.QUESTS
end

-- Función para obtener quests disponibles para un nivel
function QuestSystem.GetAvailableQuests(level)
    local availableQuests = {}
    for name, quest in pairs(QuestSystem.QUESTS) do
        if quest.LevelRequired <= level and quest.State == QuestSystem.QUEST_STATES.NOT_STARTED then
            -- Verificar prerrequisitos
            local canStart = true
            for _, prereq in ipairs(quest.Prerequisites) do
                local prereqQuest = QuestSystem.GetQuest(prereq)
                if prereqQuest and prereqQuest.State ~= QuestSystem.QUEST_STATES.COMPLETED then
                    canStart = false
                    break
                end
            end
            
            if canStart then
                availableQuests[name] = quest
            end
        end
    end
    return availableQuests
end

-- Función para iniciar una quest
function QuestSystem.StartQuest(player, questName)
    local quest = QuestSystem.QUESTS[questName]
    local playerProgress = playerQuestProgress[player.UserId]
    
    if not quest or not playerProgress then return false end
    
    local questProgress = playerProgress[questName]
    if not questProgress then return false end
    
    if questProgress.State == QuestSystem.QUEST_STATES.NOT_STARTED then
        questProgress.State = QuestSystem.QUEST_STATES.IN_PROGRESS
        questProgress.StartTime = tick()
        questProgress.Progress = 0
        
        print(player.Name .. " inició la quest: " .. quest.Name)
        return true
    end
    
    return false
end

-- Función para actualizar progreso de quest
function QuestSystem.UpdateQuestProgress(player, questName, amount)
    local quest = QuestSystem.QUESTS[questName]
    local playerProgress = playerQuestProgress[player.UserId]
    
    if not quest or not playerProgress then return false end
    
    local questProgress = playerProgress[questName]
    if not questProgress then return false end
    
    if questProgress.State == QuestSystem.QUEST_STATES.IN_PROGRESS then
        questProgress.Progress = questProgress.Progress + amount
        
        -- Verificar si la quest está completa
        if questProgress.Progress >= quest.Target then
            QuestSystem.CompleteQuest(player, questName)
        end
        
        return true
    end
    
    return false
end

-- Función para completar una quest
function QuestSystem.CompleteQuest(player, questName)
    local quest = QuestSystem.QUESTS[questName]
    local playerProgress = playerQuestProgress[player.UserId]
    
    if not quest or not playerProgress then return false end
    
    local questProgress = playerProgress[questName]
    if not questProgress then return false end
    
    if questProgress.State == QuestSystem.QUEST_STATES.IN_PROGRESS then
        questProgress.State = QuestSystem.QUEST_STATES.COMPLETED
        questProgress.CompleteTime = tick()
        
        -- Dar recompensas
        QuestSystem.GiveRewards(player, quest.Reward)
        
        print(player.Name .. " completó la quest: " .. quest.Name)
        return true
    end
    
    return false
end

-- Función para dar recompensas
function QuestSystem.GiveRewards(player, rewards)
    if rewards.Experience then
        -- Usar sistema de stats para dar experiencia
        local PlayerStats = require(script.Parent.PlayerStats)
        PlayerStats.AddExperience(player, rewards.Experience)
    end
    
    if rewards.Gold then
        -- Implementar sistema de oro si es necesario
        print("Oro ganado: " .. rewards.Gold)
    end
    
    if rewards.Items then
        -- Usar sistema de inventario para dar items
        local InventorySystem = require(script.Parent.InventorySystem)
        for _, itemData in ipairs(rewards.Items) do
            InventorySystem.AddItem(player, itemData[1], itemData[2])
        end
    end
    
    if rewards.Skills then
        -- Implementar sistema de habilidades si es necesario
        for _, skillData in ipairs(rewards.Skills) do
            print("Habilidad aprendida: " .. skillData[1])
        end
    end
    
    if rewards.StatPoints then
        -- Usar sistema de stats para dar puntos
        local PlayerStats = require(script.Parent.PlayerStats)
        local stats = PlayerStats.GetStats(player)
        if stats then
            stats.Points = stats.Points + rewards.StatPoints
        end
    end
end

-- Función para obtener progreso de quest de un jugador
function QuestSystem.GetPlayerQuestProgress(player, questName)
    local playerProgress = playerQuestProgress[player.UserId]
    if not playerProgress then return nil end
    
    return playerProgress[questName]
end

-- Función para obtener todas las quests de un jugador
function QuestSystem.GetPlayerQuests(player)
    return playerQuestProgress[player.UserId] or {}
end

-- Función para obtener quests activas de un jugador
function QuestSystem.GetActiveQuests(player)
    local playerProgress = playerQuestProgress[player.UserId]
    if not playerProgress then return {} end
    
    local activeQuests = {}
    for questName, progress in pairs(playerProgress) do
        if progress.State == QuestSystem.QUEST_STATES.IN_PROGRESS then
            activeQuests[questName] = {
                Quest = QuestSystem.GetQuest(questName),
                Progress = progress
            }
        end
    end
    
    return activeQuests
end

-- Función para obtener quests completadas de un jugador
function QuestSystem.GetCompletedQuests(player)
    local playerProgress = playerQuestProgress[player.UserId]
    if not playerProgress then return {} end
    
    local completedQuests = {}
    for questName, progress in pairs(playerProgress) do
        if progress.State == QuestSystem.QUEST_STATES.COMPLETED then
            completedQuests[questName] = {
                Quest = QuestSystem.GetQuest(questName),
                Progress = progress
            }
        end
    end
    
    return completedQuests
end

-- Función para verificar si un jugador puede iniciar una quest
function QuestSystem.CanStartQuest(player, questName)
    local quest = QuestSystem.GetQuest(questName)
    local playerProgress = playerQuestProgress[player.UserId]
    
    if not quest or not playerProgress then return false end
    
    local questProgress = playerProgress[questName]
    if not questProgress then return false end
    
    -- Verificar estado
    if questProgress.State ~= QuestSystem.QUEST_STATES.NOT_STARTED then
        return false
    end
    
    -- Verificar prerrequisitos
    for _, prereq in ipairs(quest.Prerequisites) do
        local prereqProgress = playerProgress[prereq]
        if not prereqProgress or prereqProgress.State ~= QuestSystem.QUEST_STATES.COMPLETED then
            return false
        end
    end
    
    return true
end

-- Función para obtener estadísticas de quests de un jugador
function QuestSystem.GetPlayerQuestStats(player)
    local playerProgress = playerQuestProgress[player.UserId]
    if not playerProgress then return {} end
    
    local stats = {
        TotalQuests = 0,
        CompletedQuests = 0,
        ActiveQuests = 0,
        NotStartedQuests = 0
    }
    
    for questName, progress in pairs(playerProgress) do
        stats.TotalQuests = stats.TotalQuests + 1
        
        if progress.State == QuestSystem.QUEST_STATES.COMPLETED then
            stats.CompletedQuests = stats.CompletedQuests + 1
        elseif progress.State == QuestSystem.QUEST_STATES.IN_PROGRESS then
            stats.ActiveQuests = stats.ActiveQuests + 1
        elseif progress.State == QuestSystem.QUEST_STATES.NOT_STARTED then
            stats.NotStartedQuests = stats.NotStartedQuests + 1
        end
    end
    
    return stats
end

-- Limpiar datos cuando un jugador se va
local Players = game:GetService("Players")
Players.PlayerRemoving:Connect(function(player)
    playerQuestProgress[player.UserId] = nil
end)

return QuestSystem
