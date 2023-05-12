local Knit = require(script.Parent.Parent.Knit)

local AnnouncementService = Knit.CreateService({
	Name = "AnnouncementService",
	Client = {
		Announced = Knit.CreateSignal(),
	},
})

function AnnouncementService:Announce(message: string, options: AnnouncmentOptions?)
	self.Client.Announced:FireAll(message, options)
end

function AnnouncementService:AnnounceFor(
	player: Player,
	message: string,
	options: AnnouncmentOptions?
)
	self.Client.Announced:Fire(player, message, options)
end

return AnnouncementService
