local Knit = require(script.Parent.Parent.Knit)

local ProgressService = Knit.CreateService({
	Name = "ProgressService",
	Client = {
		Progress = Knit.CreateSignal(),
	},
})

function ProgressService:SetProgress(progress: number?) self.Client.Progress:FireAll(progress) end

function ProgressService:SetProgressFor(player: Player, progress: number?)
	self.Client.Progress:Fire(player, progress)
end

return ProgressService
