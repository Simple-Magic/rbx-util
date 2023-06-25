local Players = game:GetService("Players")
local Knit = require(script.Parent.Parent.Knit)
local Player = Players.LocalPlayer

local CrateService

local CrateController = Knit.CreateController({ Name = "CrateController" })

function CrateController:KnitStart()
	CrateService = Knit.GetService("CrateService")
	CrateService.Store:Connect(function(...) self:OpenStore(...) end)
end

function CrateController:OpenStore(crate: BasePart)
	local prompt = crate:FindFirstChild("ProximityPrompt")
	if prompt then prompt.Enabled = false end
	if self.Gui and self.Gui.Parent then return end
	self.Gui = script.Parent.Store:Clone()
	self.Gui.Parent = Players.LocalPlayer.PlayerGui
	self.ButtonTemplate = self.Gui.ScrollingFrame.TextButton
	self.ButtonTemplate.Parent = nil
	local props = script.Parent.Props:GetChildren()
	table.insert(props, 0)
	for _, item in ipairs(props) do
		local button = self.ButtonTemplate:Clone()
		button.Name = item ~= 0 and item.Name or "Close"
		button.Text = item ~= 0 and item.Name or "Close"
		button.Parent = self.Gui.ScrollingFrame
		button.MouseButton1Click:Connect(function()
			if item ~= 0 then CrateService:Buy(item):await() end
			self.Gui:Destroy()
			self.Gui = nil
		end)
	end
	local size = self.Gui.ScrollingFrame.UIGridLayout.AbsoluteContentSize
	self.Gui.ScrollingFrame.CanvasSize = UDim2.new(0, size.X, 0, size.Y)
	repeat
		if not Player.Character then break end
		local distance = (crate:GetPivot().Position - Player.Character:GetPivot().Position).Magnitude
		if distance > 10 then break end
		task.wait()
	until not self.Gui or not Player.Character
	if self.Gui then
		self.Gui:Destroy()
		self.Gui = nil
	end
	if prompt then prompt.Enabled = true end
end

return CrateController
