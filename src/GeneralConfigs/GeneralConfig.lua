local GeneralConfig = {}
-- Dica: usar principalmente para informações que precisam ser acessadas tanto pelo servidor quanto pelo cliente, como as configurações de eventos, multiplicadores, etc. Evitar colocar coisas muito específicas de servidor ou cliente aqui para não misturar responsabilidades.s
GeneralConfig.Config = {
	MaxLevel = 15,
	ExpGrowthRate = 0.8,
	LevelUpPoints = 3,
	MaxPointsPerStat = 100,
	MaxHealth = 100,
	MaxStamina = 100,
	MaxNen = 100,
	BaseAttackPower = 10,
	BaseDefense = 0,
	BaseCritChance = 5,
	BaseCritDamage = 100,
	BaseWalkSpeed = 16,
}
--eventos no jogo como double exp, eventos de drop, etc
GeneralConfig.Events = {
	DoubleExp = {
		Active = true,
		EXPMultiplier = 2.0,
	},
	DropRateBoost = {
		Active = true,
		DropMultiplier = 1.5,
	},
	WeekendEvent = {
		Active = true,
		ExpMultiplier = 1.5,
		DropMultiplier = 1.5,
	},
	DoubleLuck = {
		Active = false,
		LuckMultiplier = 2.0,
	},
	HalloweenEvent = {
		Active = false,
		CostumeDropRate = 0.1,
		DropMultiplier = 1.5,
	},
	TestEVENT = {
		Active = false,
		ExpMultiplier = 0.5,
		Multiplier = 1.5,
	},
}

return GeneralConfig
