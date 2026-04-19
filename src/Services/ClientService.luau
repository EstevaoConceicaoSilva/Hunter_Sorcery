local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ProfileService = require(ServerScriptService.Services.ProfileService)

-- Remotes
local events = ReplicatedStorage:WaitForChild("Events")
local OnClientUpdate = events:WaitForChild("OnClientUpdate")
local UpdateHud = events:WaitForChild("UpdateHud")

local ClientService = {}

-- Coleta os dados do jogador
local function collectData(player)
	local profile = ProfileService.getProfile(player)
	if not profile then
		return nil
	end

	local statusFolder = player:FindFirstChild("Status")
	local function getValue(name)
		local obj = statusFolder and statusFolder:FindFirstChild(name)
		return obj and obj.Value or 0
	end

	return {
		Fragments = profile.Currencies.Fragments,
		Money = profile.Currencies.Money,
		StatsBase = profile.StatsBase,
		CurrentStamina = getValue("CurrentStaminaValue"),
		MaxStamina = getValue("MaxStaminaValue"),
		CurrentNen = getValue("CurrentNenValue"),
		MaxNen = getValue("MaxNenValue"),
	}
end

-- Envia todos os dados pro cliente
function ClientService.sendAll(player)
	local data = collectData(player)
	if not data then
		return
	end
	UpdateHud:FireClient(player, "all", data)
end
--movido para cá pra garantir que o evento já exista quando o cliente tentar se conectar
OnClientUpdate.OnServerEvent:Connect(function(player, action)
	if action == "ready" then
		-- Espera o perfil estar disponível antes de enviar
		local profile
		local attempts = 0
		while not profile and attempts < 100 do
			task.wait(0.1)
			attempts += 1
			profile = ProfileService.getProfile(player)
		end
		if profile then
			ClientService.sendAll(player)
		end
	end
end)

-- Envia só as currencies
function ClientService.sendCurrencies(player)
	local profile = ProfileService.getProfile(player)
	if not profile then
		warn("sendCurrencies: perfil nil para " .. player.Name)
		return
	end
	print("Enviando currencies:", profile.Currencies.Money, profile.Currencies.Fragments)
	UpdateHud:FireClient(player, "currencies", {
		Fragments = profile.Currencies.Fragments,
		Money = profile.Currencies.Money,
	})
end

-- Envia as estatisticas que modficam constantemente
function ClientService.sendEnergies(player)
	local statusFolder = player:FindFirstChild("Status")
	local function getValue(name)
		local obj = statusFolder and statusFolder:FindFirstChild(name)
		return obj and obj.Value or 0
	end
	UpdateHud:FireClient(player, "energies", {
		CurrentStamina = getValue("CurrentStaminaValue"),
		MaxStamina = getValue("MaxStaminaValue"),
		CurrentNen = getValue("CurrentNenValue"),
		MaxNen = getValue("MaxNenValue"),
		CurrentHealth = getValue("CurrentHealthValue"), -- ✅ novo
		MaxHealth = getValue("MaxHealthValue"), -- ✅ novo
	})
end

-- Envia só stats
function ClientService.sendStats(player)
	local profile = ProfileService.getProfile(player)
	if not profile then
		return
	end
	UpdateHud:FireClient(player, "stats", {
		StatsBase = profile.Stats,
		Profile = profile.Profile,
	})
end

-- Setup automático ao entrar
Players.PlayerAdded:Connect(function(player)
	local profile
	local attempts = 0
	while not profile and attempts < 100 do
		task.wait(0.1)
		attempts += 1
		profile = ProfileService.getProfile(player)
	end
	if not profile then
		return
	end

	-- Observa mudanças nos Values de stamina/nen
	local statusFolder = player:WaitForChild("Status", 10)
	if statusFolder then
		for _, valueObj in ipairs(statusFolder:GetChildren()) do
			valueObj.Changed:Connect(function()
				ClientService.sendEnergies(player)
			end)
		end
	end
end)

return ClientService
