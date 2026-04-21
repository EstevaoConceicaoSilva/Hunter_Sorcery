-- Em ReplicatedStorage.Events, cria "AllocatePoint" (RemoteEvent)

-- No servidor (AllocatePointHandler - Script em ServerScriptService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StatsService = require(ServerScriptService.Services.StatsService)

local allocatePoint = ReplicatedStorage.Events:WaitForChild("AllocatePoint")

allocatePoint.OnServerEvent:Connect(function(player, action, statName)
	if action == "allocate" then
		local success, msg = StatsService.allocatePoint(player, statName)
		if not success then
			warn(msg)
		end
	elseif action == "reset" then
		StatsService.resetStats(player)
	end
end)
