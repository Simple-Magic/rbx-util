local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")
local Knit = require(script.Parent.Parent.Knit)

local DamageService

local BulletService = Knit.CreateService({ Name = "BulletService" })

function BulletService:KnitStart() DamageService = Knit.GetService("DamageService") end

function BulletService:Create(gun: GunComponent, target: Vector3)
	local raycastResult = self:Cast(gun.Instance.Handle.MuzzleAttachment.WorldPosition, target)
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.Size = Vector3.zero
	part.CFrame = CFrame.new(raycastResult.Position)
	local attachment = Instance.new("Attachment")
	attachment.Parent = part
	local beam = Instance.new("Beam")
	beam.Attachment0 = gun.Instance.Handle.MuzzleAttachment
	beam.Attachment1 = attachment
	beam.Parent = part
	part.Parent = Workspace
	Debris:AddItem(part, 0.1)
	if raycastResult.Instance then
		local humanoid = raycastResult.Instance.Parent:FindFirstChild("Humanoid")
			or raycastResult.Instance.Parent.Parent:FindFirstChild("Humanoid")
		DamageService:Damage(humanoid, gun.Config.Damage, gun:GetPlayer())
	end
end

function BulletService:Cast(origin: Vector3, target: Vector3): RaycastResult?
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	local raycastResult
	local direction = target - origin
	repeat
		raycastResult = Workspace:Raycast(origin, direction.Unit * 2048, raycastParams)
		if raycastResult and raycastResult.Instance then
			raycastParams:AddToFilter(raycastResult.Instance)
		end
	until not raycastResult
		or not raycastResult.Instance
		or not raycastResult.Instance.Parent:IsA("Tool")
	return raycastResult
end

return BulletService
