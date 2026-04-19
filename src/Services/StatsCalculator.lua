local ServerScriptService = game:GetService("ServerScriptService")
local BuffsConfig = require(ServerScriptService.Configs.BuffsConfig)

local StatsCalculator = {}

function StatsCalculator.calculate(profile)
	local stats = profile.Stats

	local raceBuff = BuffsConfig.Races[profile.Profile.Race] or BuffsConfig.Races.Human
	local clanBuff = BuffsConfig.Clans[profile.Profile.Clan] or BuffsConfig.Clans.Default
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

	stats.Calculated.MaxHealth = math.floor((100 + (finalCon * 10) + equipBuffs.Health) * totalMult.Health)
	stats.Calculated.MaxStamina = math.floor(100 + (finalDex * 5))
	stats.Calculated.MaxNen = math.floor(100 + (finalInt * 8))
	stats.Calculated.AttackPower = math.floor((10 + (finalStr * 2)) * totalMult.Str * totalMult.Dmg)
	stats.Calculated.Defense = math.floor((finalDex * 1.5) * totalMult.Def)
	stats.Calculated.CritChance = 5 + stats.FixedBuffs.CritChance
	stats.Calculated.CritDamage = 150 + stats.FixedBuffs.CritDamage
	stats.Calculated.WalkSpeed = 16 + stats.FixedBuffs.WalkSpeed

	return stats.Calculated
end

return StatsCalculator
