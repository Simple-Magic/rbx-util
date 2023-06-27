local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")
local Knit = require(script.Parent.Parent.Knit)

local DamageService

local BulletService = Knit.CreateService({ Name = "BulletService" })

function BulletService:KnitStart() DamageService = Knit.GetService("DamageService") end

function BulletService:Create(gun: GunComponent, target: Vector3)
	local player = gun:GetPlayer()
	local raycastResult = self:Cast(gun:GetMuzzle().WorldPosition, target, { player.Character })
	if not raycastResult then return end
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.BrickColor = BrickColor.Black()
	part.Shape = Enum.PartType.Cylinder
	part.Size = Vector3.new(0.05, 0.2, 0.2)
	part.CFrame = CFrame.new(raycastResult.Position)
		* CFrame.new(Vector3.zero, raycastResult.Normal)
		* CFrame.Angles(0, math.pi / 2, 0)
	local attachment = Instance.new("Attachment")
	attachment.Parent = part
	local beam = Instance.new("Beam")
	beam.Attachment0 = gun:GetMuzzle()
	beam.Attachment1 = attachment
	beam.Width0 = 0.2
	beam.Width1 = 0.2
	beam.Parent = part
	part.Parent = Workspace
	Debris:AddItem(beam, 0.1)
	Debris:AddItem(part, 5)
	if not raycastResult.Instance then return end
	local humanoid = raycastResult.Instance.Parent:FindFirstChild("Humanoid")
		or raycastResult.Instance.Parent.Parent:FindFirstChild("Humanoid")
	if not humanoid then return end
	DamageService:Damage(humanoid, gun.Config.Damage, player)
end

function BulletService:Cast(origin: Vector3, target: Vector3, filter: { Instance }): RaycastResult?
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = filter
	local raycastResult
	local direction = target - origin
	repeat
		raycastResult = Workspace:Raycast(origin, direction.Unit * 2048, raycastParams)
		if raycastResult and raycastResult.Instance then
			raycastParams:AddToFilter(raycastResult.Instance)
		end
	until not raycastResult or not raycastResult.Instance or raycastResult.Instance.CanCollide
	return raycastResult
end

return BulletService
