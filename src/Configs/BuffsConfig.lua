local BuffsConfig = {}

BuffsConfig.Races = {
	Human = {
		Strength = 0,
		Constitution = 0,
		Dexterity = 0,
		Intelligence = 0,
		WalkSpeed = 0,
	},
	Chimera = {
		Strength = 10,
		Constitution = 15,
		Dexterity = 9,
		Intelligence = -3,
		WalkSpeed = 10,
	},
	CursedSpirit = {
		Strength = 7,
		Constitution = 10,
		Dexterity = 6,
		Intelligence = 12,
		WalkSpeed = 7,
	},
	HalfCursed = {
		Strength = 9,
		Constitution = 13,
		Dexterity = 8,
		Intelligence = 10,
		WalkSpeed = 9,
	},
}

BuffsConfig.Clans = {
	None = {
		Multipliers = {
			Str = 1.0,
			Health = 1.0,
			Def = 1.0,
			Dmg = 1.0,
		},
	},
	--clans communs/aprendizes
	Kyoto = {
		Rarity = "Apprentice",
		Multipliers = {
			Str = 1.06,
			Health = 1.05,
			Def = 0.93,
			Dmg = 1.0, --- +6% de str, +5% de vida, -7% de defesa
		},
	},
	Daichi = {
		Rarity = "Apprentice",
		Multipliers = {
			Str = 1.7,
			Health = 1.07,
			Def = 0.97,
			Dmg = 1.0, --- +7% de str, +7% de vida -3% de defesa
		},
	},

	Renjiro = {
		Rarity = "Apprentice",
		Multipliers = {
			Str = 1.03,
			Health = 1.03,
			Def = 1.0,
			Dmg = 1.0, --- +3% de str, +3% de vida
		},
	},

	Katsuro = {
		Rarity = "Apprentice",
		Multipliers = {
			Str = 1.02,
			Health = 1.07,
			Def = 0.96,
			Dmg = 1.0, --- +2% de str, +7% de vida, -4% de defesa
		},
	},
	Akuro = {
		Rarity = "Apprentice",
		Multipliers = {
			Str = 1.04,
			Health = 0.95,
			Def = 0.95,
			Dmg = 1.0, --- +4% de str, -5% de vida, -5% de defesa
		},
	},
	Shinrai = {
		Rarity = "Apprentice",
		Multipliers = {
			Str = 1.0,
			Health = 1.02,
			Def = 1.03,
			Dmg = 1.0, --- +2% de vida, +3% de defesa
		},
	},

	--Clans Incomuns/Junior

	Kurohane = {
		Rarity = "Junior",
		Multipliers = {
			Str = 1.09,
			Health = 1.02,
			Def = 0.94,
			Dmg = 1.02, --- +9% de str, +2% de vida, +2% de dano -6% de defesa
		},
	},

	Renzaki = {
		Rarity = "Junior",
		Multipliers = {
			Str = 1.08,
			Health = 1.05,
			Def = 1.0,
			Dmg = 1.0, --- +8% de str, +5% de vida, +0% de dano, +0% de defesa
		},
	},
	Tatsumi = {
		Rarity = "Junior",
		Multipliers = {
			Str = 1.10,
			Health = 1.0,
			Def = 0.85,
			Dmg = 1.03, --- +10% de str, +0% de vida, +3% de dano, -15% de defesa
		},
	},
	Hoshiro = {
		Rarity = "Junior",
		Multipliers = {
			Str = 1.08,
			Health = 1.02,
			Def = 0.95,
			Dmg = 1.0, --- +8% de str, +2% de vida, -5% de defesa, +0% de dano
		},
	},

	Makoto = {
		Rarity = "Junior",
		Multipliers = {
			Str = 1.0,
			Health = 1.08,
			Def = 1.02,
			Dmg = 1.05, --- +0% de str, +8% de vida, +2% de defesa, +5% de dano
		},
	},
	--Clans Epicos/Specialist
	Itadori = {
		Multipliers = {
			Str = 1.10,
			Health = 0.9,
			Def = 1.07,
			Dmg = 1.06, --- +10% de str, -10% de vida, +7% de defesa, +6% de dano
		},
	},
	Kurta = {
		Rarity = "Specialist",
		Multipliers = {
			Str = 1.03,
			Health = 1.10,
			Def = 1.05,
			Dmg = 1.08, --- +3% de str, +10% de vida, +5% de defesa, +8% de dano
		},
	},
	Fushigurou = {
		Rarity = "Specialist",
		Multipliers = {
			Str = 1.12,
			Health = 0.85,
			Def = 1.1,
			Dmg = 1.08, --- +12% de str, -15% de vida, +10% de defesa, +8% de dano
		},
	},

	--Elite/Especial

	Yuki = {
		Rarity = "Elite",
		Multipliers = {
			Str = 1.04,
			Health = 0.85,
			Def = 0.75,
			Dmg = 1.09, --- +4% de str, -15% de vida, -25% de defesa, +9% de dano
		},
	},
	Kugisaki = {
		Rarity = "Elite",
		Multipliers = {
			Str = 1.09,
			Health = 1.15,
			Def = 1.10,
			Dmg = 1.03, --- +9% de str, +15% de vida, +10% de defesa, +1% de dano
		},
	},
	Okkotsu = {
		Rarity = "Elite",
		Multipliers = {
			Str = 1.15,
			Health = 0.85,
			Def = 1.0,
			Dmg = 1.8, --- +15% de str, -15% de vida, +0% de defesa, +8% de dano
		},
	},
	Inumaki = {
		Rarity = "Elite",
		Multipliers = {
			Str = 1.0,
			Health = 0.96,
			Def = 0.97,
			Dmg = 1.09, --- +0% de str, -4% de vida, -3% de defesa, +9% de dano
		},
	},
	Geto = {
		Rarity = "Elite",
		Multipliers = {
			Str = 1.09,
			Health = 1.0,
			Def = 1.0,
			Dmg = 1.05, --- +9% de str, +0% de vida, +0% de defesa, +5% de dano
		},
	},

	--Clans Lendarios/Beyond
	Zoldyck = {
		Rarity = "Beyond",
		Multipliers = {
			Str = 1.13,
			Health = 0.95,
			Def = 1.14,
			Dmg = 1.11, --- +13% de str, -5% de vida, +14% de defesa, +11% de dano
		},
	},

	Netero = {
		Rarity = "Beyond",
		Multipliers = {
			Str = 1.12,
			Health = 1.08,
			Def = 1.02,
			Dmg = 1.15, --- +12% de str, +8% de vida, +2% de defesa, +15% de dano
		},
	},

	Zenin = {
		Rarity = "Beyond",
		Multipliers = {
			Str = 1.10,
			Health = 1.0,
			Def = 1.19,
			Dmg = 1.09, --- +10% de str, +0% de vida, +19% de defesa, +9% de dano
		},
	},
	Gojo = {
		Rarity = "Beyond",
		Multipliers = {
			Str = 1.09,
			Health = 1.13,
			Def = 0.85,
			Dmg = 1.10, --- +9% de str, +13% de vida, -15% de defesa, +10% de dano
		},
	},

	Kamo = {
		Rarity = "Beyond",
		Multipliers = {
			Str = 1.07,
			Health = 0.85,
			Def = 0.95,
			Dmg = 1.12, --- +7% de str, -15% de vida, -5% de defesa, +12% de dano
		},
	},

	--Clans Secretos/???
	Freecss = {
		Rarity = "Secret",
		Multipliers = {
			Str = 1.15,
			Health = 0.90,
			Def = 1.08,
			Dmg = 1.18, --- +15% de str, -10% de vida, +8% de defesa, +18% de dano
		},
	},
}
-- ainda ta incompleto falta as passivas
BuffsConfig.Bloodlines = {
	None = {
		CritChance = 0,
		CritDamage = 0,
	},
	Uchiha = {
		CritChance = 15,
		CritDamage = 30,
	},
	Senju = {
		CritChance = 8,
		CritDamage = 20,
	},
	Hyuga = {
		CritChance = 12,
		CritDamage = 25,
	},
}

return BuffsConfig
