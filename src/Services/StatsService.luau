local ServerScriptService = game:GetService("ServerScriptService")
local ProfileService = require(ServerScriptService.Services.ProfileService)
local StatsService = {}

local function getStats(player)
	local profile = ProfileService.getProfile(player)
	if not profile then
		return nil
	end
	return profile.StatsBase
end

function StatsService.getStats(player: Player, statName: string)
	local stats = getStats(player)
	if not stats then
		return nil
	end

	if stats[statName] ~= nil then
		return stats[statName]
	end
	if stats.Multipliers and stats.Multipliers[statName] ~= nil then
		return stats.Multipliers[statName]
	end
	return nil
end

function StatsService.setStats(player: Player, statName: string, newValue: any)
	local stats = getStats(player)
	if not stats then
		return
	end

	if stats[statName] ~= nil then
		stats[statName] = newValue
	elseif stats.Multipliers and stats.Multipliers[statName] ~= nil then
		stats.Multipliers[statName] = newValue
	end
end

function StatsService.addStats(player: Player, statName: string, amount: number)
	local stats = getStats(player)
	if not stats then
		return
	end

	if stats[statName] ~= nil then
		stats[statName] += amount
	elseif stats.Multipliers and stats.Multipliers[statName] ~= nil then
		stats.Multipliers[statName] += amount
	end
end

function StatsService.removeStats(player: Player, statName: string, amount: number)
	StatsService.addStats(player, statName, -amount)
end

return StatsService
