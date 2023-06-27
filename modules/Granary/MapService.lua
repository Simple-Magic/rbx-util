local Knit = require(script.Parent.Parent.Knit)

local MapService = Knit.CreateService({
	Name = "MapService",
	Maps = script.Parent.Maps:GetChildren(),
})

return MapService
