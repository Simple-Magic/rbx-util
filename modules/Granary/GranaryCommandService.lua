local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")
local Knit = require(script.Parent.Parent.Knit)
local MapComponent = require(script.Parent.MapComponent)

local AdminService

function getMaps()
	local maps = {}
	for _, map in ipairs(script.Parent.Maps:GetChildren()) do
		maps[map.Name:lower()] = map
	end
	return maps
end

local GranaryCommandService = Knit.CreateService({ Name = "GranaryCommandService" })

function GranaryCommandService:KnitStart()
	AdminService = Knit.GetService("AdminService")
	AdminService:AddCommand("SetMap", "/map", function(...) return self:_SetMap(...) end)
	AdminService:AddCommand("Maps", nil, function() return self:_ListMaps() end)
end

function GranaryCommandService:_SetMap(_: TextSource, source: string): string
	local parameters = AdminService.commandParameters(source)
	local templates = getMaps()
	local template = templates[parameters[1]:lower()]
	if not template then return "No map found." end
	for _, map in ipairs(MapComponent:GetAll()) do
		map:Destroy()
	end
	local map = template:Clone()
	map:PivotTo(CFrame.new())
	CollectionService:AddTag(map, "Map")
	map.Parent = Workspace
	return "Map loaded."
end

function GranaryCommandService:_ListMaps(): string
	list = "<b>Maps:</b>"
	for _, map in pairs(getMaps()) do
		list ..= ("\n- %s"):format(map.Name)
	end
	return list
end

return GranaryCommandService
