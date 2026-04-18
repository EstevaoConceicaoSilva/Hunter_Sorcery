local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ProfileService = require(ServerScriptService.Services.ProfileService)
local ClientService = require(ServerScriptService.Services.ClientService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UpdateHud = ReplicatedStorage:WaitForChild("Events"):WaitForChild("UpdateHud")

Players.PlayerAdded:Connect(function(player)
	local profile
	local attempts = 0
	while not profile and attempts < 100 do
		task.wait(0.1)
		attempts += 1
		profile = ProfileService.getProfile(player)
	end
	if not profile then
		warn("Perfil não carregado para " .. player.Name)
		return
	end

	-- Lembre-se de usar .Data para acessar as informações do ProfileService
	local stats = profile.StatsBase

	-- 1. CÁLCULO DOS MÁXIMOS (Sua lógica: Base + Pontos * 0.3)
	local calculatedMaxStamina = math.floor(stats.BaseStaminaEnergy + (stats.Dexterity * 0.3))
	local calculatedMaxNen = math.floor(stats.BaseNenEnergy + (stats.Nen * 0.5))
	local calculatedMaxHealth = math.floor(100 + (stats.Constitution * stats.Multipliers.Health * 50))

	local statusFolder = player:FindFirstChild("Status") or Instance.new("Folder")
	statusFolder.Name = "Status"
	statusFolder.Parent = player

	-- STAMINA
	local currentStamina = Instance.new("NumberValue")
	currentStamina.Name = "CurrentStaminaValue"
	currentStamina.Value = calculatedMaxStamina
	currentStamina.Parent = statusFolder

	local maxStamina = Instance.new("NumberValue")
	maxStamina.Name = "MaxStaminaValue"
	maxStamina.Value = calculatedMaxStamina
	maxStamina.Parent = statusFolder

	-- NEN
	local currentNen = Instance.new("NumberValue")
	currentNen.Name = "CurrentNenValue"
	currentNen.Value = calculatedMaxNen
	currentNen.Parent = statusFolder

	local maxNen = Instance.new("NumberValue")
	maxNen.Name = "MaxNenValue"
	maxNen.Value = calculatedMaxNen
	maxNen.Parent = statusFolder

	-- Cria os Values
	local currentHealth = Instance.new("NumberValue")
	currentHealth.Name = "CurrentHealthValue"
	currentHealth.Value = calculatedMaxHealth
	currentHealth.Parent = statusFolder

	local maxHealth = Instance.new("NumberValue")
	maxHealth.Name = "MaxHealthValue"
	maxHealth.Value = calculatedMaxHealth
	maxHealth.Parent = statusFolder

	local function setupHumanoid(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.MaxHealth = calculatedMaxHealth
		humanoid.Health = calculatedMaxHealth
		humanoid.HealthChanged:Connect(function(health)
			currentHealth.Value = math.floor(health)
			ClientService.sendEnergies(player)
		end)
	end

	setupHumanoid(player.Character or player.CharacterAdded:Wait())
	player.CharacterAdded:Connect(setupHumanoid)

	player:SetAttribute("MaxStamina", calculatedMaxStamina)
	player:SetAttribute("MaxNen", calculatedMaxNen)
	task.wait(0.1)
	ClientService.sendAll(player)
	--  ATUALIZA ATTRIBUTES (Sincronização extra para UI)
	print("✅ Energias de " .. player.Name .. " carregadas com sucesso!")
end)
