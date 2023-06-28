local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Component = require(script.Parent.Parent.Component)
local Knit = require(script.Parent.Parent.Knit)
local PropComponent = require(script.Parent.PropComponent)
local Trove = require(script.Parent.Parent.Trove)

local BulletService
local HitService

local GunComponent = Component.new({ Tag = "Gun" })

function GunComponent:Construct() self.Trove = Trove.new() end

function GunComponent:Start()
	Knit.OnStart():await()
	BulletService = BulletService or Knit.GetService("BulletService")
	HitService = HitService or Knit.GetService("HitService")
	if RunService:IsServer() then
		CollectionService:AddTag(self.Instance, "Prop")
		task.wait()
		local prop = self:GetComponent(PropComponent)
		self.Config = prop.Config
	end
end

function GunComponent:Stop() self.Trove:Clean() end

function GunComponent:GetPlayer(): Player?
	local prop = self:GetComponent(PropComponent)
	return prop and prop:GetPlayer()
end

function GunComponent:GetMuzzle(): Attachment return self.Instance.Handle:FindFirstChild("Muzzle") end

function GunComponent:Activate()
	local shot = self.Instance.Handle:FindFirstChild("Shot") :: Sound
	if shot then shot:Play() end
	local player = self:GetPlayer()
	if not player then return end
	local target = HitService.Hit[player]
	if not target then return end
	for _ = 1, self.Config.Bullets or 1 do
		BulletService:Create(self, target)
	end
end

return GunComponent
