local Players = game:GetService("Players")
local Knit = require(script.Parent.Parent.Knit)
local Timer = require(script.Parent.Parent.Timer)
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local CursorController = Knit.CreateController({ Name = "CursorController" })

function CursorController:KnitInit()
	Timer.Simple(1, function() Mouse.Icon = "rbxassetid://13898932223" end)
end

return CursorController
