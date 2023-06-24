local Knit = require(script.Parent.Parent.Knit)
require(script.Parent.CrateComponent)

local CrateService = Knit.CreateService({
	Name = "CrateService",
	Client = {
		Store = Knit.CreateSignal(),
	},
})

function CrateService:Open(player: Player) self.Client.Store:Fire(player) end

function CrateService.Client:Buy(player: Player, template: Tool)
	local clone = template:Clone()
	clone.Parent = player.Character
end

return CrateService
