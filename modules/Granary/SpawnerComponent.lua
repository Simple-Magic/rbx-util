local Workspace = game:GetService("Workspace")
local Component = require(script.Parent.Parent.Component)
local PropConfig = require(script.Parent.PropConfig)

local SpawnerComponent = Component.new({ Tag = "Spawner" })

function SpawnerComponent:Clone(template: PVInstance): PVInstance
	local clone = template:Clone()
	clone:PivotTo(self.Instance:GetPivot())
	clone.Parent = Workspace
	return clone
end

function SpawnerComponent:GetTool(): Tool
	local parts = Workspace:GetPartBoundsInBox(self.Instance.CFrame, self.Instance.Size)
	for _, part in ipairs(parts) do
		if part.Parent:IsA("Tool") then return part.Parent end
	end
end

function SpawnerComponent:SpawnRandomProp()
	local tool = self:GetTool()
	if tool then tool:Destroy() end
	local spawnableProps = {}
	for propName, config in pairs(PropConfig) do
		if config.Spawns then table.insert(spawnableProps, propName) end
	end
	local propName = spawnableProps[math.random(1, #spawnableProps)]
	return self:Clone(script.Parent.Props[propName])
end

return SpawnerComponent
