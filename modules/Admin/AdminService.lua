local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TextChatService = game:GetService("TextChatService")
local Knit = require(script.Parent.Parent.Knit)
local AdminSelector = require(script.Parent.AdminSelector)

local LogService

--[=[
	@class AdminService
	@server

	```lua
	local AdminService = Knit.GetService("AdminService")
	```
]=]
--[=[
	@within AdminService
	@prop AdminSelector AdminSelector
]=]
local AdminService = Knit.CreateService({
	Name = "AdminService",
	AdminSelector = AdminSelector,
	_Selectors = {},
	_Commands = {} :: { TextChatCommand },
	_ActiveAdmins = {} :: Table<number, true>,
})

--[=[
	Parse source parameters.
]=]
function AdminService.commandParameters(source: string): { string }
	local params = source:gsub("  ", " "):split(" ")
	table.remove(params, 1)
	return params
end

--[=[
	Get Player by name.
]=]
function AdminService.playerFromName(name: string, me: Player): Player?
	if name:lower() == "me" then return me end
	for _, player in ipairs(Players:GetChildren()) do
		if player.Name:lower() == name:lower() then return player end
		if player:IsA("Player") and player.DisplayName:lower() == name:lower() then
			return player
		end
	end
end

--[=[
	Get players with name list.
]=]
function AdminService.playersFromNames(names: { string }, me: Player): { Player }
	local players = {}
	for _, name in ipairs(names) do
		local player = AdminService.playerFromName(name, me)
		if player and not table.find(players, player) then table.insert(players, player) end
		if name:lower() == "all" then return Players:GetChildren() end
	end
	return players
end

function AdminService.tools(): Table<string, Tool>
	local tools = {}
	for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
		if descendant:IsA("Tool") then tools[descendant.Name:lower()] = descendant end
	end
	for _, descendant in ipairs(ServerStorage:GetDescendants()) do
		if descendant:IsA("Tool") then tools[descendant.Name:lower()] = descendant end
	end
	return tools
end

function AdminService:KnitStart()
	LogService = Knit.GetService("LogService")
	Players.PlayerAdded:Connect(function(...) self:_OnPlayer(...) end)
	Players.PlayerRemoving:Connect(function(...) self:_OnPlayerRemoving(...) end)
	for _, player in ipairs(Players:GetPlayers()) do
		self:_OnPlayer(player)
	end
	self:AddSelector(AdminSelector.user(3914160083)) -- CFG_erm
	self:AddSelector(AdminSelector.user(3836079781)) -- rasmusmerzin
end

--[=[
	Add admin selector.
]=]
function AdminService:AddSelector(selector: AdminSelector)
	table.insert(self._Selectors, selector)
	for _, player in ipairs(Players:GetPlayers()) do
		if selector:MatchPlayer(player) then self:_AddActiveAdmin(player) end
	end
end

--[=[
	Check if player is admin.
]=]
function AdminService:IsActiveAdmin(userId: number | Player): boolean
	if type(userId) ~= "number" then userId = userId.UserId end
	return self._ActiveAdmins[userId] or false
end

function AdminService:_OnPlayer(player: Player)
	for _, selector in ipairs(self._Selectors) do
		if selector:MatchPlayer(player) then
			self:_AddActiveAdmin(player)
			break
		end
	end
end

function AdminService:_OnPlayerRemoving(player: Player) self:_RemoveActiveAdmin(player) end

function AdminService:_AddActiveAdmin(userId: number | Player)
	if type(userId) ~= "number" then userId = userId.UserId end
	if self._ActiveAdmins[userId] then return end -- already added
	local player = Players:GetPlayerByUserId(userId)
	LogService:LogTo(player, "You are an admin.")
	self._ActiveAdmins[userId] = true
end

function AdminService:_RemoveActiveAdmin(userId: number | Player)
	if type(userId) ~= "number" then userId = userId.UserId end
	if not self._ActiveAdmins[userId] then return end -- not added
	local player = Players:GetPlayerByUserId(userId)
	LogService:LogTo(player, "You are no longer an admin.")
	self._ActiveAdmins[userId] = nil
end

--[=[
	Bind a callback to an admin command endpoint.
]=]
function AdminService:AddCommand(
	name: string,
	alias: string?,
	callback: (origin: TextSource, source: string) -> string
)
	if self._Commands[name] then return end
	self._Commands[name] = Instance.new("TextChatCommand")
	self._Commands[name].Name = ("%sCommand"):format(name)
	self._Commands[name].PrimaryAlias = ("/%s"):format(string.lower(name))
	if alias then self._Commands[name].SecondaryAlias = alias end
	self._Commands[name].Parent = TextChatService
	self._Commands[name].Triggered:Connect(function(origin, source)
		local player = Players:GetPlayerByUserId(origin.UserId)
		if self:IsActiveAdmin(player) then
			local ok, msg = pcall(function() return callback(origin, source) end)
			if msg then LogService:LogTo(player, ok and msg or ("Error: %s"):format(msg)) end
		else
			LogService:LogTo(player, "You have to be an admin to execute this command.")
		end
	end)
end

return AdminService
