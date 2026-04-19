local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StatsService = require(ServerScriptService.Services.StatsService)
local ExperienceService = require(ServerScriptService.Services.ExperienceService)

local allocatePoint = ReplicatedStorage.Events:WaitForChild("AllocatePoint")

allocatePoint.OnServerEvent:Connect(function(player, action, data)
	if action == "allocate" then
		StatsService.allocatePoint(player, data)
	elseif action == "reset" then
		StatsService.resetStats(player)
	elseif action == "addexp" then
		ExperienceService.addExperience(player, data)
	end
end)
