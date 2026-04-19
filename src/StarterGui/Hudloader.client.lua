game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local UpdateHud = ReplicatedStorage:WaitForChild("Events"):WaitForChild("UpdateHud")
local OnClientUpdate = ReplicatedStorage:WaitForChild("Events"):WaitForChild("OnClientUpdate")

-- 1. Pede os dados ao servidor
OnClientUpdate:FireServer("ready")

-- 2. Espera receber os dados antes de criar a HUD
local initialData = nil
local dataReceived = Instance.new("BindableEvent")

local tempConn
tempConn = UpdateHud.OnClientEvent:Connect(function(updateType, data)
	if updateType == "all" and data then
		initialData = data
		tempConn:Disconnect()
		dataReceived:Fire()
	end
end)

dataReceived.Event:Wait()
dataReceived:Destroy()

-- 3. Agora cria a HUD com os valores já prontos
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.fromOffset(280, 210)
mainFrame.Position = UDim2.fromOffset(16, 16)
mainFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 6)

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 10)
uiPadding.PaddingBottom = UDim.new(0, 10)
uiPadding.PaddingLeft = UDim.new(0, 12)
uiPadding.PaddingRight = UDim.new(0, 12)
uiPadding.Parent = mainFrame

local uiList = Instance.new("UIListLayout")
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 8)
uiList.Parent = mainFrame

local levelLabel = Instance.new("TextLabel")
levelLabel.Name = "Level"
levelLabel.Size = UDim2.new(1, 0, 0, 18)
levelLabel.BackgroundTransparency = 1
levelLabel.Text = "Level 5"
levelLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
levelLabel.TextSize = 14
levelLabel.Font = Enum.Font.GothamMedium
levelLabel.TextXAlignment = Enum.TextXAlignment.Left
levelLabel.LayoutOrder = 1
levelLabel.Parent = mainFrame

local function createBar(name, fillColor, layoutOrder, hasGhost)
	local container = Instance.new("Frame")
	container.Name = name .. "Container"
	container.Size = UDim2.new(1, 0, 0, 32)
	container.BackgroundTransparency = 1
	container.LayoutOrder = layoutOrder
	container.Parent = mainFrame

	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 3)
	listLayout.Parent = container

	local track = Instance.new("Frame")
	track.Name = "Track"
	track.Size = UDim2.new(1, 0, 0, 18)
	track.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
	track.BorderSizePixel = 0
	track.LayoutOrder = 1
	track.Parent = container
	Instance.new("UICorner", track).CornerRadius = UDim.new(0, 3)

	local ghost = nil
	if hasGhost then
		ghost = Instance.new("Frame")
		ghost.Name = "Ghost"
		ghost.Size = UDim2.fromScale(1, 1)
		ghost.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
		ghost.BorderSizePixel = 0
		ghost.ZIndex = 1
		ghost.Parent = track
		Instance.new("UICorner", ghost).CornerRadius = UDim.new(0, 2)
	end

	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.fromScale(1, 1)
	fill.BackgroundColor3 = fillColor
	fill.BorderSizePixel = 0
	fill.ZIndex = 2
	fill.Parent = track
	Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 2)

	local labelRow = Instance.new("Frame")
	labelRow.Size = UDim2.new(1, 0, 0, 11)
	labelRow.BackgroundTransparency = 1
	labelRow.LayoutOrder = 2
	labelRow.Parent = container

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.fromScale(0.5, 1)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = name
	nameLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
	nameLabel.TextSize = 11
	nameLabel.Font = Enum.Font.GothamMedium
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = labelRow

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Name = "Value"
	valueLabel.Size = UDim2.fromScale(0.5, 1)
	valueLabel.Position = UDim2.fromScale(0.5, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = "-- / --"
	valueLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
	valueLabel.TextSize = 11
	valueLabel.Font = Enum.Font.Gotham
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = labelRow

	return fill, valueLabel, ghost
end

local vidaFill, vidaValue, vidaGhost = createBar("Vida", Color3.fromRGB(122, 26, 26), 2, true)
local staminaFill, staminaVal = createBar("Stamina", Color3.fromRGB(26, 74, 122), 3)
local expFill, expValue = createBar("Exp", Color3.fromRGB(122, 74, 16), 4)

-- Bottom row
local bottomRow = Instance.new("Frame")
bottomRow.Name = "BottomRow"
bottomRow.Size = UDim2.new(1, 0, 0, 44)
bottomRow.BackgroundTransparency = 1
bottomRow.LayoutOrder = 5
bottomRow.Parent = mainFrame

local bottomList = Instance.new("UIListLayout")
bottomList.FillDirection = Enum.FillDirection.Horizontal
bottomList.SortOrder = Enum.SortOrder.LayoutOrder
bottomList.Padding = UDim.new(0, 6)
bottomList.Parent = bottomRow

local backpackBtn = Instance.new("TextButton")
backpackBtn.Name = "BackpackBtn"
backpackBtn.Size = UDim2.fromOffset(64, 44)
backpackBtn.BackgroundColor3 = Color3.fromRGB(26, 0, 0)
backpackBtn.BorderSizePixel = 0
backpackBtn.Text = "🎒"
backpackBtn.TextSize = 22
backpackBtn.LayoutOrder = 1
backpackBtn.Parent = bottomRow
Instance.new("UICorner", backpackBtn).CornerRadius = UDim.new(0, 5)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(139, 26, 26)
stroke.Thickness = 2
stroke.Parent = backpackBtn

local function createCurrency(name, symbol, color, layoutOrder)
	local card = Instance.new("Frame")
	card.Name = name
	card.Size = UDim2.new(0, 88, 1, 0)
	card.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
	card.BorderSizePixel = 0
	card.LayoutOrder = layoutOrder
	card.Parent = bottomRow
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 5)

	local stroke2 = Instance.new("UIStroke")
	stroke2.Color = Color3.fromRGB(42, 42, 42)
	stroke2.Thickness = 1
	stroke2.Parent = card

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingTop = UDim.new(0, 5)
	padding.Parent = card

	local labelList = Instance.new("UIListLayout")
	labelList.SortOrder = Enum.SortOrder.LayoutOrder
	labelList.Padding = UDim.new(0, 1)
	labelList.Parent = card

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 14)
	lbl.BackgroundTransparency = 1
	lbl.Text = symbol .. " " .. name
	lbl.TextColor3 = color
	lbl.TextSize = 10
	lbl.Font = Enum.Font.GothamMedium
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.LayoutOrder = 1
	lbl.Parent = card

	local val = Instance.new("TextLabel")
	val.Name = "Value"
	val.Size = UDim2.new(1, 0, 0, 18)
	val.BackgroundTransparency = 1
	val.Text = "0"
	val.TextColor3 = Color3.fromRGB(200, 200, 200)
	val.TextSize = 14
	val.Font = Enum.Font.GothamMedium
	val.TextXAlignment = Enum.TextXAlignment.Left
	val.LayoutOrder = 2
	val.Parent = card

	return val
end

local fragValue = createCurrency("Frags", "◆", Color3.fromRGB(239, 159, 39), 2)
local moneyValue = createCurrency("Money", "◆", Color3.fromRGB(100, 200, 100), 3)

-- 4. Popula com os dados iniciais
local function formatNumber(n)
	if not n then
		return "0"
	end
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function updateBar(fill, valueLabel, current, max)
	local pct = max > 0 and math.clamp(current / max, 0, 1) or 0
	fill.Size = UDim2.fromScale(pct, 1)
	valueLabel.Text = formatNumber(current) .. " / " .. formatNumber(max)
end

-- Stamina inicial
if initialData.CurrentStamina and initialData.MaxStamina then
	updateBar(staminaFill, staminaVal, initialData.CurrentStamina, initialData.MaxStamina)
end

-- Currencies iniciais
if initialData.Fragments then
	fragValue.Text = formatNumber(initialData.Fragments)
end
if initialData.Money then
	moneyValue.Text = formatNumber(initialData.Money)
end

-- 5. Vida via Humanoid diretamente
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local lastDamageTime = 0
local delayTime = 0.4

local function updateVida()
	local current = humanoid.Health
	local max = humanoid.MaxHealth
	local percent = math.clamp(current / max, 0, 1)

	vidaValue.Text = math.floor(current) .. " / " .. math.floor(max)

	if vidaFill.Size.X.Scale < percent then
		TweenService:Create(vidaFill, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
			Size = UDim2.fromScale(percent, 1),
		}):Play()
		vidaGhost.Size = UDim2.fromScale(percent, 1)
	end

	if vidaFill.Size.X.Scale > percent then
		vidaFill.Size = UDim2.fromScale(percent, 1)
		lastDamageTime = tick()
		task.delay(delayTime, function()
			if tick() - lastDamageTime >= delayTime then
				TweenService:Create(vidaGhost, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.fromScale(percent, 1),
				}):Play()
			end
		end)
	end
end

humanoid.HealthChanged:Connect(updateVida)
humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
	local percent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
	vidaFill.Size = UDim2.fromScale(percent, 1)
	vidaGhost.Size = UDim2.fromScale(percent, 1)
	vidaValue.Text = math.floor(humanoid.Health) .. " / " .. math.floor(humanoid.MaxHealth)
end)

updateVida()

-- 6. Escuta updates futuros
UpdateHud.OnClientEvent:Connect(function(updateType, data)
	if not data then
		return
	end

	if updateType == "all" or updateType == "energies" then
		if data.CurrentStamina and data.MaxStamina then
			updateBar(staminaFill, staminaVal, data.CurrentStamina, data.MaxStamina)
		end
	end

	if updateType == "all" or updateType == "currencies" then
		if data.Fragments then
			fragValue.Text = formatNumber(data.Fragments)
		end
		if data.Money then
			moneyValue.Text = formatNumber(data.Money)
		end
	end
end)
