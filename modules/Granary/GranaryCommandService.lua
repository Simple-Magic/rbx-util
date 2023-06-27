local Workspace = game:GetService("Workspace")
local Knit = require(script.Parent.Parent.Knit)

local AdminService
local GamemodeService

function getMaps()
	local maps = {}
	for _, map in ipairs(script.Parent.Maps:GetChildren()) do
		maps[map.Name:lower()] = map
	end
	return maps
end

local GranaryCommandService = Knit.CreateService({ Name = "GranaryCommandService" })

function GranaryCommandService:KnitInit() self.Map = Workspace:WaitForChild("Map", 1) end

function GranaryCommandService:KnitStart()
	AdminService = Knit.GetService("AdminService")
	GamemodeService = Knit.GetService("GamemodeService")
	AdminService:AddCommand("SetMap", "/map", function(...) return self:_SetMap(...) end)
	AdminService:AddCommand("Maps", nil, function() return self:_ListMaps() end)
	AdminService:AddCommand("Gamemodes", "/modes", function() return self:_ListGamemodes() end)
	AdminService:AddCommand("Start", nil, function(...) return self:_Start(...) end)
	AdminService:AddCommand("Stop", nil, function(...) return self:_Stop(...) end)
end

function GranaryCommandService:_Start(_: TextSource, source: string)
	local parameters = AdminService.commandParameters(source)
	GamemodeService:Start(parameters[1])
end

function GranaryCommandService:_Stop() GamemodeService:Stop() end

function GranaryCommandService:_SetMap(_: TextSource, source: string): string
	local parameters = AdminService.commandParameters(source)
	local templates = getMaps()
	local template = templates[parameters[1]:lower()]
	if not template then return "No map found." end
	if self.Map then self.Map:Destroy() end
	self.Map = template:Clone()
	self.Map:PivotTo(CFrame.new())
	self.Map.Parent = Workspace
	return "Map loaded."
end

function GranaryCommandService:_ListMaps(): string
	list = "<b>Maps:</b>"
	for _, map in pairs(getMaps()) do
		list ..= ("\n- %s"):format(map.Name)
	end
	return list
end

function GranaryCommandService:_ListGamemodes(): string
	list = "<b>Gamemodes:</b>"
	for _, mode in pairs(GamemodeService.Gamemodes) do
		list ..= ("\n- %s"):format(mode.Name)
	end
	return list
end

return GranaryCommandService
