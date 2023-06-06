local Knit = require(script.Parent.Parent.Knit)

local LogService = Knit.CreateService({
	Name = "LogService",
	Client = {
		Log = Knit.CreateSignal(),
	},
})

function LogService:LogAll(msg: string) self.Client.Log:FireAll(msg) end

function LogService:LogTo(player: Player, msg: string)
	if player and player:IsA("Player") then self.Client.Log:Fire(player, msg) end
end

return LogService
