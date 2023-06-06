local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local HitService

local HitController = Knit.CreateController({ Name = "HitController" })

function HitController:KnitStart()
	HitService = Knit.GetService("HitService")
	RunService:BindToRenderStep(
		self.Name,
		Enum.RenderPriority.Last.Value,
		function() HitService.Hit:Fire(Mouse.Hit.Position) end
	)
end

return HitController
