return {
	Profile = {
		Races = "Human",
		Clan = "None",
		Traits = "None", --Mudou de array para string
		Artifacts = "None", -- mesma coisa
		Haki_Color = "None",
		Aura = "None",
		NenType = "None",
		NenTraits = {},
	},

	Currencies = {
		Money = 0,
		Fragments = 0,
	},

	StatsBase = {
		-- [INTEGERS] Atributos de Progressão (Pontos que o player gasta)
		Strength = 1, -- Multiplica o dano base do click
		Constitution = 1, -- Multiplica a vida base
		Dexterity = 1, -- Multiplica a Stamina e gera Defesa passiva
		Nen = 1, -- Multiplica a reserva de energia

		-- [INTEGERS] Valores de Status Atuais (Calculados)
		BaseNenEnergy = 100,
		BaseStaminaEnergy = 100,

		Defense = 0, -- Valor bruto de armaduras (Soma)

		-- [FLOATS] Multiplicadores (Buffs de Clã, Raça e Itens)
		-- O valor 1.0 significa 100% (Sem bônus)
		Multipliers = {
			Str = 1.0, -- Ex: Clã bombado coloca 1.5 aq
			Def = 1.0, -- Ex: Dexterity + Armadura multiplicado por isso
			Health = 1.0, -- Ex: Raça Tanque coloca 1.2 aq
			Dmg = 1.0, -- Buff de dano geral (Final)
			Nen = 1.0, -- Buff de reserva ou regeneração de Nen
		},

		-- [FLOATS] Status de Combate (Porcentagens)
		Crit_Chance = 5, -- 5% (Tratado como Float 0.05 no código)
		Crit_Damage = 150, -- 150% (Tratado como Float 1.5 no código)
		DamageBlock = 0, -- % de redução direta
	},
}
