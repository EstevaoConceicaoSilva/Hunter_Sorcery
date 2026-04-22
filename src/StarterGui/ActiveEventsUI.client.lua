--local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UpdateHud = ReplicatedStorage:WaitForChild("Events"):WaitForChild("UpdateHud")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EventsUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local container = Instance.new("Frame")
container.Size = UDim2.fromOffset(200, 0)
container.Position = UDim2.new(1, -210, 0, 10)
container.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
container.BackgroundTransparency = 0.3
container.BorderSizePixel = 0
container.AutomaticSize = Enum.AutomaticSize.Y
container.Parent = screenGui
Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 8)
padding.PaddingRight = UDim.new(0, 8)
padding.PaddingTop = UDim.new(0, 8)
padding.PaddingBottom = UDim.new(0, 8)
padding.Parent = container

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.Parent = container

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 20)
title.BackgroundTransparency = 1
title.Text = "🎉 EVENTOS ATIVOS"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 12
title.Font = Enum.Font.GothamBold
title.Parent = container

-- Função para adicionar evento
local function addEventLabel(eventName)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 16)
	label.BackgroundTransparency = 1
	label.Text = "✨ " .. eventName
	label.TextColor3 = Color3.fromRGB(100, 255, 100)
	label.TextSize = 10
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container
	return label
end

UpdateHud.OnClientEvent:Connect(function(updateType, data)
	if not data then
		return
	end

	-- Só tenta mexer na UI de eventos se o pacote for de eventos ou o pacote geral
	if updateType == "all" or updateType == "events" then
		-- Agora sim verificamos se a chave veio no pacote
		if not data.ActiveEvents then
			-- Só avisa se o servidor explicitamente mandou um pacote "events" vazio/quebrado
			if updateType == "events" then
				warn("Pacote 'events' recebido, mas sem a tabela ActiveEvents!")
			end
			return
		end

		-- Limpa labels antigos
		for _, child in ipairs(container:GetChildren()) do
			if child:IsA("TextLabel") and child ~= title then
				child:Destroy()
			end
		end

		-- Cria os novos
		if type(data.ActiveEvents) == "table" and #data.ActiveEvents > 0 then
			for _, event in ipairs(data.ActiveEvents) do
				addEventLabel(event.Name)
			end
		else
			-- Opcional: Você pode colocar um label dizendo "Nenhum evento ativo"
			print("Nenhum evento ativo rolando no momento.")
		end
	end
end)
