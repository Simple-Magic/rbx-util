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
	for _, item in ipairs(script.Parent.Items:GetChildren()) do
		local button = self.ButtonTemplate:Clone()
		button.Name = item.Name
		button.Text = item.Name
		button.Parent = self.Gui.ScrollingFrame
		button.MouseButton1Click:Connect(function()
			CrateService:Buy(item):await()
			self.Gui:Destroy()
			self.Gui = nil
		end)
	end
	local size = self.Gui.ScrollingFrame.UIGridLayout.AbsoluteContentSize
	self.Gui.ScrollingFrame.CanvasSize = UDim2.new(0, size.X, 0, size.Y)
	self.Gui.CloseButton.MouseButton1Click:Connect(function()
		self.Gui:Destroy()
		self.Gui = nil
	end)
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
