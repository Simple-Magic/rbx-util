local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local Timer = require(script.Parent.Timer)

local Repository = {
	Name = "Global",
}
Repository.__index = Repository

function Repository.new(init)
	local this = setmetatable(init or {}, Repository)
	this.Entity = this.Entity or {}
	this.Entity.__index = this.Entity
	function this.Entity:Start() end
	this.Store = DataStoreService:GetDataStore(this.Name)
	this.Cache = {} :: Table<string, Profile>
	Players.PlayerAdded:Connect(function(player: Player) this:OnPlayer(player, true) end)
	Players.PlayerRemoving:Connect(function(...) this:OnPlayer(...) end)
	this.Timer = Timer.new(init.Interval or 60)
	this.Timer.Tick:Connect(function() this:OnTick() end)
	this.Timer:Start()
	return this
end

function Repository:OnTick()
	for _, player in pairs(Players:GetPlayers()) do
		self:OnPlayer(player)
	end
end

function Repository:OnPlayer(player: Player, forceUpdate: boolean?)
	local id = tostring(player.UserId)
	local cache = self.Cache[id]
	if cache and not forceUpdate then
		self.Store:UpdateAsync(id, function(data)
			data = data or {}
			for key, value in pairs(cache) do
				data[key] = value
			end
			return data
		end)
	else
		self.Cache[id] = setmetatable(self.Store:GetAsync(id) or {}, self.Entity)
		self.Cache[id]:Start(player)
	end
end

function Repository:Get(id: number | string | Player)
	local player
	if type(id) == "number" then
		id = tostring(id)
		player = Players:GetPlayerByUserId(id)
	elseif type(id) ~= "string" then
		id = tostring(id.UserId)
		player = id
	end
	local cache = self.Cache[id]
	if cache then
		return cache
	else
		self.Cache[id] = setmetatable(self.Store:GetAsync(id) or {}, self.Entity)
		self.Cache[id]:Start(player)
		return self.Cache[id]
	end
end

return Repository
