-- Eventos del Servidor RPG
-- Maneja todos los RemoteEvents y comunicación cliente-servidor

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- Esperar a que los módulos se carguen
local Modules = ServerStorage:WaitForChild("Modules")
local PlayerStats = require(Modules:WaitForChild("PlayerStats"))
local InventorySystem = require(Modules:WaitForChild("InventorySystem"))
local CombatSystem = require(Modules:WaitForChild("CombatSystem"))
local QuestSystem = require(Modules:WaitForChild("QuestSystem"))

-- Crear RemoteEvents para comunicación cliente-servidor
local rpgEvents = Instance.new("Folder")
rpgEvents.Name = "RPGEvents"
rpgEvents.Parent = ReplicatedStorage

-- Eventos de combate
local combatEvents = Instance.new("Folder")
combatEvents.Name = "CombatEvents"
combatEvents.Parent = rpgEvents

local attackEvent = Instance.new("RemoteEvent")
attackEvent.Name = "AttackEvent"
attackEvent.Parent = combatEvents

local skillEvent = Instance.new("RemoteEvent")
skillEvent.Name = "SkillEvent"
skillEvent.Parent = combatEvents

-- Eventos de inventario
local inventoryEvents = Instance.new("Folder")
inventoryEvents.Name = "InventoryEvents"
inventoryEvents.Parent = rpgEvents

local equipItemEvent = Instance.new("RemoteEvent")
equipItemEvent.Name = "EquipItemEvent"
equipItemEvent.Parent = inventoryEvents

local useItemEvent = Instance.new("RemoteEvent")
useItemEvent.Name = "UseItemEvent"
useItemEvent.Parent = inventoryEvents

local dropItemEvent = Instance.new("RemoteEvent")
dropItemEvent.Name = "DropItemEvent"
dropItemEvent.Parent = inventoryEvents

-- Eventos de stats
local statsEvents = Instance.new("Folder")
statsEvents.Name = "StatsEvents"
statsEvents.Parent = rpgEvents

local levelUpEvent = Instance.new("RemoteEvent")
levelUpEvent.Name = "LevelUpEvent"
levelUpEvent.Parent = statsEvents

local spendPointsEvent = Instance.new("RemoteEvent")
spendPointsEvent.Name = "SpendPointsEvent"
spendPointsEvent.Parent = statsEvents

-- Eventos de quests
local questEvents = Instance.new("Folder")
questEvents.Name = "QuestEvents"
questEvents.Parent = rpgEvents

local startQuestEvent = Instance.new("RemoteEvent")
startQuestEvent.Name = "StartQuestEvent"
startQuestEvent.Parent = questEvents

local completeQuestEvent = Instance.new("RemoteEvent")
completeQuestEvent.Name = "CompleteQuestEvent"
completeQuestEvent.Parent = questEvents

-- Eventos de GUI
local guiEvents = Instance.new("Folder")
guiEvents.Name = "GUIEvents"
guiEvents.Parent = rpgEvents

local openGUIEvent = Instance.new("RemoteEvent")
openGUIEvent.Name = "OpenGUIEvent"
openGUIEvent.Parent = guiEvents

local closeGUIEvent = Instance.new("RemoteEvent")
closeGUIEvent.Name = "CloseGUIEvent"
closeGUIEvent.Parent = guiEvents

-- ===== MANEJADORES DE EVENTOS DE COMBATE =====

-- Manejar ataques básicos
attackEvent.OnServerEvent:Connect(function(player, targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    
    -- Verificar si el objetivo está en rango
    if CombatSystem.IsInRange(player, targetPlayer, 10) then
        CombatSystem.BasicAttack(player, targetPlayer)
    end
end)

-- Manejar uso de habilidades
skillEvent.OnServerEvent:Connect(function(player, skillName, targetPlayer)
    if not SkillDatabase.SkillExists(skillName) then return end
    
    -- Verificar si el objetivo existe (para habilidades dirigidas)
    if targetPlayer and not targetPlayer.Character then return end
    
    -- Usar la habilidad
    CombatSystem.UseSkill(player, skillName, targetPlayer)
end)

-- ===== MANEJADORES DE EVENTOS DE INVENTARIO =====

-- Manejar equipamiento de items
equipItemEvent.OnServerEvent:Connect(function(player, slotIndex)
    local success = InventorySystem.EquipItem(player, slotIndex)
    
    if success then
        -- Notificar al cliente que el item fue equipado
        equipItemEvent:FireClient(player, slotIndex, true)
    else
        -- Notificar al cliente que hubo un error
        equipItemEvent:FireClient(player, slotIndex, false)
    end
end)

-- Manejar uso de consumibles
useItemEvent.OnServerEvent:Connect(function(player, slotIndex)
    local success = InventorySystem.UseConsumable(player, slotIndex)
    
    if success then
        -- Notificar al cliente que el item fue usado
        useItemEvent:FireClient(player, slotIndex, true)
    else
        -- Notificar al cliente que hubo un error
        useItemEvent:FireClient(player, slotIndex, false)
    end
end)

-- Manejar drop de items
dropItemEvent.OnServerEvent:Connect(function(player, slotIndex, quantity)
    quantity = quantity or 1
    
    local inventory = InventorySystem.GetInventory(player)
    local item = inventory[slotIndex]
    
    if item and item.Quantity >= quantity then
        -- Remover item del inventario
        InventorySystem.RemoveItem(player, item.Name, quantity)
        
        -- Crear item físico en el mundo
        createDroppedItem(player.Character.HumanoidRootPart.Position, item.Name, quantity)
        
        -- Notificar al cliente
        dropItemEvent:FireClient(player, slotIndex, quantity, true)
    else
        -- Notificar error al cliente
        dropItemEvent:FireClient(player, slotIndex, quantity, false)
    end
end)

-- ===== MANEJADORES DE EVENTOS DE STATS =====

-- Manejar subida de nivel
levelUpEvent.OnServerEvent:Connect(function(player)
    local stats = PlayerStats.GetStats(player)
    if stats and stats.Points > 0 then
        -- Notificar al cliente sobre puntos disponibles
        levelUpEvent:FireClient(player, stats.Points)
    end
end)

-- Manejar gasto de puntos de habilidad
spendPointsEvent.OnServerEvent:Connect(function(player, statName, amount)
    local success = PlayerStats.SpendPoints(player, statName, amount)
    
    if success then
        -- Notificar al cliente que los puntos fueron gastados
        spendPointsEvent:FireClient(player, statName, amount, true)
    else
        -- Notificar error al cliente
        spendPointsEvent:FireClient(player, statName, amount, false)
    end
end)

-- ===== MANEJADORES DE EVENTOS DE QUESTS =====

-- Manejar inicio de quests
startQuestEvent.OnServerEvent:Connect(function(player, questName)
    local success = QuestSystem.StartQuest(player, questName)
    
    if success then
        -- Notificar al cliente que la quest fue iniciada
        startQuestEvent:FireClient(player, questName, true)
    else
        -- Notificar error al cliente
        startQuestEvent:FireClient(player, questName, false)
    end
end)

-- Manejar completado de quests
completeQuestEvent.OnServerEvent:Connect(function(player, questName)
    local success = QuestSystem.CompleteQuest(player, questName)
    
    if success then
        -- Notificar al cliente que la quest fue completada
        completeQuestEvent:FireClient(player, questName, true)
    else
        -- Notificar error al cliente
        completeQuestEvent:FireClient(player, questName, false)
    end
end)

-- ===== MANEJADORES DE EVENTOS DE GUI =====

-- Manejar apertura de GUI
openGUIEvent.OnServerEvent:Connect(function(player, guiType)
    -- Verificar que el jugador tenga permisos para abrir la GUI
    if guiType == "Main" or guiType == "Inventory" or guiType == "Skills" or guiType == "Quests" then
        openGUIEvent:FireClient(player, guiType, true)
    else
        openGUIEvent:FireClient(player, guiType, false)
    end
end)

-- Manejar cierre de GUI
closeGUIEvent.OnServerEvent:Connect(function(player, guiType)
    -- Notificar al cliente que la GUI fue cerrada
    closeGUIEvent:FireClient(player, guiType)
end)

-- ===== FUNCIONES AUXILIARES =====

-- Función para crear items físicos en el mundo
local function createDroppedItem(position, itemName, quantity)
    local itemModel = Instance.new("Model")
    itemModel.Name = itemName
    itemModel.Parent = workspace
    
    local itemPart = Instance.new("Part")
    itemPart.Name = "ItemPart"
    itemPart.Size = Vector3.new(1, 1, 1)
    itemPart.Position = position
    itemPart.BrickColor = BrickColor.new("Bright blue")
    itemPart.Anchored = false
    itemPart.CanCollide = false
    itemPart.Parent = itemModel
    
    -- Agregar ClickDetector para recoger el item
    local clickDetector = Instance.new("ClickDetector")
    clickDetector.MaxActivationDistance = 5
    clickDetector.Parent = itemPart
    
    -- Crear valores para el item
    local itemNameValue = Instance.new("StringValue")
    itemNameValue.Name = "ItemName"
    itemNameValue.Value = itemName
    itemNameValue.Parent = itemModel
    
    local itemQuantityValue = Instance.new("IntValue")
    itemQuantityValue.Name = "Quantity"
    itemQuantityValue.Value = quantity
    itemQuantityValue.Parent = itemModel
    
    -- Evento para recoger el item
    clickDetector.MouseClick:Connect(function(player)
        local success = InventorySystem.AddItem(player, itemName, quantity)
        if success then
            itemModel:Destroy()
        end
    end)
    
    -- Auto-destruir después de 5 minutos
    spawn(function()
        wait(300)
        if itemModel.Parent then
            itemModel:Destroy()
        end
    end)
end

-- ===== EVENTOS DE SISTEMA =====

-- Evento cuando un jugador mata a un enemigo
local function onEnemyKilled(killer, enemy)
    if killer and killer.Character then
        -- Dar experiencia por matar enemigo
        local enemyLevel = enemy:FindFirstChild("Level")
        local expReward = enemyLevel and (enemyLevel.Value * 10) or 10
        
        PlayerStats.AddExperience(killer, expReward)
        
        -- Actualizar progreso de quests de matar enemigos
        QuestSystem.UpdateQuestProgress(killer, "First Adventure", 1)
        
        -- Posibilidad de drop de items
        if math.random() < 0.3 then -- 30% de probabilidad
            local itemDatabase = require(Modules:WaitForChild("ItemDatabase"))
            local randomItem = itemDatabase.GenerateRandomItem("Common")
            if randomItem then
                InventorySystem.AddItem(killer, randomItem, 1)
            end
        end
    end
end

-- Evento cuando un jugador recoge un item
local function onItemCollected(player, itemName)
    -- Actualizar progreso de quests de recolección
    QuestSystem.UpdateQuestProgress(player, "Collector", 1)
end

-- Evento cuando un jugador usa una habilidad
local function onSkillUsed(player, skillName)
    -- Actualizar progreso de quests de habilidades
    QuestSystem.UpdateQuestProgress(player, "Magic Apprentice", 1)
end

-- Evento cuando un jugador equipa un item
local function onItemEquipped(player, itemName)
    -- Actualizar progreso de quests de equipamiento
    QuestSystem.UpdateQuestProgress(player, "Warrior's Path", 1)
end

-- Evento cuando un jugador sube de nivel
local function onLevelUp(player, newLevel)
    -- Actualizar progreso de quests de nivel
    QuestSystem.UpdateQuestProgress(player, "Rising Star", 1)
end

-- ===== CONFIGURACIÓN DE EVENTOS =====

-- Conectar eventos del sistema
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(2)
        
        -- Configurar eventos específicos del jugador
        local stats = PlayerStats.GetStats(player)
        if stats then
            -- Conectar evento de subida de nivel
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats then
                local levelValue = leaderstats:FindFirstChild("Level")
                if levelValue then
                    levelValue.Changed:Connect(function(newLevel)
                        onLevelUp(player, newLevel)
                    end)
                end
            end
        end
    end)
end)

print("Eventos del servidor RPG configurados correctamente")
