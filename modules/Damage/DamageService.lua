local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Knit = require(script.Parent.Parent.Knit)
local Signal = require(script.Parent.Parent.Signal)

local DamageService = Knit.CreateService({
	Name = "DamageService",
	Damaged = Signal.new(),
})

function DamageService:Damage(
	humanoid: Humanoid,
	damage: number,
	creatorPlayer: Player?,
	weapon: string?
)
	if self:Verify(humanoid, creatorPlayer) then return end
	self:Tag(humanoid, creatorPlayer, weapon)
	self:DisplayHit(humanoid)
	humanoid:TakeDamage(damage)
	self.Damaged:Fire(humanoid, damage, creatorPlayer, weapon)
end

function DamageService:Tag(humanoid: Humanoid, creatorPlayer: Player?, weapon: string?): boolean
	local creator = humanoid:FindFirstChild("creator")
	if creator then creator:Destroy() end
	creator = Instance.new("ObjectValue")
	creator.Name = "creator"
	creator.Value = creatorPlayer
	if weapon then creator:SetAttribute("Weapon", weapon) end
	creator.Parent = humanoid
end

function DamageService:Verify(humanoid: Humanoid, creatorPlayer: Player?): boolean
	if humanoid.Health == 0 then
		return 0 -- ignore dead
	end
	local targetPlayer = Players:GetPlayerFromCharacter(humanoid.Parent)
	if creatorPlayer and creatorPlayer == targetPlayer then
		return 1 -- ignore self
	end
	if
		creatorPlayer
		and targetPlayer
		and not creatorPlayer.Neutral
		and not targetPlayer.Neutral
		and creatorPlayer.TeamColor == targetPlayer.TeamColor
	then
		return 2 -- ignore teammate
	end
end

function DamageService:DisplayHit(humanoid: Humanoid)
	local character = humanoid.Parent
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local splat = script.Parent.Splat:Clone()
	splat.CFrame = root.CFrame
	splat.Parent = Workspace
	Debris:AddItem(splat, 0.3)
	local dropCFrame = root.CFrame
		* CFrame.Angles(0, math.pi * 2 * math.random(), 0)
		* CFrame.new(0, 0, -math.random() * 2)
	self:DropBlood(dropCFrame.Position)
end

function DamageService:DropBlood(location: Vector3)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	local raycastResult
	repeat
		raycastResult = Workspace:Raycast(location, Vector3.yAxis * -16, raycastParams)
		if raycastResult and raycastResult.Instance then
			raycastParams:AddToFilter(raycastResult.Instance)
		end
	until not raycastResult or not raycastResult.Instance or raycastResult.Instance.Anchored
	if not raycastResult or not raycastResult.Instance then return end
	local blood = Instance.new("Part")
	blood.Shape = Enum.PartType.Cylinder
	blood.Anchored = true
	blood.CanCollide = false
	blood.CanQuery = false
	blood.CanTouch = false
	local size = 1 + math.random() * 2
	blood.Size = Vector3.new(0.1, size, size)
	blood.CFrame = CFrame.new(raycastResult.Position) * CFrame.Angles(0, 0, math.pi / 2)
	blood.Color = Color3.new(0.83, 0, 0.02)
	blood.Parent = Workspace
	Debris:AddItem(blood, 5)
end

return DamageService
