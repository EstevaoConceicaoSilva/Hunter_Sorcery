local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local UpdateHud = ReplicatedStorage:WaitForChild("Events"):WaitForChild("UpdateHud")
local AllocatePoint = ReplicatedStorage:WaitForChild("Events"):WaitForChild("AllocatePoint")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StatsUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 520, 0, 580)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -290)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ZIndex = 2
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(40, 40, 40)
mainStroke.Thickness = 1

local padding = Instance.new("UIPadding", mainFrame)
padding.PaddingTop = UDim.new(0, 20)
padding.PaddingBottom = UDim.new(0, 20)
padding.PaddingLeft = UDim.new(0, 20)
padding.PaddingRight = UDim.new(0, 20)

local layout = Instance.new("UIListLayout", mainFrame)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 14)

-- Header
local header = Instance.new("TextLabel")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 28)
header.BackgroundTransparency = 1
header.Text = "Status Allocation"
header.TextColor3 = Color3.fromRGB(220, 220, 220)
header.TextSize = 22
header.Font = Enum.Font.GothamBold
header.TextXAlignment = Enum.TextXAlignment.Left
header.LayoutOrder = 1
header.Parent = mainFrame

-- Player Info Row
local infoRow = Instance.new("Frame")
infoRow.Name = "InfoRow"
infoRow.Size = UDim2.new(1, 0, 0, 60)
infoRow.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
infoRow.BorderSizePixel = 0
infoRow.LayoutOrder = 2
infoRow.Parent = mainFrame
Instance.new("UICorner", infoRow).CornerRadius = UDim.new(0, 8)

local infoPadding = Instance.new("UIPadding", infoRow)
infoPadding.PaddingLeft = UDim.new(0, 14)
infoPadding.PaddingRight = UDim.new(0, 14)
infoPadding.PaddingTop = UDim.new(0, 10)
infoPadding.PaddingBottom = UDim.new(0, 10)

local infoList = Instance.new("UIListLayout", infoRow)
infoList.FillDirection = Enum.FillDirection.Horizontal
infoList.VerticalAlignment = Enum.VerticalAlignment.Center
infoList.Padding = UDim.new(0, 20)

local function createInfoLabel(name, text, layoutOrder)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0, 140, 1, 0)
	container.BackgroundTransparency = 1
	container.LayoutOrder = layoutOrder
	container.Parent = infoRow

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 14)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(120, 120, 120)
	label.TextSize = 11
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local value = Instance.new("TextLabel")
	value.Name = "Value"
	value.Size = UDim2.new(1, 0, 0, 20)
	value.Position = UDim2.new(0, 0, 0, 16)
	value.BackgroundTransparency = 1
	value.Text = text
	value.TextColor3 = Color3.fromRGB(200, 200, 200)
	value.TextSize = 16
	value.Font = Enum.Font.GothamBold
	value.TextXAlignment = Enum.TextXAlignment.Left
	value.Parent = container

	return value
end

local levelValue = createInfoLabel("LEVEL", "1", 1)
local raceValue = createInfoLabel("RACE", "Human", 2)
local clanValue = createInfoLabel("CLAN", "Default", 3)

-- Points Available
local pointsContainer = Instance.new("Frame")
pointsContainer.Size = UDim2.new(1, 0, 0, 50)
pointsContainer.BackgroundColor3 = Color3.fromRGB(30, 60, 30)
pointsContainer.BorderSizePixel = 0
pointsContainer.LayoutOrder = 3
pointsContainer.Parent = mainFrame
Instance.new("UICorner", pointsContainer).CornerRadius = UDim.new(0, 8)

local pointsPadding = Instance.new("UIPadding", pointsContainer)
pointsPadding.PaddingLeft = UDim.new(0, 14)
pointsPadding.PaddingRight = UDim.new(0, 14)

local pointsLabel = Instance.new("TextLabel")
pointsLabel.Size = UDim2.new(0.7, 0, 1, 0)
pointsLabel.BackgroundTransparency = 1
pointsLabel.Text = "Available Points"
pointsLabel.TextColor3 = Color3.fromRGB(150, 200, 150)
pointsLabel.TextSize = 14
pointsLabel.Font = Enum.Font.GothamMedium
pointsLabel.TextXAlignment = Enum.TextXAlignment.Left
pointsLabel.Parent = pointsContainer

local pointsValue = Instance.new("TextLabel")
pointsValue.Name = "PointsValue"
pointsValue.Size = UDim2.new(0.3, 0, 1, 0)
pointsValue.BackgroundTransparency = 1
pointsValue.Text = "0"
pointsValue.TextColor3 = Color3.fromRGB(100, 255, 100)
pointsValue.TextSize = 24
pointsValue.Font = Enum.Font.GothamBold
pointsValue.TextXAlignment = Enum.TextXAlignment.Right
pointsValue.Parent = pointsContainer

-- Divider
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, 0, 0, 1)
divider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
divider.BorderSizePixel = 0
divider.LayoutOrder = 4
divider.Parent = mainFrame

-- Stats Container
local statsContainer = Instance.new("Frame")
statsContainer.Name = "StatsContainer"
statsContainer.Size = UDim2.new(1, 0, 0, 300)
statsContainer.BackgroundTransparency = 1
statsContainer.LayoutOrder = 5
statsContainer.Parent = mainFrame

local statsList = Instance.new("UIListLayout", statsContainer)
statsList.SortOrder = Enum.SortOrder.LayoutOrder
statsList.Padding = UDim.new(0, 10)

-- Stat Rows
local statRows = {}
local statIcons = {
	Strength = "⚔️",
	Constitution = "❤️",
	Dexterity = "⚡",
	Intelligence = "🧠",
}

local function createStatRow(statName, displayName, layoutOrder)
	local row = Instance.new("Frame")
	row.Name = statName .. "Row"
	row.Size = UDim2.new(1, 0, 0, 64)
	row.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	row.BorderSizePixel = 0
	row.LayoutOrder = layoutOrder
	row.Parent = statsContainer
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

	local rowPadding = Instance.new("UIPadding", row)
	rowPadding.PaddingLeft = UDim.new(0, 14)
	rowPadding.PaddingRight = UDim.new(0, 14)
	rowPadding.PaddingTop = UDim.new(0, 12)
	rowPadding.PaddingBottom = UDim.new(0, 12)

	-- Icon
	local icon = Instance.new("TextLabel")
	icon.Size = UDim2.new(0, 32, 0, 32)
	icon.Position = UDim2.new(0, 0, 0, 4)
	icon.BackgroundTransparency = 1
	icon.Text = statIcons[statName] or "📊"
	icon.TextSize = 24
	icon.Parent = row

	-- Name
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0, 140, 0, 18)
	nameLabel.Position = UDim2.new(0, 40, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = displayName
	nameLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	nameLabel.TextSize = 14
	nameLabel.Font = Enum.Font.GothamMedium
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = row

	-- Value
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Name = "Value"
	valueLabel.Size = UDim2.new(0, 60, 0, 22)
	valueLabel.Position = UDim2.new(0, 40, 0, 20)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = "0"
	valueLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
	valueLabel.TextSize = 18
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextXAlignment = Enum.TextXAlignment.Left
	valueLabel.Parent = row

	-- Buff indicator
	local buffLabel = Instance.new("TextLabel")
	buffLabel.Name = "BuffLabel"
	buffLabel.Size = UDim2.new(0, 80, 0, 16)
	buffLabel.Position = UDim2.new(0, 110, 0, 24)
	buffLabel.BackgroundTransparency = 1
	buffLabel.Text = ""
	buffLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
	buffLabel.TextSize = 12
	buffLabel.Font = Enum.Font.Gotham
	buffLabel.TextXAlignment = Enum.TextXAlignment.Left
	buffLabel.Parent = row

	-- Add Button
	local addBtn = Instance.new("TextButton")
	addBtn.Name = "AddBtn"
	addBtn.Size = UDim2.new(0, 40, 0, 40)
	addBtn.Position = UDim2.new(1, -40, 0.5, -20)
	addBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 60)
	addBtn.BorderSizePixel = 0
	addBtn.Text = "+"
	addBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	addBtn.TextSize = 22
	addBtn.Font = Enum.Font.GothamBold
	addBtn.Parent = row
	Instance.new("UICorner", addBtn).CornerRadius = UDim.new(0, 6)

	local btnStroke = Instance.new("UIStroke", addBtn)
	btnStroke.Color = Color3.fromRGB(60, 180, 90)
	btnStroke.Thickness = 1

	addBtn.MouseButton1Click:Connect(function()
		AllocatePoint:FireServer("allocate", statName)
		TweenService:Create(addBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
			BackgroundColor3 = Color3.fromRGB(60, 180, 90),
		}):Play()
		task.wait(0.1)
		TweenService:Create(addBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
			BackgroundColor3 = Color3.fromRGB(40, 120, 60),
		}):Play()
	end)

	statRows[statName] = {
		value = valueLabel,
		buff = buffLabel,
	}
end

createStatRow("Strength", "Strength", 1)
createStatRow("Constitution", "Constitution", 2)
createStatRow("Dexterity", "Dexterity", 3)
createStatRow("Intelligence", "Intelligence", 4)

-- Calculated Stats Display
local calculatedContainer = Instance.new("Frame")
calculatedContainer.Size = UDim2.new(1, 0, 0, 100)
calculatedContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
calculatedContainer.BorderSizePixel = 0
calculatedContainer.LayoutOrder = 0
calculatedContainer.Visible = false
calculatedContainer.Size = UDim2.new(0.1, 80, 0.1, 125) -- metade da largura, altura fixa
calculatedContainer.Position = UDim2.new(1, -20, 1, -20) -- canto inferior direito
calculatedContainer.AnchorPoint = Vector2.new(1, 1) -- ancora no canto inferior direito
calculatedContainer.Parent = screenGui
Instance.new("UICorner", calculatedContainer).CornerRadius = UDim.new(0, 8)

local calcPadding = Instance.new("UIPadding", calculatedContainer)
calcPadding.PaddingTop = UDim.new(0, 8)
calcPadding.PaddingBottom = UDim.new(0, 8)
calcPadding.PaddingLeft = UDim.new(0, 8)
calcPadding.PaddingRight = UDim.new(0, 8)

local calcTitle = Instance.new("TextLabel")
calcTitle.Size = UDim2.new(1, 0, 0, 16)
calcTitle.BackgroundTransparency = 1
calcTitle.Text = "Final Stats"
calcTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
calcTitle.TextSize = 12
calcTitle.Font = Enum.Font.GothamMedium
calcTitle.TextXAlignment = Enum.TextXAlignment.Left
calcTitle.Parent = calculatedContainer

local calcGrid = Instance.new("Frame")
calcGrid.Size = UDim2.new(1, 0, 1, -20)
calcGrid.Position = UDim2.new(0, 0, 0, 20)
calcGrid.BackgroundTransparency = 1
calcGrid.Parent = calculatedContainer

local calcGridLayout = Instance.new("UIGridLayout", calcGrid)
calcGridLayout.CellSize = UDim2.new(0.5, -6, 0, 18)
calcGridLayout.CellPadding = UDim2.new(0, 12, 0, 4)

local calculatedStats = {}
local function createCalcStat(name, layoutOrder)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Text = name .. ": 0"
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.TextSize = 13
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.LayoutOrder = layoutOrder
	label.Parent = calcGrid
	calculatedStats[name] = label
end

createCalcStat("HP", 1)
createCalcStat("Stamina", 2)
createCalcStat("Nen", 3)
createCalcStat("Attack", 4)
createCalcStat("Defense", 5)
createCalcStat("Crit%", 6)
createCalcStat("CritDmg", 7)
createCalcStat("Speed", 8)

-- Reset Button
local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(1, 0, 0, 42)
resetBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
resetBtn.BorderSizePixel = 0
resetBtn.Text = "Reset Stats (Refund All Points)"
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.TextSize = 14
resetBtn.Font = Enum.Font.GothamBold
resetBtn.LayoutOrder = 7
resetBtn.Parent = mainFrame
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 8)

resetBtn.MouseButton1Click:Connect(function()
	AllocatePoint:FireServer("reset")
	TweenService:Create(resetBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(180, 60, 60) }):Play()
	task.wait(0.15)
	TweenService:Create(resetBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(120, 40, 40) }):Play()
end)

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -36, 0, 16)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 3
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	calculatedContainer.Visible = false
end)

-- Toggle with K key
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end
	if input.KeyCode == Enum.KeyCode.K then
		mainFrame.Visible = not mainFrame.Visible
		calculatedContainer.Visible = mainFrame.Visible
	end
end)

-- Update UI
UpdateHud.OnClientEvent:Connect(function(updateType, data)
	if updateType == "all" or updateType == "stats" then
		if not data.Stats then
			return
		end

		local stats = data.Stats
		local profile = data.Profile

		-- Info
		levelValue.Text = tostring(stats.Level)
		raceValue.Text = profile.Race
		clanValue.Text = profile.Clan
		pointsValue.Text = tostring(stats.AvailablePoints)

		-- Stats com buffs
		for statName, row in pairs(statRows) do
			local base = stats[statName] or 0
			local buff = stats.FixedBuffs[statName] or 0
			row.value.Text = tostring(base)
			if buff ~= 0 then
				row.buff.Text = (buff > 0 and "+" or "") .. tostring(buff)
			else
				row.buff.Text = ""
			end
		end

		-- Calculated
		local calc = stats.Calculated
		calculatedStats.HP.Text = "HP: " .. calc.MaxHealth
		calculatedStats.Stamina.Text = "Stamina: " .. calc.MaxStamina
		calculatedStats.Nen.Text = "Nen: " .. calc.MaxNen
		calculatedStats.Attack.Text = "Attack: " .. calc.AttackPower
		calculatedStats.Defense.Text = "Defense: " .. calc.Defense
		calculatedStats["Crit%"].Text = "Crit%: " .. calc.CritChance .. "%"
		calculatedStats.CritDmg.Text = "CritDmg: " .. calc.CritDamage .. "%"
		calculatedStats.Speed.Text = "Speed: " .. calc.WalkSpeed
	end
end)
