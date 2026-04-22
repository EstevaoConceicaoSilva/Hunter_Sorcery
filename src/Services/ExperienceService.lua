local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ProfileService = require(ServerScriptService.Services.ProfileService)
local StatsService = require(ServerScriptService.Services.StatsService)
local ClientService = require(ServerScriptService.Services.ClientService)
local GeneralConfig = require(ReplicatedStorage.GeneralConfigs.GeneralConfig)
local EventManager = require(ServerScriptService.Services.EventManager)

local ExperienceService = {}

local function calculateExpForLevel(level: number)
	if GeneralConfig.Config.MaxLevel and level >= GeneralConfig.Config.MaxLevel then
		return calculateExpForLevel(GeneralConfig.Config.MaxLevel - 1)
	end
	return math.floor(100 * (level ^ GeneralConfig.Config.ExpGrowthRate))
end

function ExperienceService.addExperience(player: Player, amount: number)
	local profile = ProfileService.getProfile(player)
	if not profile then
		return
	end
	local stats = profile.Stats

	if GeneralConfig.Config.MaxLevel and stats.Level >= GeneralConfig.Config.MaxLevel then
		stats.Experience = stats.ExperienceToNextLevel -- trava no máximo
		stats.ExperienceToNextLevel = 0
		print(player.Name .. " já está no nível máximo!")
		ClientService.sendStats(player)
		return
	end

	if not stats.Experience then
		stats.Experience = stats.Experience or 0
	end
	if not stats.Level then
		stats.Level = stats.Level or 1
	end
	if not stats.ExperienceToNextLevel or stats.ExperienceToNextLevel <= 0 then
		stats.ExperienceToNextLevel = calculateExpForLevel(stats.Level)
	end

	local finalAmount = math.floor(amount * EventManager.getExpMultiplier())
	stats.Experience = stats.Experience + finalAmount

	while stats.Experience >= stats.ExperienceToNextLevel do
		stats.Experience = stats.Experience - stats.ExperienceToNextLevel
		stats.Level = stats.Level + 1
		stats.AvailablePoints = stats.AvailablePoints + GeneralConfig.Config.LevelUpPoints
		stats.ExperienceToNextLevel = calculateExpForLevel(stats.Level)

		print("🎉 " .. player.Name .. " subiu para o Level " .. stats.Level)

		StatsService.calculate(profile)
	end

	ClientService.sendStats(player)
end

return ExperienceService
