local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Timer = require(ReplicatedStorage.Packages.Timer)
local Player = Players.LocalPlayer

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

function getInputNumber(inputObject: InputObject)
	return ({
		[Enum.KeyCode.One] = 1,
		[Enum.KeyCode.Two] = 2,
		[Enum.KeyCode.Three] = 3,
		[Enum.KeyCode.Four] = 4,
		[Enum.KeyCode.Five] = 5,
		[Enum.KeyCode.Six] = 6,
		[Enum.KeyCode.Seven] = 7,
		[Enum.KeyCode.Eight] = 8,
		[Enum.KeyCode.Nine] = 9,
		[Enum.KeyCode.Zero] = 10,
	})[inputObject.KeyCode]
end

local BackpackController = Knit.CreateController({
	Name = "BackpackController",
	Buttons = {} :: Table<Tool, TextButton>,
})

function BackpackController:KnitInit()
	self.Gui = script.Parent.Backpack:Clone()
	self.Gui.Parent = Player.PlayerGui
	self.ButtonTemplate = self.Gui.Frame.TextButton
	self.ButtonTemplate.Parent = nil
end

function BackpackController:KnitStart()
	Timer.Simple(0.1, function() self:OnTick() end, true)
	UserInputService.InputEnded:Connect(function(...) self:OnInputEnded(...) end)
end

function BackpackController:OnInputEnded(inputObject: InputObject, processed: boolean)
	if processed then return end
	local inputNumber = getInputNumber(inputObject)
	if inputNumber then
		local tools = self:GetTools()
		local tool = tools[inputNumber]
		if not tool then return end
		self:Toggle(tool)
	end
end

function BackpackController:GetTools(): { Tool }
	local tools = {} :: { Tool }
	for _, child in pairs(Player.Backpack:GetChildren()) do
		if child:IsA("Tool") then table.insert(tools, child) end
	end
	if Player.Character then
		for _, child in pairs(Player.Character:GetChildren()) do
			if child:IsA("Tool") then table.insert(tools, child) end
		end
	end
	table.sort(tools, function(lhs: Tool, rhs: Tool) return lhs.Name < rhs.Name end)
	return tools
end

function BackpackController:OnTick()
	for index, tool in ipairs(self:GetTools()) do
		self:Add(tool, index)
	end
	for tool in pairs(self.Buttons) do
		if tool.Parent == Player.Backpack then continue end
		if tool.Parent == Player.Character then continue end
		self:Remove(tool)
	end
end

function BackpackController:Equip(tool: Tool)
	if not Player.Character then return end
	if tool.Parent == Player.Character then return end
	local equipped = Player.Character:FindFirstChildWhichIsA("Tool")
	if equipped then self:Unequip(equipped) end
	tool.Parent = Player.Character
end

function BackpackController:Unequip(tool: Tool) tool.Parent = Player.Backpack end

function BackpackController:Toggle(tool: Tool)
	if tool.Parent == Player.Character then
		self:Unequip(tool)
	else
		self:Equip(tool)
	end
end

function BackpackController:Add(tool: Tool, index: number?)
	if not self.Buttons[tool] then
		self.Buttons[tool] = self.ButtonTemplate:Clone()
		self.Buttons[tool].MouseButton1Click:Connect(function() self:Toggle(tool) end)
		self.Buttons[tool].Parent = self.Gui.Frame
	end
	local equipped = tool.Parent == Player.Character
	local width = equipped and 128 or 32
	local height = equipped and 48 or 32
	local text = equipped and tool.Name or tostring(index)
	self.Buttons[tool].Size = UDim2.new(0, width, 0, height)
	self.Buttons[tool].Text = text
end

function BackpackController:Remove(tool: Tool)
	local button = self.Buttons[tool]
	if button then button:Destroy() end
	self.Buttons[tool] = nil
end

return BackpackController
