local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local Timer = require(script.Parent.Timer)

--[=[
	@interface Entity
	.Start (self: Entity, player: Player?) -> nil
	@within Repository
]=]
type Entity = {
	Start: (self: Entity, player: Player?) -> nil,
}

--[=[
	@class Repository

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
	Gets an `Entity`.
]=]
function Repository:Get(id: number | string | Player): Entity
	local player
	if type(id) == "number" then
		id = tostring(id)
		player = Players:GetPlayerByUserId(id)
	elseif type(id) == "string" then
		player = Players:GetPlayerByUserId(tonumber(id) or 0)
	else
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

function Repository:_OnTick()
	for _, player in pairs(Players:GetPlayers()) do
		self:_OnPlayer(player)
	end
end

function Repository:_OnPlayer(player: Player, forceUpdate: boolean?)
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

return Repository
