local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ProfileService = require(ServerScriptService.Services.ProfileService)
local ClientService = require(ServerScriptService.Services.ClientService)
local StatsCalculator = require(ServerScriptService.Services.StatsCalculator)

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

	local stats = profile.Stats

	-- Calcula stats iniciais
	StatsCalculator.calculate(profile)

	local calculatedMaxStamina = stats.Calculated.MaxStamina
	local calculatedMaxNen = stats.Calculated.MaxNen
	local calculatedMaxHealth = stats.Calculated.MaxHealth

	local statusFolder = player:FindFirstChild("Status") or Instance.new("Folder")
	statusFolder.Name = "Status"
	statusFolder.Parent = player

	local currentStamina = Instance.new("NumberValue")
	currentStamina.Name = "CurrentStaminaValue"
	currentStamina.Value = calculatedMaxStamina
	currentStamina.Parent = statusFolder

	local maxStamina = Instance.new("NumberValue")
	maxStamina.Name = "MaxStaminaValue"
	maxStamina.Value = calculatedMaxStamina
	maxStamina.Parent = statusFolder

	local currentNen = Instance.new("NumberValue")
	currentNen.Name = "CurrentNenValue"
	currentNen.Value = calculatedMaxNen
	currentNen.Parent = statusFolder

	local maxNen = Instance.new("NumberValue")
	maxNen.Name = "MaxNenValue"
	maxNen.Value = calculatedMaxNen
	maxNen.Parent = statusFolder

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

	task.wait(1)
	ClientService.sendAll(player)

	print("✅ Energias e Stats de " .. player.Name .. " carregados!")
end)
