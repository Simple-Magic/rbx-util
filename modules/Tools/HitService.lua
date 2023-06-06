local Knit = require(script.Parent.Parent.Knit)
require(script.Parent.GunComponent)
require(script.Parent.MeleeComponent)

local HitService = Knit.CreateService({
	Name = "HitService",
	Hit = {} :: Table<Player, Vector3>,
	Client = {
		Hit = Knit.CreateSignal(),
	},
})

function HitService:KnitInit()
	self.Client.Hit:Connect(function(player: Player, target: Vector3) self.Hit[player] = target end)
end

return HitService
