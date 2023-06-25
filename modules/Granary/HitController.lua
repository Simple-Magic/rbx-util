local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Knit = require(script.Parent.Parent.Knit)
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local HitService

local HitController = Knit.CreateController({ Name = "HitController" })

function HitController:KnitStart()
	HitService = Knit.GetService("HitService")
	Player.CharacterAdded:Connect(function() self:OnCharacter() end)
	if Player.Character then self:OnCharacter() end
	RunService:BindToRenderStep(
		self.Name,
		Enum.RenderPriority.Last.Value,
		function() HitService.Hit:Fire(Mouse.Hit.Position) end
	)
end

function HitController:OnCharacter() Mouse.TargetFilter = Player.Character end

return HitController
