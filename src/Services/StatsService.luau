local ServerScriptService = game:GetService("ServerScriptService")
local ProfileService = require(ServerScriptService.Services.ProfileService)
local StatsCalculator = require(ServerScriptService.Services.StatsCalculator)
local ClientService = require(ServerScriptService.Services.ClientService)
local StatsService = {}

local function getStats(player)
	local profile = ProfileService.getProfile(player)
	if not profile then
		return nil
	end
	return profile.Stats
end

function StatsService.getStats(player: Player, statName: string)
	local stats = getStats(player)
	if not stats then
		return nil
	end

	if stats[statName] ~= nil then
		return stats[statName]
	end
	-- Verifica se é um multiplicador
	if stats.Multipliers and stats.Multipliers[statName] ~= nil then
		return stats.Multipliers[statName]
	end

	return nil
end

function StatsService.setStats(player: Player, statName: string, amount: any)
	local profile = ProfileService.getProfile(player)
	if not profile then
		return
	end

	local stats = profile.Stats
	if stats[statName] ~= nil then
		stats[statName] += amount
		StatsCalculator.calculate(profile) -- recalcula tudo
		ClientService.sendStats(player) -- atualiza no cliente
	end
end

function StatsService.addStats(player: Player, statName: string, amount: number)
	local profile = ProfileService.getProfile(player)
	if not profile then
		return
	end

	local stats = profile.Stats
	if stats[statName] ~= nil then
		stats[statName] += amount
		StatsCalculator.calculate(profile) -- recalcula tudo
		ClientService.sendStats(player) -- atualiza no cliente
	end
end

function StatsService.removeStats(player: Player, statName: string, amount: number)
	StatsService.addStats(player, statName, -amount)
end

--Adicionado sistema de alocação de pontos e reset.
function StatsService.allocatePoint(player: Player, statName: string)
	local profile = ProfileService.getProfile(player)
	if not profile then
		return false, "Perfil não carregado"
	end

	local stats = profile.Stats

	if stats.AvailablePoints <= 0 then
		return false, "Sem pontos disponíveis"
	end

	if stats[statName] == nil then
		return false, "Stat inválido"
	end

	stats[statName] = stats[statName] + 1
	stats.AvailablePoints = stats.AvailablePoints - 1

	StatsCalculator.calculate(profile)
	ClientService.sendStats(player)

	local SyncStats = require(ServerScriptService.Services.SyncStats)
	SyncStats.syncPlayer(player)

	return true, "Ponto alocado"
end

function StatsService.resetStats(player: Player)
	local profile = ProfileService.getProfile(player)
	if not profile then
		return false
	end

	local stats = profile.Stats
	local totalSpent = stats.Strength + stats.Constitution + stats.Dexterity + stats.Intelligence
	stats.AvailablePoints = stats.AvailablePoints + totalSpent

	stats.Strength = 0
	stats.Constitution = 0
	stats.Dexterity = 0
	stats.Intelligence = 0

	StatsCalculator.calculate(profile)
	ClientService.sendStats(player)

	local SyncStats = require(ServerScriptService.Services.SyncStats)
	SyncStats.syncPlayer(player)

	return true
end

return StatsService
