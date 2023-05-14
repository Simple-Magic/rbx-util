--[=[
	@class Maid
]=]
local Maid = {}
Maid.__index = Maid

--[=[
	Creates `Maid` instance.
]=]
function Maid.new(): Maid
	return setmetatable({
		_Items = {} :: { Variant },
	}, Maid)
end

--[=[
	Add item to array.
]=]
function Maid:Add(item: Variant): Variant
	table.insert(self._Items, item)
	return item
end

--[=[
	Add array of items to array.
]=]
function Maid:Append(items: { Variant }): { Variant }
	for _, item in pairs(items) do
		self:Add(item)
	end
	return items
end

--[=[
	Cleanup array.
]=]
function Maid:Destroy()
	for _, item in pairs(self._Items) do
		pcall(function() item:Cancel() end)
		pcall(function() item:Disconnect() end)
		pcall(function() item:Destroy() end)
	end
	self._Items = {}
end

return Maid
