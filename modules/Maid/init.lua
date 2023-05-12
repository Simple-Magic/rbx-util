local Maid = {}
Maid.__index = Maid

function Maid.new(): Maid return setmetatable({ _Items = {} :: { Variant } }, Maid) end

function Maid:Add(item: Variant): Variant
	table.insert(self._Items, item)
	return item
end

function Maid:Append(items: { Variant }): { Variant }
	for _, item in pairs(items) do
		self:Add(item)
	end
	return items
end

function Maid:Destroy()
	for _, item in pairs(self._Items) do
		pcall(function() item:Cancel() end)
		pcall(function() item:Disconnect() end)
		pcall(function() item:Destroy() end)
	end
end

return Maid
