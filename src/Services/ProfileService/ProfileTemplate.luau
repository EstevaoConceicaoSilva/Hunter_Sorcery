return {
	Profile = {
		Races = "Human",
		Clan = "None",
		Bloodline = "None",
		Traits = "None", --Mudou de array para string
		Artifacts = "None", -- irei fazer mais tarde
		nen_Color = "None",
		NenType = "None",
		NenTraits = {},
	},

	Currencies = {
		Money = 0,
		Fragments = 0,
	},

	--adicionado Sistema de Exp e alocação de pontos, Sistema mais Complexo para salvar Buffs ,
	--Sistema para salvar os stats calculados,Base para o sistema de equipamentos e inventário.

	Stats = {
		Level = 1,
		Experience = 0,
		ExperienceToNextLevel = 100,
		AvailablePoints = 0,

		Strength = 1,
		Constitution = 1,
		Dexterity = 1,
		Intelligence = 1,

		FixedBuffs = {
			Strength = 0,
			Constitution = 0,
			Dexterity = 0,
			Intelligence = 0,
			CritChance = 0,
			CritDamage = 0,
			WalkSpeed = 0,
			Multipliers = {
				Str = 1.0,
				Health = 1.0,
				Def = 1.0,
				Dmg = 1.0,
			},
		},

		Calculated = {
			MaxHealth = 100,
			MaxStamina = 100,
			MaxNen = 100,
			AttackPower = 10,
			Defense = 0,
			CritChance = 5,
			CritDamage = 100,
			WalkSpeed = 16,
		},
	},

	Equipment = {
		Helmet = nil,
		Chest = nil,
		Legs = nil,
		Boots = nil,
		Weapon = nil,
		Accessory1 = nil,
		Accessory2 = nil,
	},

	Inventory = {},
}
