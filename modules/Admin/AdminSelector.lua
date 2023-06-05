--[=[
	@class AdminSelector
]=]
--[=[
	@within AdminSelector
	@prop UserId number?
]=]
--[=[
	@within AdminSelector
	@prop GroupId number?
]=]
--[=[
	@within AdminSelector
	@prop MinRank number?
]=]
local AdminSelector = {
	UserId = nil :: number?,
	GroupId = nil :: number?,
	MinRank = nil :: number?,
}
AdminSelector.__index = AdminSelector

--[=[
	Create user selector.
]=]
function AdminSelector.user(userId: number): AdminSelector
	return setmetatable({
		UserId = userId,
	}, AdminSelector)
end

--[=[
	Create group selector.
]=]
function AdminSelector.group(groupId: number, minRank: number?): AdminSelector
	return setmetatable({
		GroupId = groupId,
		MinRank = minRank,
	}, AdminSelector)
end

--[=[
	Check if player matches selector.
]=]
function AdminSelector:MatchPlayer(player: Player): boolean
	if self.UserId == player.UserId then return true end
	if self.GroupId then return player:GetRankInGroup(self.GroupId) >= (self.MinRank or 1) end
	return false
end

return AdminSelector
