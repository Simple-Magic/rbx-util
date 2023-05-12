local Knit = require(script.Parent.Parent.Knit)

local HitmarkerService = Knit.CreateService({
	Name = "HitmarkerService",
	Client = { Hitmarker = Knit.CreateSignal() },
})

function HitmarkerService:HitmarkerFor(player: Player, content: string)
	self.Client.Hitmarker:Fire(player, content)
end

return HitmarkerService
