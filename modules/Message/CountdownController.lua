local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Knit = require(script.Parent.Parent.Knit)
local compose = require(script.Parent.Parent.compose)
local Maid = require(script.Parent.Parent.Maid)

local CountdownService

local CountdownController = Knit.CreateController({
	Name = "CountdownController",
	Locked = false,
	Maid = Maid.new(),
	TweenInfo = TweenInfo.new(0.2),
	ScreenGui = compose("ScreenGui", {
		Name = "Countdown",
		Parent = PlayerGui,
		ResetOnSpawn = false,
	}, {
		compose("TextLabel", {
			BackgroundTransparency = 1,
			Font = Enum.Font.SourceSansBold,
			Name = "Label",
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 0, 0, 0),
			Text = "",
			TextSize = 96,
			TextTransparency = 1,
			TextColor3 = Color3.new(1, 1, 1),
			TextStrokeColor3 = Color3.new(0, 0, 0),
			TextStrokeTransparency = 0.5,
		}),
	}),
})

function CountdownController:KnitStart()
	CountdownService = Knit.GetService("CountdownService")
	CountdownService.Countdown:Connect(function(count) self:Countdown(count) end)
end

function CountdownController:Countdown(count: Integer)
	if self.Locked then return end
	self.Locked = true
	for i = count, 1, -1 do
		self.ScreenGui.Label.Text = tostring(i)
		self.ScreenGui.Label.TextTransparency = 1
		self.ScreenGui.Label.Rotation = 15
		self.ScreenGui.Label.TextSize = 24
		self.Maid:Destroy()
		self.Maid
			:Add(TweenService:Create(self.ScreenGui.Label, self.TweenInfo, {
				TextTransparency = 0,
				Rotation = 0,
				TextSize = 96,
			}))
			:Play()
		task.wait(0.7)
		self.Maid:Destroy()
		self.Maid
			:Add(TweenService:Create(self.ScreenGui.Label, self.TweenInfo, {
				TextTransparency = 1,
				Rotation = -15,
				TextSize = 24,
			}))
			:Play()
		task.wait(0.3)
		self.ScreenGui.Label.TextTransparency = 1
	end
	self.Locked = false
end

return CountdownController
