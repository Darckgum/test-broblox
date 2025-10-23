-- InventoryServer.server.lua
-- Servidor principal del sistema de inventario moderno

print("🎮 INICIANDO SERVIDOR DE INVENTARIO MODERNO...")
print("=" :rep(60))

-- ============================================================================
-- SERVICIOS Y MÓDULOS
-- ============================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- Esperar módulos
local ServerModules = ServerStorage:WaitForChild("Modules")
local InventoryManager = require(ServerModules:WaitForChild("InventoryManager"))
local CraftingSystem = require(ServerModules:WaitForChild("CraftingSystem"))
local FusionSystem = require(ServerModules:WaitForChild("FusionSystem"))
local ItemDatabase = require(ServerModules:WaitForChild("ItemDatabase"))

-- ============================================================================
-- CREAR ESTRUCTURA DE REMOTE EVENTS
-- ============================================================================

local function setupRemoteEvents()
	-- Crear carpeta principal si no existe
	local remoteEventsFolder = ReplicatedStorage:FindFirstChild("RemoteEvents")
	if not remoteEventsFolder then
		remoteEventsFolder = Instance.new("Folder")
		remoteEventsFolder.Name = "RemoteEvents"
		remoteEventsFolder.Parent = ReplicatedStorage
	end
	
	-- Crear subcarpeta de eventos de inventario
	local inventoryEventsFolder = remoteEventsFolder:FindFirstChild("InventoryEvents")
	if not inventoryEventsFolder then
		inventoryEventsFolder = Instance.new("Folder")
		inventoryEventsFolder.Name = "InventoryEvents"
		inventoryEventsFolder.Parent = remoteEventsFolder
	end
	
	-- Crear eventos individuales
	local eventNames = {
		"UpdateInventory",  -- Server → Client: Actualizar inventario
		"MoveItem",         -- Client → Server: Mover item entre slots
		"UseItem",          -- Client → Server: Usar item consumible
		"CraftItem",        -- Client → Server: Craftear receta
		"FuseItems",        -- Client → Server: Fusionar items
		"GetRecipes",       -- Client → Server: Solicitar recetas
		"UpdateRecipes"     -- Server → Client: Enviar recetas
	}
	
	local events = {}
	
	for _, eventName in ipairs(eventNames) do
		local event = inventoryEventsFolder:FindFirstChild(eventName)
		if not event then
			event = Instance.new("RemoteEvent")
			event.Name = eventName
			event.Parent = inventoryEventsFolder
		end
		events[eventName] = event
	end
	
	print("✅ Eventos remotos creados")
	return events
end

local events = setupRemoteEvents()

-- ============================================================================
-- FUNCIONES DE UTILIDAD
-- ============================================================================

-- Obtener información completa del item
local function getItemInfo(itemId)
	-- Primero buscar en ItemDatabase
	local item = ItemDatabase.getItemById(itemId)
	
	-- Si no está, buscar en items fusionados
	if not item then
		item = FusionSystem.getFusedItemById(itemId)
	end
	
	return item
end

-- Enviar inventario actualizado al cliente
local function sendInventoryUpdate(player)
	local inventory = InventoryManager.getInventory(player)
	if inventory then
		-- Enriquecer datos del inventario con información completa de items
		local enrichedInventory = {
			slots = {},
			maxSlots = inventory.maxSlots
		}
		
		for i, slot in pairs(inventory.slots) do
			if slot and slot.id then
				local itemInfo = getItemInfo(slot.id)
				enrichedInventory.slots[i] = {
					id = slot.id,
					quantity = slot.quantity,
					name = itemInfo and itemInfo.name or slot.id,
					rarity = itemInfo and itemInfo.rarity or "Common",
					category = itemInfo and itemInfo.category or "Materials"
				}
			end
		end
		
		events.UpdateInventory:FireClient(player, enrichedInventory)
		print("📤 Inventario enviado a:", player.Name)
	end
end

-- Enviar recetas al cliente
local function sendRecipes(player)
	local knownRecipes = CraftingSystem.getKnownRecipes(player)
	
	-- Enriquecer recetas con información adicional
	local enrichedRecipes = {}
	
	for _, recipe in ipairs(knownRecipes) do
		local canCraft = CraftingSystem.canCraft(player, recipe.id, InventoryManager)
		
		table.insert(enrichedRecipes, {
			id = recipe.id,
			name = recipe.name,
			result = recipe.result,
			resultQuantity = recipe.resultQuantity,
			materials = recipe.materials,
			category = recipe.category,
			canCraft = canCraft
		})
	end
	
	events.UpdateRecipes:FireClient(player, enrichedRecipes)
	print("📋 Recetas enviadas a:", player.Name)
end

-- ============================================================================
-- MANEJADORES DE EVENTOS DEL CLIENTE
-- ============================================================================

-- Mover item entre slots (drag & drop)
events.MoveItem.OnServerEvent:Connect(function(player, fromSlot, toSlot)
	print(string.format("🔄 %s moviendo item: slot %d → slot %d", player.Name, fromSlot, toSlot))
	
	local success = InventoryManager.moveItem(player, fromSlot, toSlot)
	
	if success then
		sendInventoryUpdate(player)
	else
		warn("❌ Error moviendo item")
	end
end)

-- Usar item consumible
events.UseItem.OnServerEvent:Connect(function(player, slotIndex)
	print(string.format("💊 %s usando item en slot %d", player.Name, slotIndex))
	
	local success = InventoryManager.useItem(player, slotIndex)
	
	if success then
		sendInventoryUpdate(player)
		
		-- Enviar notificación al cliente
		-- (Por ahora solo actualizamos el inventario)
	else
		warn("❌ Error usando item")
	end
end)

-- Craftear item
events.CraftItem.OnServerEvent:Connect(function(player, recipeId)
	print(string.format("🔨 %s crafteando: %s", player.Name, recipeId))
	
	local success, message = CraftingSystem.craftItem(player, recipeId, InventoryManager)
	
	if success then
		sendInventoryUpdate(player)
		sendRecipes(player)
		print("✅", message)
	else
		warn("❌", message)
	end
end)

-- Fusionar items
events.FuseItems.OnServerEvent:Connect(function(player, item1Id, item2Id)
	print(string.format("✨ %s fusionando: %s + %s", player.Name, item1Id, item2Id))
	
	local success, message = FusionSystem.fuseItems(player, item1Id, item2Id, InventoryManager)
	
	if success then
		sendInventoryUpdate(player)
		print("✅", message)
	else
		warn("❌", message)
	end
end)

-- Obtener recetas disponibles
events.GetRecipes.OnServerEvent:Connect(function(player)
	print(string.format("📋 %s solicitando recetas", player.Name))
	sendRecipes(player)
end)

-- ============================================================================
-- MANEJO DE JUGADORES
-- ============================================================================

-- Cuando un jugador se conecta
Players.PlayerAdded:Connect(function(player)
	print("👤 Jugador conectado:", player.Name)
	
	-- Esperar a que el personaje se cargue
	player.CharacterAdded:Connect(function(character)
		-- Esperar un momento para que el cliente se inicialice
		task.wait(2)
		
		print("🎮 Personaje de", player.Name, "cargado")
		
		-- Cargar inventario
		InventoryManager.loadInventory(player)
		
		-- Enviar inventario inicial al cliente
		task.wait(1)
		sendInventoryUpdate(player)
		
		-- Enviar mensaje de bienvenida
		task.wait(0.5)
		
		-- Usar chat si está disponible
		pcall(function()
			game:GetService("Chat"):Chat(character.Head, "🎒 Sistema de inventario cargado!", Enum.ChatColor.Blue)
		end)
		
		print("✅ Sistema de inventario listo para:", player.Name)
	end)
end)

-- Cuando un jugador se desconecta
Players.PlayerRemoving:Connect(function(player)
	print("👋 Jugador desconectado:", player.Name)
	-- InventoryManager ya maneja el guardado automático
end)

-- ============================================================================
-- COMANDOS DE ADMINISTRADOR (OPCIONAL)
-- ============================================================================

-- Función para dar items a un jugador (útil para pruebas)
local function giveItem(player, itemId, quantity)
	quantity = quantity or 1
	
	local success = InventoryManager.addItem(player, itemId, quantity)
	
	if success then
		print(string.format("🎁 Dado %d x %s a %s", quantity, itemId, player.Name))
		sendInventoryUpdate(player)
		return true
	else
		warn(string.format("❌ No se pudo dar %s a %s (inventario lleno?)", itemId, player.Name))
		return false
	end
end

-- Comando de chat para dar items (solo para pruebas)
Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		-- Solo permitir a administradores (por ahora, todos)
		local parts = string.split(message, " ")
		
		if parts[1]:lower() == "/give" and #parts >= 3 then
			local itemId = parts[2]
			local quantity = tonumber(parts[3]) or 1
			
			giveItem(player, itemId, quantity)
		elseif parts[1]:lower() == "/clear" then
			-- Limpiar inventario (útil para pruebas)
			local inventory = InventoryManager.getInventory(player)
			if inventory then
				inventory.slots = {}
				sendInventoryUpdate(player)
				print("🗑️ Inventario de", player.Name, "limpiado")
			end
		elseif parts[1]:lower() == "/items" then
			-- Listar todos los items disponibles
			print("📦 ITEMS DISPONIBLES:")
			print("─" :rep(40))
			
			for _, item in ipairs(ItemDatabase.getAllItems()) do
				print(string.format("  • %s (%s) - %s", item.name, item.id, item.rarity))
			end
			
			print("─" :rep(40))
		end
	end)
end)

-- ============================================================================
-- DAR ITEMS INICIALES DE PRUEBA
-- ============================================================================

-- Dar items de prueba cuando el jugador entra por primera vez
local function giveStarterItems(player)
	task.wait(3) -- Esperar a que el inventario esté listo
	
	local inventory = InventoryManager.getInventory(player)
	
	-- Si el inventario está vacío (jugador nuevo), dar items iniciales
	if inventory and #inventory.slots == 0 then
		print("🎁 Dando items iniciales a", player.Name)
		
		-- Materiales básicos
		giveItem(player, "wood", 25)
		giveItem(player, "stone", 15)
		giveItem(player, "iron", 8)
		giveItem(player, "gold", 3)
		giveItem(player, "crystal", 2)
		
		-- Algunos items iniciales
		giveItem(player, "wooden_sword", 1)
		giveItem(player, "health_potion", 3)
		
		print("✅ Items iniciales dados a", player.Name)
	end
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		giveStarterItems(player)
	end)
end)

-- ============================================================================
-- FINALIZACIÓN
-- ============================================================================

print("✅ Servidor de inventario moderno iniciado correctamente")
print("🎮 Esperando jugadores...")
print("=" :rep(60))

-- Comandos útiles:
print("💡 COMANDOS DISPONIBLES:")
print("   /give [itemId] [cantidad] - Dar items")
print("   /clear - Limpiar inventario")
print("   /items - Listar items disponibles")
print("=" :rep(60))


