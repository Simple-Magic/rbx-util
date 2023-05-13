local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Knit = require(script.Parent.Parent.Knit)
local compose = require(script.Parent.Parent.compose)

local BarController

local HealthController = Knit.CreateController({
	Name = "HealthController",
	Frame = compose("Frame", {
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.5,
		Name = "Health",
		Size = UDim2.new(0, 64, 0, 32),
	}, {
		Instance.new("UICorner"),
		compose("Frame", {
			Name = "Progress",
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 16, 1, 0),
			ZIndex = 1,
		}, { Instance.new("UICorner") }),
		compose("TextLabel", {
			BackgroundTransparency = 1,
			Font = Enum.Font.Code,
			RichText = true,
			Size = UDim2.new(1, 0, 1, 0),
			Text = "",
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = 18,
			TextStrokeColor3 = Color3.new(0, 0, 0),
			TextStrokeTransparency = 0.7,
			TextXAlignment = Enum.TextXAlignment.Right,
			ZIndex = 2,
		}),
	}),
	_Connection = nil :: RBXScriptConnection?,
})

function HealthController:KnitStart()
	BarController = Knit.GetController("BarController")
	BarController:AddRight(self.Frame, 90)
	Player.CharacterAdded:Connect(function(...) self:_CharacterChanged(...) end)
	Player.CharacterRemoving:Connect(function() self:_CharacterChanged() end)
	self:_CharacterChanged()
end

function HealthController:Update()
	local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid") :: Humanoid?
	self.Frame.TextLabel.Text = ("%d "):format(humanoid and humanoid.Health or 0)
	local progress = humanoid and humanoid.Health / humanoid.MaxHealth or 0
	self.Frame.Progress.Size = UDim2.new(progress, 16 * (1 - progress), 1, 0)
	self.Frame.Progress.BackgroundTransparency = 0.2 + progress * 0.3
	local color = progress > 0.5 and Color3.new(1, 1, (progress - 0.5) * 2)
		or Color3.new(1, progress * 2, 0)
	self.Frame.TextLabel.TextColor3 = color
	self.Frame.Progress.BackgroundColor3 = color
end

function HealthController:_CharacterChanged(character: Model?)
	if self._Connection then self._Connection:Disconnect() end
	if character then
		local humanoid = character:WaitForChild("Humanoid")
		self._Connection = humanoid.HealthChanged:Connect(function() self:Update() end)
	end
	self:Update()
end

return HealthController
