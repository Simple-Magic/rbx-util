local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local Knit = require(script.Parent.Parent.Knit)
local Timer = require(script.Parent.Parent.Timer)
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)

local PlayerListController = Knit.CreateController({
	Name = "PlayerListController",
	Labels = {} :: Table<Player, TextLabel>,
})

function PlayerListController:KnitInit()
	self.Gui = script.Parent.PlayerList:Clone()
	self.Gui.Parent = Player.PlayerGui
	self.LabelTemplate = self.Gui.Frame.ScrollingFrame.NameLabel
	self.LabelTemplate.Parent = nil
	self.LabelDataTemplate = self.LabelTemplate.DataLabel
	self.LabelDataTemplate.Parent = nil
	Players.ChildAdded:Connect(function(...) self:AddPlayer(...) end)
	Players.ChildRemoved:Connect(function(...) self:RemovePlayer(...) end)
	for _, player in pairs(Players:GetChildren()) do
		self:AddPlayer(player)
	end
end

function PlayerListController:KnitStart()
	Timer.Simple(1, function() self:UpdateData() end)
end

function PlayerListController:AddPlayer(player: Player)
	local label = self.LabelTemplate:Clone()
	local name = player.Name
	if player:IsA("Player") then name = player.DisplayName end
	label.Text = ("  %s"):format(name)
	if player:IsA("Team") then label.Text = ("  <b>[BOT]</b> %s"):format(name) end
	local hue, saturation = player.TeamColor.Color:ToHSV()
	label.TextColor3 = Color3.fromHSV(hue, saturation, 1)
	label.BackgroundColor3 = Color3.fromHSV(hue, 0.3, 0.2)
	label.Parent = self.Gui.Frame.ScrollingFrame
	self.Labels[player] = label
	self:ResizeCanvas()
end

function PlayerListController:RemovePlayer(player: Player)
	local label = self.Labels[player]
	self.Labels[player] = nil
	if label then label:Destroy() end
	self:ResizeCanvas()
end

function PlayerListController:ResizeCanvas()
	local scrollingFrame = self.Gui.Frame.ScrollingFrame
	local contentSize = scrollingFrame.UIGridLayout.AbsoluteContentSize
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y)
	if contentSize.Y + 8 < (Mouse.ViewSizeY - 36) * 0.4 - 16 then
		self.Gui.Frame.Size = UDim2.new(0.3, -8, 0, contentSize.Y + 8)
	else
		self.Gui.Frame.Size = UDim2.new(0.3, -8, 0.4, -16)
	end
end

function PlayerListController:UpdateData()
	self:UpdateColumns()
	self:UpdateRows()
end

function PlayerListController:UpdateColumns()
	local properties = self:GetProperties()
	for _, child in pairs(self.Gui.Frame:GetChildren()) do
		if child:IsA("TextLabel") then child:Destroy() end
	end
	for index, prop in ipairs(properties) do
		local dataLabel = self.LabelDataTemplate:Clone()
		dataLabel.Position = UDim2.new(0.5 + 0.5 * (index - 0.5) / #properties, 0, 0, 0)
		dataLabel.Size = UDim2.new(0, 0, 0, 0)
		dataLabel.TextSize = 8
		dataLabel.Text = prop
		dataLabel.Parent = self.Gui.Frame
	end
end

function PlayerListController:UpdateRows()
	local properties = self:GetProperties()
	local players = {} :: { Player }
	for player, label in pairs(self.Labels) do
		table.insert(players, player)
		for _, child in pairs(label:GetChildren()) do
			if child:IsA("TextLabel") then child:Destroy() end
		end
		for index, prop in ipairs(properties) do
			local value = self:GetPropertyValue(player, prop)
			local dataLabel = self.LabelDataTemplate:Clone()
			dataLabel.Position = UDim2.new(0.5 + 0.5 * (index - 0.5) / #properties, 0, 0, 0)
			dataLabel.Text = tostring(value or "-")
			dataLabel.TextColor3 = Color3.fromHSV(player.TeamColor.Color:ToHSV(), 0.5, 1)
			dataLabel.Parent = label
		end
	end
	if #properties > 0 then
		local orderFn = function(lhs: Player, rhs: Player)
			local lval, rval
			for _, propName in pairs(properties) do
				lval = self:GetPropertyValue(lhs, propName)
				rval = self:GetPropertyValue(rhs, propName)
				if lval ~= rval then break end
			end
			return (lval or -math.huge) > (rval or -math.huge)
		end
		table.sort(players, orderFn)
		for index, player in ipairs(players) do
			self.Labels[player].LayoutOrder = index
		end
	end
end

function PlayerListController:GetPropertyValue(player: Player, name: string): any?
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return end
	local stat = leaderstats:FindFirstChild(name)
	return stat and stat.Value
end

function PlayerListController:GetProperties(): { string }
	local properties = {}
	for _, player in pairs(Players:GetChildren()) do
		local leaderstats = player:FindFirstChild("leaderstats")
		if not leaderstats then continue end
		for _, stat in pairs(leaderstats:GetChildren()) do
			if not table.find(properties, stat.Name) then table.insert(properties, stat.Name) end
		end
	end
	return properties
end

return PlayerListController
