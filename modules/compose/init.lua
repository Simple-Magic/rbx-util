--[=[
	@class compose
]=]

--[=[
	@function compose
	@within compose
	Creates an `Instance` and assigns properties.
]=]
return function(
	className: string,
	properties: Table<string, any>?,
	children: { Instance }?
): Instance
	local instance = Instance.new(className)
	for key, value in pairs(properties or {}) do
		if key == "TextSize" then
			instance.TextSize = value
		else
			instance[key] = value
		end
	end
	for _, child in pairs(children or {}) do
		child.Parent = instance
	end
	return instance
end
