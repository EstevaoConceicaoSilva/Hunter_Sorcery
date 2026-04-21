local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ProfileService = require(ServerScriptService.Services.ProfileService)
local StatsCalculator = require(ServerScriptService.Services.StatsCalculator)

local SyncStats = {}

function SyncStats.syncPlayer(player)
	local profile = ProfileService.getProfile(player)
	if not profile then
		return
	end

	-- Recalcula stats com buffs
	StatsCalculator.calculate(profile)

	local calc = profile.Stats.Calculated
	local character = player.Character
	if not character then
		return
	end

	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then
		return
	end

	-- Aplica stats calculados no Humanoid
	humanoid.MaxHealth = calc.MaxHealth
	humanoid.Health = calc.MaxHealth
	humanoid.WalkSpeed = calc.WalkSpeed

	-- Atualiza Values no Status folder
	local statusFolder = player:FindFirstChild("Status")
	if statusFolder then
		local maxHealth = statusFolder:FindFirstChild("MaxHealthValue")
		if maxHealth then
			maxHealth.Value = calc.MaxHealth
		end

		local maxStamina = statusFolder:FindFirstChild("MaxStaminaValue")
		if maxStamina then
			maxStamina.Value = calc.MaxStamina
		end

		local maxNen = statusFolder:FindFirstChild("MaxNenValue")
		if maxNen then
			maxNen.Value = calc.MaxNen
		end
	end
end

-- Auto-sync quando player spawna
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		character:WaitForChild("Humanoid")
		task.wait(0.5) -- espera StatusStart criar os Values
		SyncStats.syncPlayer(player)
	end)
end)

return SyncStats
