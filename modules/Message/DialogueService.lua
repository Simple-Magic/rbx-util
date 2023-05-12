local Knit = require(script.Parent.Parent.Knit)
local Signal = require(script.Parent.Parent.Signal)

local DialogueService = Knit.CreateService({
	Name = "DialogueService",
	Client = { Dialogue = Knit.CreateSignal() },
	ResponseSignals = {} :: Table<number, Signal>,
	IdSequence = 0,
})

function DialogueService.Client:SendResponse(_player: Player, id: number, value: boolean)
	self.Server.ResponseSignals[id]:Fire(value)
	self.Server.ResponseSignals[id] = nil
end

function DialogueService:DialogueFor(player: Player, options: DialogueOptions?): Signal
	self.IdSequence += 1
	local id = self.IdSequence
	local signal = Signal.new()
	self.ResponseSignals[id] = signal
	self.Client.Dialogue:Fire(player, id, options)
	return signal
end

return DialogueService
