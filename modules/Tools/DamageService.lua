local Players = game:GetService("Players")
local Knit = require(script.Parent.Parent.Knit)
local Signal = require(script.Parent.Parent.Signal)

local DamageService = Knit.CreateService({
	Name = "DamageService",
	Damaged = Signal.new(),
})

function DamageService:Damage(humanoid: Humanoid, damage: number, creatorPlayer: Player?)
	if self:Verify(humanoid, creatorPlayer) then return end
	local creator = humanoid:FindFirstChild("creator")
	if creator then creator:Destroy() end
	if creatorPlayer then
		creator = Instance.new("ObjectValue")
		creator.Name = "creator"
		creator.Value = creatorPlayer
		creator.Parent = humanoid
	end
	humanoid:TakeDamage(damage)
	self.Damaged:Fire(humanoid, damage, creatorPlayer)
end

function DamageService:Verify(humanoid: Humanoid, creatorPlayer: Player?)
	local targetPlayer = Players:GetPlayerFromCharacter(humanoid.Parent)
	if targetPlayer and targetPlayer == creatorPlayer then
		return 0 -- ignore self
	end
	if
		targetPlayer
		and creatorPlayer
		and not targetPlayer.Neutral
		and not creatorPlayer.Neutral
		and targetPlayer.TeamColor == creatorPlayer.TeamColor
	then
		return 1 -- ignore teammate
	end
end

return DamageService
