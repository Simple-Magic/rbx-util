local Knit = require(script.Parent.Parent.Knit)
local GunComponent = require(script.Parent.GunComponent)

local GunService = Knit.CreateService({
	Name = "GunService",
	Client = {},
})

function GunService.Client:Reload(player: Player, tool: Tool)
	if tool.Parent ~= player.Character then return end
	local gun = GunComponent:FromInstance(tool)
	if gun then gun:Reload() end
end

return GunService
