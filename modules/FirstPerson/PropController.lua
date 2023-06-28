local Players = game:GetService("Players")
local Knit = require(script.Parent.Parent.Knit)
local Trove = require(script.Parent.Parent.Trove)
local Player = Players.LocalPlayer

local PropController = Knit.CreateController({ Name = "PropController" })

function PropController:KnitInit()
	self.Gui = script.Parent.PropUI:Clone()
	self.Gui.Parent = Player.PlayerGui
	Player.CharacterAdded:Connect(function() self:OnCharacter() end)
	if Player.Character then self:OnCharacter() end
end

function PropController:OnCharacter()
	local leftHand = Player.Character:WaitForChild("LeftHand") :: BasePart
	local rightHand = Player.Character:WaitForChild("RightHand") :: BasePart
	leftHand.ChildAdded:Connect(function() self:Update() end)
	leftHand.ChildRemoved:Connect(function() self:Update() end)
	rightHand.ChildAdded:Connect(function() self:Update() end)
	rightHand.ChildRemoved:Connect(function() self:Update() end)
	self:Update()
end

function PropController:GetLeftTool(): Tool?
	local hand = Player.Character and Player.Character:FindFirstChild("LeftHand")
	return hand and hand:FindFirstChildWhichIsA("Tool")
end

function PropController:GetRightTool(): Tool?
	local hand = Player.Character and Player.Character:FindFirstChild("RightHand")
	return hand and hand:FindFirstChildWhichIsA("Tool")
end

function PropController:Update()
	self.UpdateTrove = self.UpdateTrove or Trove.new()
	self.UpdateTrove:Clean()
	for _, pair in ipairs({
		{ self:GetLeftTool(), self.Gui.LeftLabel },
		{ self:GetRightTool(), self.Gui.RightLabel },
	}) do
		local tool, label = table.unpack(pair)
		if tool then
			local update = function() label.Text = ("<b>%s</b>\n%s"):format(tool.Name, tool.ToolTip) end
			self.UpdateTrove:Connect(tool.Changed, update)
			update()
		else
			label.Text = ""
		end
	end
end

return PropController
