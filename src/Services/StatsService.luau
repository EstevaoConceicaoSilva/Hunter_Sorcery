local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProfileService = require(ServerScriptService.Services.ProfileService)
local ClientService = require(ServerScriptService.Services.ClientService)
local BuffsConfig = require(ServerScriptService.Configs.BuffsConfig)
local GeneralConfig = require(ReplicatedStorage.GeneralConfigs.GeneralConfig)
local StatsService = {}

local function getStats(player)
	local profile = ProfileService.getProfile(player)
	if not profile then
		return nil
	end
	return profile.Stats
end

function StatsService.calculate(profile)
	local stats = profile.Stats

	local raceBuff = BuffsConfig.Races[profile.Profile.Race] or BuffsConfig.Races.Human
	local clanBuff = BuffsConfig.Clans[profile.Profile.Clan] or BuffsConfig.Clans.None
	local bloodlineBuff = BuffsConfig.Bloodlines[profile.Profile.Bloodline] or BuffsConfig.Bloodlines.None

	stats.FixedBuffs.Strength = raceBuff.Strength
	stats.FixedBuffs.Constitution = raceBuff.Constitution
	stats.FixedBuffs.Dexterity = raceBuff.Dexterity
	stats.FixedBuffs.Intelligence = raceBuff.Intelligence
	stats.FixedBuffs.CritChance = bloodlineBuff.CritChance
	stats.FixedBuffs.CritDamage = bloodlineBuff.CritDamage
	stats.FixedBuffs.WalkSpeed = raceBuff.WalkSpeed
	stats.FixedBuffs.Multipliers = {
		Str = clanBuff.Multipliers.Str,
		Health = clanBuff.Multipliers.Health,
		Def = clanBuff.Multipliers.Def,
		Dmg = clanBuff.Multipliers.Dmg,
	}

	local equipBuffs = {
		Strength = 0,
		Constitution = 0,
		Dexterity = 0,
		Intelligence = 0,
		Health = 0,
		Multipliers = { Str = 1, Health = 1, Def = 1, Dmg = 1 },
	}

	--for slot, item in pairs(profile.Equipment) do
	--if item and item.Buffs then
	--for stat, value in pairs(item.Buffs) do
	--if stat == "Multipliers" then
	--for mult, multValue in pairs(value) do
	--equipBuffs.Multipliers[mult] = equipBuffs.Multipliers[mult] * multValue
	--end
	--else
	--equipBuffs[stat] = equipBuffs[stat] + value
	--end
	--end
	--end
	--end

	local finalStr = stats.Strength + stats.FixedBuffs.Strength + equipBuffs.Strength
	local finalCon = stats.Constitution + stats.FixedBuffs.Constitution + equipBuffs.Constitution
	local finalDex = stats.Dexterity + stats.FixedBuffs.Dexterity + equipBuffs.Dexterity
	local finalInt = stats.Intelligence + stats.FixedBuffs.Intelligence + equipBuffs.Intelligence

	local totalMult = {
		Str = stats.FixedBuffs.Multipliers.Str * equipBuffs.Multipliers.Str,
		Health = stats.FixedBuffs.Multipliers.Health * equipBuffs.Multipliers.Health,
		Def = stats.FixedBuffs.Multipliers.Def * equipBuffs.Multipliers.Def,
		Dmg = stats.FixedBuffs.Multipliers.Dmg * equipBuffs.Multipliers.Dmg,
	}

	stats.Calculated.MaxHealth =
		math.floor((GeneralConfig.Config.MaxHealth + (finalCon * 10) + equipBuffs.Health) * totalMult.Health)
	stats.Calculated.MaxStamina = math.floor(GeneralConfig.Config.MaxStamina + (finalDex * 5))
	stats.Calculated.MaxNen = math.floor(GeneralConfig.Config.MaxNen + (finalInt * 8))
	stats.Calculated.AttackPower =
		math.floor((GeneralConfig.Config.BaseAttackPower + (finalStr * 2)) * totalMult.Str * totalMult.Dmg)
	stats.Calculated.Defense = math.floor((finalDex * 1.5) * totalMult.Def)
	stats.Calculated.CritChance = GeneralConfig.Config.BaseCritChance + stats.FixedBuffs.CritChance
	stats.Calculated.CritDamage = GeneralConfig.Config.BaseCritDamage + stats.FixedBuffs.CritDamage
	stats.Calculated.WalkSpeed = GeneralConfig.Config.BaseWalkSpeed + stats.FixedBuffs.WalkSpeed

	return stats.Calculated
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
		StatsService.calculate(profile) -- recalcula tudo
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
		StatsService.calculate(profile) -- recalcula tudo
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

	StatsService.calculate(profile)
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

	StatsService.calculate(profile)
	ClientService.sendStats(player)

	local SyncStats = require(ServerScriptService.Services.SyncStats)
	SyncStats.syncPlayer(player)

	return true
end

function StatsService.syncPlayer(player)
	local profile = ProfileService.getProfile(player)
	if not profile then
		return
	end

	-- Recalcula stats com buffs
	StatsService.calculate(profile)

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
		StatsService.syncPlayer(player)
	end)
end)

return StatsService
