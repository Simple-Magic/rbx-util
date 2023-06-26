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
	AdminService:AddCommand("SetMap", "/map", function(...) self:_SetMap(...) end)
end

function GranaryCommandService:_SetMap(_: TextSource, source: string)
	local parameters = AdminService.commandParameters(source)
	local templates = getMaps()
	local template = templates[parameters[1]:lower()]
	if not template then return end
	for _, map in ipairs(MapComponent:GetAll()) do
		map:Destroy()
	end
	local map = template:Clone()
	map:PivotTo(CFrame.new())
	map.Parent = Workspace
end

return GranaryCommandService
