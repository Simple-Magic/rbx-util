local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local Timer = require(script.Parent.Timer)

--[=[
	@interface Entity
	.Start (self: Entity, player: Player?) -> nil
	.Update (self: Entity, player: Player?) -> nil
	@within Repository
]=]
type Entity = {
	Start: (self: Entity, player: Player?) -> nil,
	Update: (self: Entity, player: Player?) -> nil,
}

--[=[
	@class Repository
	@server

	The Repository class is a DataStore wrapper which handles storing and loading.

	```lua
	local ProfileRepository = Repository.new({ Name = "Profiles" })

	function ProfileRepository.Entity:Start(player: Player?)
		if player then self.DisplayName = player.DisplayName end
	end
	```
]=]
local Repository = {
	Name = "Global",
}
Repository.__index = Repository

--[=[
	@within Repository
	@prop Name string
	`DataStore` name to use when accessing `DataStoreService`.
]=]
--[=[
	@within Repository
	@prop Interval number
	Interval at which connected players' entities are saved.
]=]
--[=[
	@within Repository
	@prop Entity Entity
	Entity class used when initializing players' entities.
]=]

--[=[
	@return Repository
	@param init Repository?
	Creates a `Repository`.
]=]
function Repository.new(init)
	local this = setmetatable(init or {}, Repository)
	this.Entity = this.Entity or {}
	this.Entity.__index = this.Entity
	function this.Entity:Start() end
	function this.Entity:Update() end
	this.Store = DataStoreService:GetDataStore(this.Name)
	this.Cache = {} :: Table<string, Profile>
	Players.PlayerAdded:Connect(function(player: Player) this:_OnPlayer(player, true) end)
	Players.PlayerRemoving:Connect(function(...) this:_OnPlayer(...) end)
	this.Timer = Timer.new(init.Interval or 60)
	this.Timer.Tick:Connect(function() this:_OnTick() end)
	this.Timer:Start()
	return this
end

--[=[
	Gets an `Entity` at given id.
]=]
function Repository:Get(id: number | string | Player): Entity
	local player
	id, player = self:_ResolveId(id)
	local cache = self.Cache[id]
	if cache then
		return cache
	else
		self.Cache[id] = setmetatable(self.Store:GetAsync(id) or {}, self.Entity)
		self.Cache[id]:Start(player)
		return self.Cache[id]
	end
end

--[=[
	Saves an `Entity` at given id.
]=]
function Repository:Save(id: number | string | Player)
	local player
	id, player = self:_ResolveId(id)
	local cache = self.Cache[id]
	if not cache then return end
	cache:Update(player)
	self.Store:UpdateAsync(id, function(data)
		data = data or {}
		for key, value in pairs(cache) do
			data[key] = value
		end
		return data
	end)
end

function Repository:_ResolveId(id: number | string | Player): (string, Player?)
	local player
	if type(id) == "number" then
		player = Players:GetPlayerByUserId(id)
		id = tostring(id)
	elseif type(id) == "string" then
		player = Players:GetPlayerByUserId(tonumber(id) or 0)
	else
		player = id
		id = tostring(id.UserId)
	end
	return id, player
end

function Repository:_OnTick()
	for _, player in pairs(Players:GetPlayers()) do
		self:_OnPlayer(player)
	end
end

function Repository:_OnPlayer(player: Player, forceUpdate: boolean?)
	local cache = self.Cache[tostring(player.UserId)]
	if cache and not forceUpdate then
		self:Save(player)
	else
		self:Get(player)
	end
end

return Repository
