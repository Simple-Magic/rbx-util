local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Knit = require(script.Parent.Parent.Knit)

local ProgressService

local ProgressController = Knit.CreateController({ Name = "ProgressController" })

function ProgressController:KnitInit()
	self.Gui = Instance.new("ScreenGui")
	self.Gui.Name = "Progress"
	self.Gui.ResetOnSpawn = false
	self.Gui.Parent = Players.LocalPlayer.PlayerGui
end

function ProgressController:KnitStart()
	ProgressService = Knit.GetService("ProgressService")
	ProgressService.Progress:Connect(function(...) self:Update(...) end)
end

function ProgressController:Update(value: number?)
	if value then
		if not self.Frame then
			self.Frame = Instance.new("Frame")
			self.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
			self.Frame.Position = UDim2.new(0.5, 0, 0.8, 0)
			self.Frame.Size = UDim2.new(0.6, 0, 0, 32)
			self.Frame.BorderSizePixel = 0
			self.Frame.BackgroundColor3 = Color3.new(0, 0, 0)
			self.Frame.BackgroundTransparency = 0.5
			local innerFrame = Instance.new("Frame")
			innerFrame.BorderSizePixel = 1
			innerFrame.BorderColor3 = Color3.new(1, 1, 1)
			innerFrame.BackgroundColor3 = Color3.new(1, 1, 1)
			innerFrame.Parent = self.Frame
			self.Frame.Parent = self.Gui
		end
		TweenService:Create(self.Frame.Frame, TweenInfo.new(0.1), {
			Size = UDim2.new(value, 0, 1, 0),
		}):Play()
	elseif self.Frame then
		self.Frame:Destroy()
	end
end

return ProgressController
