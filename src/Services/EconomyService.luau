local ServerScriptService = game:GetService("ServerScriptService")
local ProfileService = require(ServerScriptService.Services.ProfileService)
local module = {}

-- Função Privada para validar se o perfil e a moeda existem (evita repetição de código)
local function getCurrenciePath(player, currencyType)
	local profile = ProfileService.getProfile(player)
	if profile and profile.Currencies and profile.Currencies[currencyType] ~= nil then
		return profile.Currencies
	end
	return nil
end

function module.AddCurrencie(player: Player, currencyType: string, amount: number)
	local Currencies = getCurrenciePath(player, currencyType)
	if Currencies then
		print("Antes:", Currencies[currencyType])
		Currencies[currencyType] += math.abs(amount)
		print("Depois:", Currencies[currencyType])
	else
		warn("Moeda inválida ou Perfil não carregado: " .. currencyType)
	end
end

function module.SetCurrencie(player: Player, currencyType: string, amount: number)
	local Currencies = getCurrenciePath(player, currencyType)
	if Currencies then
		Currencies[currencyType] = amount
	end
end

function module.RemoveCurrencie(player: Player, currencyType: string, amount: number)
	local Currencies = getCurrenciePath(player, currencyType)
	if Currencies then
		-- Impede que o dinheiro fique negativo
		local currentAmount = Currencies[currencyType]
		Currencies[currencyType] = math.max(0, currentAmount - math.abs(amount))
	end
end

-- FUNÇÃO NOVA: Útil para lojas!
function module.CanAfford(player: Player, currencyType: string, amount: number): boolean
	local Currencies = getCurrenciePath(player, currencyType)
	if Currencies then
		return Currencies[currencyType] >= amount
	end
	return false
end

function module.GetCurrencie(player: Player, currencyType: string)
	local Currencies = getCurrenciePath(player, currencyType)
	if Currencies then
		return Currencies[currencyType]
	end
	warn("Moeda inválida ou Perfil não carregado: " .. currencyType)
	return nil
end

return module
