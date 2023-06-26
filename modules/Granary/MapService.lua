local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local MapService = Knit.CreateService({
	Name = "MapService",
	Maps = script.Parent.Maps:GetChildren(),
})

return MapService
