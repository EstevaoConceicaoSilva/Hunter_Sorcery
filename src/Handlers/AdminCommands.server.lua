local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventManager = require(ServerScriptService.Services.EventManager)
local GeneralConfig = require(ReplicatedStorage.GeneralConfigs.GeneralConfig)
local ProfileService = require(ServerScriptService.Services.ProfileService)
local StatsService = require(ServerScriptService.Services.StatsService)
local ClientService = require(ServerScriptService.Services.ClientService)

local ADMINS = {
	"ESTEVAOlife", -- coloca teu username aqui
}

local function isAdmin(player)
	return table.find(ADMINS, player.Name) ~= nil
end

Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		if not isAdmin(player) then
			return
		end

		local args = string.split(message, " ")
		local cmd = args[1]:lower()

		if cmd == "/event" then
			local eventName = args[2]
			if eventName then
				EventManager.toggleEvent(eventName)
			else
				print("Eventos disponíveis: DoubleExp, DropRateBoost, WeekendEvent, DoubleLuck, HalloweenEvent")
			end
		elseif cmd == "/events" then
			print("=== EVENTOS ATIVOS ===")
			for name, event in pairs(GeneralConfig.Events) do
				print(name .. ": " .. (event.Active and "✅ ATIVO" or "❌ INATIVO"))
			end
		end
		if cmd == "/setlevel" then
			local targetName = args[2] -- nome do jogador
			local newLevel = tonumber(args[3]) -- nível desejado

			if targetName and newLevel then
				local targetPlayer = game.Players:FindFirstChild(targetName)
				if targetPlayer then
					local profile = ProfileService.getProfile(targetPlayer)
					if profile then
						profile.Stats.Level = newLevel
						profile.Stats.Experience = 0
						profile.Stats.ExperienceToNextLevel =
							math.floor(100 * (newLevel ^ GeneralConfig.Config.ExpGrowthRate))
						profile.Stats.AvailablePoints = profile.Stats.AvailablePoints
							+ (newLevel * GeneralConfig.Config.LevelUpPoints)

						StatsService.calculate(profile)
						ClientService.sendStats(player)

						print("✅ " .. player.Name .. " agora está no nível " .. newLevel)
					else
						warn("Perfil não carregado para " .. targetName)
					end
				else
					warn("Jogador não encontrado: " .. targetName)
				end
			else
				print("Uso: /setlevel [PlayerName] [Level]")
			end
		end
	end)
end)
