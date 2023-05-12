local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local Knit = require(script.Parent.Parent.Knit)
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local HitmarkerService

local HitmarkerController = Knit.CreateController({ Name = "HitmarkerController" })

function HitmarkerController:KnitInit()
	self.Gui = Instance.new("ScreenGui")
	self.Gui.Name = "Hitmarker"
	self.Gui.ResetOnSpawn = false
	self.Gui.DisplayOrder = 1
	self.Gui.Parent = Player.PlayerGui
end

function HitmarkerController:KnitStart()
	HitmarkerService = Knit.GetService("HitmarkerService")
	HitmarkerService.Hitmarker:Connect(function(...) self:Hitmarker(...) end)
end

function HitmarkerController:Hitmarker(content: string)
	local label = Instance.new("TextLabel")
	label.BorderSizePixel = 0
	label.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y)
	label.RichText = true
	label.Size = UDim2.new(0, 0, 0, 0)
	label.Text = content
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextSize = 16
	label.TextStrokeTransparency = 0.5
	label.Parent = self.Gui
	local delta = (CFrame.Angles(0, 0, math.random() * math.pi * 2) * CFrame.new(0, 48, 0)).Position
	local tween = TweenService:Create(label, TweenInfo.new(1), {
		Position = UDim2.new(0, Mouse.X + delta.X, 0, Mouse.Y + delta.Y),
		TextStrokeTransparency = 1,
		TextTransparency = 0.8,
	})
	tween:Play()
	Debris:AddItem(label, 1)
end

return HitmarkerController
