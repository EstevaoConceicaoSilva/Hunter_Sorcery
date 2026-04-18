local players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")
local ProfileService = require(ServerScriptService.Services.ProfileService)
local EconomyService = require(ServerScriptService.Services.EconomyService)

local playersSaved = {}

local function onPlayerAdded(player: Player)
	ProfileService.loadProfile(player)
end

local function onPlayerRemoving(player: Player)
	local profile = ProfileService.getProfile(player)

	if playersSaved[player.UserId] then
		return
	end
	playersSaved[player.UserId] = true
	ProfileService.removeProfile(player)

	if profile then
		print("Dados de " .. player.Name .. " salvos: " .. HttpService:JSONEncode(profile))
	end
end

players.PlayerAdded:Connect(onPlayerAdded)
players.PlayerRemoving:Connect(onPlayerRemoving)

game:BindToClose(function()
	print("Servidor fechando, salvamento final...")
	for _, player in ipairs(players:GetPlayers()) do
		if not playersSaved[player.UserId] then
			playersSaved[player.UserId] = true
			ProfileService.removeProfile(player)
			print("✅ Save no BindToClose para " .. player.Name)
		end
	end
	task.wait(5) -- ✅ aumenta para 5 segundos
end)

-- Caso o script carregue com jogadores já lá (comum em testes rápidos)
for _, player in ipairs(players:GetPlayers()) do
	onPlayerAdded(player)
end
