local Knit = require(script.Parent.Parent.Knit)

local GamemodeService = Knit.CreateService({
	Name = "GamemodeService",
	Gamemodes = {} :: Table<string, Class<Gamemode>>,
	CurrentInstance = nil :: Gamemode?,
})

function GamemodeService:KnitInit()
	for _, instance in ipairs(script.Parent.Gamemodes:GetChildren()) do
		if not instance:IsA("ModuleScript") then continue end
		local gamemode = require(instance)
		gamemode.Name = instance.Name
		self.Gamemodes[instance.Name:lower()] = gamemode
	end
end

function GamemodeService:Start(name: string)
	self:Stop()
	local Gamemode = self.Gamemodes[name:lower()]
	self.CurrentInstance = Gamemode.new()
	self.CurrentInstance:Start()
end

function GamemodeService:Stop()
	if not self.CurrentInstance then return end
	self.CurrentInstance:Stop()
	self.CurrentInstance = nil
end

return GamemodeService
