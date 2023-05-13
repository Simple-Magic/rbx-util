local Knit = require(script.Parent.Parent.Knit)
local Timer = require(script.Parent.Parent.Timer)

local ClockService = Knit.CreateService({
	Name = "ClockService",
	Client = {
		Clock = Knit.CreateSignal(),
	},
	_StartMillis = nil :: number?,
	_EndMillis = nil :: number?,
})

function ClockService:KnitStart()
	Timer.Simple(1, function() self.Client.Clock:FireAll(self._StartMillis, self._EndMillis) end)
end

function ClockService:SetClock(startMillis: number?, endMillis: number?)
	self._StartMillis = startMillis
	self._EndMillis = endMillis
	self.Client.Clock:FireAll(self._StartMillis, self._EndMillis)
end

return ClockService
