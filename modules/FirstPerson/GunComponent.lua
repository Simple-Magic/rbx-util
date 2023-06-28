local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Component = require(script.Parent.Parent.Component)
local Knit = require(script.Parent.Parent.Knit)
local PropComponent = require(script.Parent.PropComponent)
local Trove = require(script.Parent.Parent.Trove)

local BulletService
local FirstPersonService
local HitService

local GunComponent = Component.new({ Tag = "Gun" })

function GunComponent:Construct() self.Trove = Trove.new() end

function GunComponent:Start()
	Knit.OnStart():await()
	BulletService = BulletService or Knit.GetService("BulletService")
	FirstPersonService = FirstPersonService or Knit.GetService("FirstPersonService")
	HitService = HitService or Knit.GetService("HitService")
	if RunService:IsServer() then CollectionService:AddTag(self.Instance, "Prop") end
	task.wait()
	local prop = self:GetComponent(PropComponent)
	self.Config = prop and prop.Config
end

function GunComponent:Stop() self.Trove:Clean() end

function GunComponent:GetPlayer(): Player?
	local prop = self:GetComponent(PropComponent)
	return prop and prop:GetPlayer()
end

function GunComponent:GetSide(): string
	local prop = self:GetComponent(PropComponent)
	return prop and prop:GetSide()
end

function GunComponent:GetMuzzle(): Attachment return self.Instance.Handle:FindFirstChild("Muzzle") end

function GunComponent:GetAmmoInClip(): number return self.Instance:GetAttribute("AmmoInClip") or 0 end
function GunComponent:SetAmmoInClip(value: number)
	self.Instance:SetAttribute("AmmoInClip", value)
	self.Instance.ToolTip = ("%d/%d"):format(value, self.Config.ClipSize)
end

function GunComponent:Reload()
	if not self.Instance.Enabled then return end
	local sound = self.Instance.Handle:FindFirstChild("Reload") :: Sound
	if sound then sound:Play() end
	self.Instance.ToolTip = ("R/%d"):format(self.Config.ClipSize)
	self.Instance.Enabled = false
	repeat
		task.wait()
	until not FirstPersonService.GripLock[self:GetSide()][self:GetPlayer()]
	FirstPersonService:Reload(self:GetPlayer(), self:GetSide(), self.Config.ReloadTime)
	task.wait(self.Config.ReloadTime)
	self:SetAmmoInClip(self.Config.ClipSize)
	self.Instance.Enabled = true
end

function GunComponent:Activate()
	if not self.Instance.Enabled then return end
	if self:GetAmmoInClip() <= 0 then return self:Reload() end
	local shot = self.Instance.Handle:FindFirstChild("Shot") :: Sound
	if shot then shot:Play() end
	local player = self:GetPlayer()
	if not player then return end
	local target = HitService.Hit[player]
	if not target then return end
	for _ = 1, self.Config.Bullets or 1 do
		BulletService:Create(self, target)
	end
	self:SetAmmoInClip(self:GetAmmoInClip() - 1)
end

return GunComponent
