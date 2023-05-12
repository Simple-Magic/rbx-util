return function(
	className: string,
	properties: Table<string, any>?,
	children: { Instance }?
): Instance
	local instance = Instance.new(className)
	for key, value in pairs(properties or {}) do
		instance[key] = value
	end
	for _, child in pairs(children or {}) do
		child.Parent = instance
	end
	return instance
end
