local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Arc = require(ReplicatedStorage.Packages.Arc)
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local DemoController = Knit.CreateController({ Name = "DemoController" })

function DemoController:KnitInit()
	Player.CharacterAdded:Connect(function() self:OnCharacter() end)
	if Player.Character then self:OnCharacter() end
end

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
		local part = Instance.new("Part")
		part.Size = Vector3.one
		part.CanCollide = false
		part.Anchored = true
		part.CFrame = CFrame.new(alpha)
		part.Parent = Workspace
		arc:Tween(part, TweenInfo.new(1))
	end)
end

return DemoController
