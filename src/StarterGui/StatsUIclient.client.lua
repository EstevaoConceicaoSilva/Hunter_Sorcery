-- Coloque este LocalScript dentro de StarterGui/ScreenGui
-- Certifique-se de ter um RemoteEvent em ReplicatedStorage chamado "StatsRemote"

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Criando a tela
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StatsUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.fromOffset(380, 220)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 6)

local uiList = Instance.new("UIListLayout")
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 8)
uiList.Parent = mainFrame

-- Label de pontos disponíveis
local pointsLabel = Instance.new("TextLabel")
pointsLabel.Size = UDim2.new(1, 0, 0, 24)
pointsLabel.BackgroundTransparency = 1
pointsLabel.Text = "Available Points: 0"
pointsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
pointsLabel.TextSize = 16
pointsLabel.Font = Enum.Font.GothamMedium
pointsLabel.LayoutOrder = 1
pointsLabel.Parent = mainFrame

-- Função para criar botões de stats
local function createStatRow(statName)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 36)
	row.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
	row.BorderSizePixel = 0
	row.LayoutOrder = 2
	row.Parent = mainFrame
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.fromScale(0.6, 1)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = statName
	nameLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
	nameLabel.TextSize = 14
	nameLabel.Font = Enum.Font.GothamMedium
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = row

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromScale(0.4, 1)
	btn.Position = UDim2.fromScale(0.6, 0)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.Text = "+"
	btn.TextSize = 18
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.Parent = row
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
end

-- Criando linhas para cada atributo
createStatRow("Strength")
createStatRow("Constitution")
createStatRow("Dexterity")
createStatRow("Intelligence")
