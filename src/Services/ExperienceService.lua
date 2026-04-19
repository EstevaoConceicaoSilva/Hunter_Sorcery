local ServerScriptService = game:GetService("ServerScriptService")
local ProfileService = require(ServerScriptService.Services.ProfileService)
local StatsCalculator = require(ServerScriptService.Services.StatsCalculator)
local ClientService = require(ServerScriptService.Services.ClientService)

local ExperienceService = {}

local function calculateExpForLevel(level)
	return math.floor(100 * (level ^ 1.5))
end

function ExperienceService.addExperience(player: Player, amount: number)
	local profile = ProfileService.getProfile(player)
	if not profile then
		return
	end

	local stats = profile.Stats
	stats.Experience = stats.Experience + amount

	while stats.Experience >= stats.ExperienceToNextLevel do
		stats.Experience = stats.Experience - stats.ExperienceToNextLevel
		stats.Level = stats.Level + 1
		stats.AvailablePoints = stats.AvailablePoints + 3
		stats.ExperienceToNextLevel = calculateExpForLevel(stats.Level)

		print("🎉 " .. player.Name .. " subiu para o Level " .. stats.Level)

		StatsCalculator.calculate(profile)
	end

	ClientService.sendStats(player)
end

return ExperienceService
