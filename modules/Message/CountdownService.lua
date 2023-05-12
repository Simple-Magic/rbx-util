local Knit = require(script.Parent.Parent.Knit)

local CountdownService = Knit.CreateService({
	Name = "CountdownService",
	Client = {
		Countdown = Knit.CreateSignal(),
	},
})

function CountdownService:Countdown(count: Integer) self.Client.Countdown:FireAll(count) end

return CountdownService
