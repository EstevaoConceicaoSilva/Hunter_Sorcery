--local ServerScriptService = game:GetService("ServerScriptService")
--local ReplicatedStorage = game:GetService("ReplicatedStorage")
--local GeneralConfig = require(ReplicatedStorage.Configs.GeneralConfig)
--local ItemService = require(ReplicatedStorage.Services.ItemService)

--local DropService = {}

--function DropService.rollDrop(player, dropTable)
-- dropTable = {
--   {ItemId = "bandana_001", Chance = 0.1},
--   {ItemId = "sword_fire", Chance = 0.05},
-- }

--local finalChances = {}

--for _, drop in ipairs(dropTable) do
--local chance = drop.Chance

-- ✅ Aplica multiplicador de eventos
--if GeneralConfig.Events.DropRateBoost.Active then
--chance = chance * GeneralConfig.Events.DropRateBoost.Multiplier
--end

--if GeneralConfig.Events.WeekendEvent.Active then
--chance = chance * GeneralConfig.Events.WeekendEvent.DropMultiplier
--end

--if GeneralConfig.Events.DoubleLuck.Active then
--chance = chance * GeneralConfig.Events.DoubleLuck.Multiplier
--end

--table.insert(finalChances, {ItemId = drop.ItemId, Chance = math.min(chance, 1.0)})
--end

-- Rola os drops
--local drops = {}
--for _, drop in ipairs(finalChances) do
--if math.random() <= drop.Chance then
---table.insert(drops, drop.ItemId)
--end
--end

-- Dá os itens pro player
--for _, itemId in ipairs(drops) do
--ItemService.giveItem(player, itemId)
--end

--return drops
--end

--return DropService
