local Workspace = game:GetService("Workspace")
local Knit = require(script.Parent.Parent.Knit)

local CageService = Knit.CreateService({ Name = "CageService" })

function CageService:KnitInit()
	self.Model = script.Parent.Cage:Clone()
	self.Model.Parent = Workspace
end

function CageService:Teleport(player: Player)
	if not player.Character then return end
	player.Character:PivotTo(self.Model:GetPivot() * CFrame.new(0, 10, 0))
end

function CageService:Contains(player: Player)
	if not player.Character then return false end
	return player.Character:GetPivot().Position.Y >= self.Model:GetPivot().Position.Y
end

return CageService
