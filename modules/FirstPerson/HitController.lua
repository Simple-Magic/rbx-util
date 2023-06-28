local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Knit = require(script.Parent.Parent.Knit)
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local HitService

local HitController = Knit.CreateController({ Name = "HitController" })

function HitController:KnitInit()
	self.RaycastParams = RaycastParams.new()
	self.RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
end

function HitController:KnitStart()
	HitService = Knit.GetService("HitService")
	Player.CharacterAdded:Connect(function() self:OnCharacter() end)
	if Player.Character then self:OnCharacter() end
	RunService:BindToRenderStep(
		self.Name,
		Enum.RenderPriority.First.Value,
		function() HitService.Hit:Fire(self:Cast() or Mouse.Hit.Position) end
	)
end

function HitController:OnCharacter() self.RaycastParams:AddToFilter(Player.Character) end

function HitController:Cast()
	local raycastResult
	repeat
		local origin = Workspace.CurrentCamera.CFrame.Position
		local delta = Mouse.Hit.Position - origin
		raycastResult = Workspace:Raycast(origin, delta.Unit * 2048, self.RaycastParams)
		if raycastResult and raycastResult.Instance and not raycastResult.Instance.CanCollide then
			self.RaycastParams:AddToFilter(raycastResult.Instance)
		end
	until not raycastResult or not raycastResult.Instance or raycastResult.Instance.CanCollide
	return raycastResult and raycastResult.Position
end

return HitController
