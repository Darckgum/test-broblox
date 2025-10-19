-- Sistema de Combate para RPG
-- Maneja ataques, habilidades especiales y combate entre jugadores y NPCs

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Módulo de Combate
local CombatSystem = {}

-- Configuración de combate
local COMBAT_CONFIG = {
    AttackRange = 10,           -- Rango de ataque básico
    CriticalChance = 0.1,       -- 10% de probabilidad de crítico
    CriticalMultiplier = 2.0,    -- Multiplicador de daño crítico
    BlockChance = 0.15,         -- 15% de probabilidad de bloquear
    DodgeChance = 0.1,          -- 10% de probabilidad de esquivar
    AttackCooldown = 1.0,       -- Cooldown entre ataques (segundos)
    SkillCooldown = 5.0         -- Cooldown entre habilidades (segundos)
}

-- Base de datos de habilidades
local SKILL_DATABASE = {
    ["Fireball"] = {
        Name = "Fireball",
        ManaCost = 20,
        Damage = 40,
        Range = 15,
        Cooldown = 3.0,
        Description = "Lanza una bola de fuego que causa daño mágico",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Animation = "rbxassetid://0" -- ID de animación
    },
    ["Heal"] = {
        Name = "Heal",
        ManaCost = 15,
        HealAmount = 60,
        Range = 0, -- Auto-target
        Cooldown = 4.0,
        Description = "Restaura puntos de vida",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Animation = "rbxassetid://0"
    },
    ["Lightning Strike"] = {
        Name = "Lightning Strike",
        ManaCost = 30,
        Damage = 60,
        Range = 20,
        Cooldown = 6.0,
        Description = "Golpea con un rayo que causa daño masivo",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Animation = "rbxassetid://0"
    },
    ["Shield"] = {
        Name = "Shield",
        ManaCost = 25,
        Duration = 10.0,
        DefenseBonus = 20,
        Cooldown = 15.0,
        Description = "Aumenta la defensa temporalmente",
        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Animation = "rbxassetid://0"
    }
}

-- Tabla para almacenar cooldowns de jugadores
local playerCooldowns = {}
local playerBuffs = {}

-- Función para inicializar sistema de combate para un jugador
function CombatSystem.InitializePlayer(player)
    playerCooldowns[player.UserId] = {
        Attack = 0,
        Skills = {}
    }
    
    playerBuffs[player.UserId] = {}
    
    print("Sistema de combate inicializado para " .. player.Name)
end

-- Función para realizar un ataque básico
function CombatSystem.BasicAttack(attacker, target)
    local attackerCooldowns = playerCooldowns[attacker.UserId]
    if not attackerCooldowns then return false end
    
    -- Verificar cooldown
    if tick() - attackerCooldowns.Attack < COMBAT_CONFIG.AttackCooldown then
        return false
    end
    
    -- Verificar rango
    if not CombatSystem.IsInRange(attacker, target, COMBAT_CONFIG.AttackRange) then
        return false
    end
    
    -- Calcular daño
    local damage = CombatSystem.CalculateDamage(attacker, target, "Physical")
    
    -- Aplicar daño
    local PlayerStats = require(script.Parent.PlayerStats)
    PlayerStats.TakeDamage(target, damage)
    
    -- Actualizar cooldown
    attackerCooldowns.Attack = tick()
    
    -- Mostrar efecto visual
    CombatSystem.ShowDamageEffect(target, damage, "Physical")
    
    print(attacker.Name .. " atacó a " .. target.Name .. " por " .. damage .. " daño")
    return true
end

-- Función para usar una habilidad
function CombatSystem.UseSkill(player, skillName, target)
    local playerCooldowns = playerCooldowns[player.UserId]
    local skillData = SKILL_DATABASE[skillName]
    
    if not playerCooldowns or not skillData then return false end
    
    -- Verificar cooldown de habilidad
    if playerCooldowns.Skills[skillName] and 
       tick() - playerCooldowns.Skills[skillName] < skillData.Cooldown then
        return false
    end
    
    -- Verificar mana
    local PlayerStats = require(script.Parent.PlayerStats)
    if not PlayerStats.UseMana(player, skillData.ManaCost) then
        return false
    end
    
    -- Verificar rango si es necesario
    if target and skillData.Range > 0 then
        if not CombatSystem.IsInRange(player, target, skillData.Range) then
            return false
        end
    end
    
    -- Ejecutar habilidad
    if skillName == "Fireball" then
        CombatSystem.Fireball(player, target)
    elseif skillName == "Heal" then
        CombatSystem.Heal(player)
    elseif skillName == "Lightning Strike" then
        CombatSystem.LightningStrike(player, target)
    elseif skillName == "Shield" then
        CombatSystem.Shield(player)
    end
    
    -- Actualizar cooldown
    playerCooldowns.Skills[skillName] = tick()
    
    print(player.Name .. " usó " .. skillName)
    return true
end

-- Implementación de habilidad Fireball
function CombatSystem.Fireball(caster, target)
    local skillData = SKILL_DATABASE["Fireball"]
    local damage = CombatSystem.CalculateDamage(caster, target, "Magic")
    
    -- Aplicar daño
    local PlayerStats = require(script.Parent.PlayerStats)
    PlayerStats.TakeDamage(target, damage)
    
    -- Mostrar efecto visual
    CombatSystem.ShowDamageEffect(target, damage, "Magic")
    CombatSystem.ShowSkillEffect(caster, target, "Fireball")
end

-- Implementación de habilidad Heal
function CombatSystem.Heal(caster)
    local skillData = SKILL_DATABASE["Heal"]
    
    -- Curar al caster
    local PlayerStats = require(script.Parent.PlayerStats)
    PlayerStats.Heal(caster, skillData.HealAmount)
    
    -- Mostrar efecto visual
    CombatSystem.ShowHealEffect(caster, skillData.HealAmount)
end

-- Implementación de habilidad Lightning Strike
function CombatSystem.LightningStrike(caster, target)
    local skillData = SKILL_DATABASE["Lightning Strike"]
    local damage = CombatSystem.CalculateDamage(caster, target, "Magic")
    
    -- Aplicar daño
    local PlayerStats = require(script.Parent.PlayerStats)
    PlayerStats.TakeDamage(target, damage)
    
    -- Mostrar efecto visual
    CombatSystem.ShowDamageEffect(target, damage, "Magic")
    CombatSystem.ShowSkillEffect(caster, target, "Lightning Strike")
end

-- Implementación de habilidad Shield
function CombatSystem.Shield(caster)
    local skillData = SKILL_DATABASE["Shield"]
    
    -- Aplicar buff de defensa
    CombatSystem.ApplyBuff(caster, "Shield", skillData.Duration, {
        DefenseBonus = skillData.DefenseBonus
    })
    
    -- Mostrar efecto visual
    CombatSystem.ShowBuffEffect(caster, "Shield")
end

-- Función para calcular daño
function CombatSystem.CalculateDamage(attacker, target, damageType)
    local PlayerStats = require(script.Parent.PlayerStats)
    local InventorySystem = require(script.Parent.InventorySystem)
    
    local attackerStats = PlayerStats.GetStats(attacker)
    local targetStats = PlayerStats.GetStats(target)
    
    if not attackerStats or not targetStats then return 0 end
    
    local baseDamage = 0
    
    if damageType == "Physical" then
        baseDamage = attackerStats.Strength + InventorySystem.GetTotalDamage(attacker)
    elseif damageType == "Magic" then
        baseDamage = attackerStats.Intelligence
    end
    
    -- Calcular defensa del objetivo
    local targetDefense = targetStats.Defense + InventorySystem.GetTotalDefense(target)
    
    -- Aplicar buffs de defensa
    local targetBuffs = playerBuffs[target.UserId]
    if targetBuffs and targetBuffs["Shield"] then
        targetDefense = targetDefense + targetBuffs["Shield"].DefenseBonus
    end
    
    -- Calcular daño final
    local finalDamage = math.max(1, baseDamage - targetDefense)
    
    -- Verificar crítico
    if math.random() < COMBAT_CONFIG.CriticalChance + (attackerStats.Luck * 0.01) then
        finalDamage = finalDamage * COMBAT_CONFIG.CriticalMultiplier
        CombatSystem.ShowCriticalEffect(target)
    end
    
    -- Verificar bloqueo
    if math.random() < COMBAT_CONFIG.BlockChance then
        finalDamage = finalDamage * 0.5 -- Reducir daño a la mitad
        CombatSystem.ShowBlockEffect(target)
    end
    
    -- Verificar esquivar
    if math.random() < COMBAT_CONFIG.DodgeChance + (targetStats.Speed * 0.005) then
        finalDamage = 0
        CombatSystem.ShowDodgeEffect(target)
    end
    
    return math.floor(finalDamage)
end

-- Función para verificar si está en rango
function CombatSystem.IsInRange(attacker, target, range)
    local attackerChar = attacker.Character
    local targetChar = target.Character
    
    if not attackerChar or not targetChar then return false end
    
    local attackerPos = attackerChar.HumanoidRootPart.Position
    local targetPos = targetChar.HumanoidRootPart.Position
    
    local distance = (attackerPos - targetPos).Magnitude
    
    return distance <= range
end

-- Función para aplicar buffs
function CombatSystem.ApplyBuff(player, buffName, duration, effects)
    local playerBuffs = playerBuffs[player.UserId]
    if not playerBuffs then return false end
    
    playerBuffs[buffName] = {
        Effects = effects,
        EndTime = tick() + duration
    }
    
    -- Programar remoción del buff
    spawn(function()
        wait(duration)
        CombatSystem.RemoveBuff(player, buffName)
    end)
    
    return true
end

-- Función para remover buffs
function CombatSystem.RemoveBuff(player, buffName)
    local playerBuffs = playerBuffs[player.UserId]
    if not playerBuffs then return false end
    
    playerBuffs[buffName] = nil
    return true
end

-- Función para mostrar efecto de daño
function CombatSystem.ShowDamageEffect(target, damage, damageType)
    local character = target.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Crear GUI de daño
    local damageGui = Instance.new("ScreenGui")
    damageGui.Name = "DamageGui"
    damageGui.Parent = target.PlayerGui
    
    local damageFrame = Instance.new("Frame")
    damageFrame.Size = UDim2.new(0, 100, 0, 30)
    damageFrame.Position = UDim2.new(0.5, 0, 0.3, 0)
    damageFrame.BackgroundTransparency = 1
    damageFrame.Parent = damageGui
    
    local damageLabel = Instance.new("TextLabel")
    damageLabel.Size = UDim2.new(1, 0, 1, 0)
    damageLabel.BackgroundTransparency = 1
    damageLabel.Text = "-" .. damage
    damageLabel.TextColor3 = damageType == "Physical" and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 100, 255)
    damageLabel.TextScaled = true
    damageLabel.Font = Enum.Font.SourceSansBold
    damageLabel.Parent = damageFrame
    
    -- Animar el texto
    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = game:GetService("TweenService"):Create(damageFrame, tweenInfo, {
        Position = UDim2.new(0.5, 0, 0.1, 0),
        BackgroundTransparency = 1
    })
    
    tween:Play()
    
    -- Limpiar después de la animación
    tween.Completed:Connect(function()
        damageGui:Destroy()
    end)
end

-- Función para mostrar efecto de curación
function CombatSystem.ShowHealEffect(target, healAmount)
    local character = target.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Crear GUI de curación
    local healGui = Instance.new("ScreenGui")
    healGui.Name = "HealGui"
    healGui.Parent = target.PlayerGui
    
    local healFrame = Instance.new("Frame")
    healFrame.Size = UDim2.new(0, 100, 0, 30)
    healFrame.Position = UDim2.new(0.5, 0, 0.3, 0)
    healFrame.BackgroundTransparency = 1
    healFrame.Parent = healGui
    
    local healLabel = Instance.new("TextLabel")
    healLabel.Size = UDim2.new(1, 0, 1, 0)
    healLabel.BackgroundTransparency = 1
    healLabel.Text = "+" .. healAmount
    healLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    healLabel.TextScaled = true
    healLabel.Font = Enum.Font.SourceSansBold
    healLabel.Parent = healFrame
    
    -- Animar el texto
    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = game:GetService("TweenService"):Create(healFrame, tweenInfo, {
        Position = UDim2.new(0.5, 0, 0.1, 0),
        BackgroundTransparency = 1
    })
    
    tween:Play()
    
    -- Limpiar después de la animación
    tween.Completed:Connect(function()
        healGui:Destroy()
    end)
end

-- Función para mostrar efecto de habilidad
function CombatSystem.ShowSkillEffect(caster, target, skillName)
    -- Implementar efectos visuales específicos para cada habilidad
    print("Efecto visual para " .. skillName)
end

-- Función para mostrar efecto crítico
function CombatSystem.ShowCriticalEffect(target)
    print("¡CRÍTICO!")
end

-- Función para mostrar efecto de bloqueo
function CombatSystem.ShowBlockEffect(target)
    print("¡BLOQUEADO!")
end

-- Función para mostrar efecto de esquivar
function CombatSystem.ShowDodgeEffect(target)
    print("¡ESQUIVADO!")
end

-- Función para mostrar efecto de buff
function CombatSystem.ShowBuffEffect(target, buffName)
    print("Buff aplicado: " .. buffName)
end

-- Función para obtener habilidades disponibles
function CombatSystem.GetAvailableSkills()
    return SKILL_DATABASE
end

-- Función para verificar cooldown de habilidad
function CombatSystem.GetSkillCooldown(player, skillName)
    local playerCooldowns = playerCooldowns[player.UserId]
    if not playerCooldowns or not playerCooldowns.Skills[skillName] then
        return 0
    end
    
    local skillData = SKILL_DATABASE[skillName]
    if not skillData then return 0 end
    
    local timeSinceUsed = tick() - playerCooldowns.Skills[skillName]
    return math.max(0, skillData.Cooldown - timeSinceUsed)
end

-- Función para obtener buffs activos
function CombatSystem.GetActiveBuffs(player)
    local playerBuffs = playerBuffs[player.UserId]
    if not playerBuffs then return {} end
    
    local activeBuffs = {}
    for buffName, buffData in pairs(playerBuffs) do
        if tick() < buffData.EndTime then
            activeBuffs[buffName] = buffData
        end
    end
    
    return activeBuffs
end

-- Limpiar datos cuando un jugador se va
Players.PlayerRemoving:Connect(function(player)
    playerCooldowns[player.UserId] = nil
    playerBuffs[player.UserId] = nil
end)

-- Exportar el módulo
return CombatSystem
