local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Arc = require(ReplicatedStorage.Packages.Arc)
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local DemoService

local DemoController = Knit.CreateController({ Name = "DemoController" })

function DemoController:KnitInit()
	Player.CharacterAdded:Connect(function() self:OnCharacter() end)
	if Player.Character then self:OnCharacter() end
end

function DemoController:KnitStart() DemoService = Knit.GetService("DemoService") end

function DemoController:OnCharacter() self:CreateArcTool() end

function DemoController:CreateArcTool()
	local tool = Instance.new("Tool")
	tool.Name = "Arc"
	tool.RequiresHandle = false
	tool.CanBeDropped = false
	tool.Parent = Player.Backpack
	local arc
	tool.Activated:Connect(function()
		if arc then arc:Destroy() end
		local alpha = Player.Character:GetPivot().Position
		local delta = Mouse.Hit.Position - alpha
		local omega = alpha + delta.Unit * math.min(delta.Magnitude, 64)
		arc = Arc.new(alpha, omega)
		arc.Visible = true
		arc:Calculate()
		DemoService:ArcTween(alpha, omega)
	end)
end

return DemoController
