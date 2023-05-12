local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local Timer = require(script.Parent.Timer)

local Repository = {
	Name = "Global",
}
Repository.__index = Repository

function Repository.new(init)
	local self = setmetatable(init or {}, Repository)
	self.Entity = self.Entity or {}
	self.Entity.__index = self.Entity
	function self.Entity:Start() end
	self.Store = DataStoreService:GetDataStore(self.Name)
	self.Cache = {} :: Table<string, Profile>
	Players.PlayerAdded:Connect(function(player: Player) self:OnPlayer(player, true) end)
	Players.PlayerRemoving:Connect(function(...) self:OnPlayer(...) end)
	self.Timer = Timer.new(init.Interval or 60)
	self.Timer.Tick:Connect(function() self:OnTick() end)
	self.Timer:Start()
	return self
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
