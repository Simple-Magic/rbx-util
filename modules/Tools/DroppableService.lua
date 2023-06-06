local Workspace = game:GetService("Workspace")
local Knit = require(script.Parent.Parent.Knit)
require(script.Parent.DroppableComponent)

local DroppableService = Knit.CreateService({
	Name = "DroppableService",
	Client = {},
})

function DroppableService:PickUp(player: Player, tool: Tool)
	local current = player.Character and player.Character:FindFirstChildWhichIsA("Tool")
	if current then current.Parent = player.Backpack end
	tool.Parent = player.Character
end

function DroppableService.Client:Drop(player: Player, tool: Tool)
	if tool.Parent ~= player.Character then return end
	if tool.CanBeDropped then
		tool.Parent = Workspace:FindFirstChild("Debris") or Workspace
		tool.Handle.CFrame = player.Character:GetPivot() * CFrame.new(0, 6, -6)
	else
		tool.Parent = player.Backpack
	end
end

return DroppableService
