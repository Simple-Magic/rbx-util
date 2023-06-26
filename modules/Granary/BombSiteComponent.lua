local Workspace = game:GetService("Workspace")
local Component = require(script.Parent.Parent.Component)

local BombSiteComponent = Component.new({ Tag = "BombSite" })

function BombSiteComponent:Contains(part: BasePart): boolean
	local parts = Workspace:GetPartBoundsInBox(self.Instance.CFrame, self.Instance.Size)
	return table.find(parts, part) and true or false
end

return BombSiteComponent
