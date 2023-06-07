local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Component = require(script.Parent.Parent.Component)
local Trove = require(script.Parent.Parent.Trove)
local Knit = require(script.Parent.Parent.Knit)
local MeleeConfig = require(script.Parent.MeleeConfig)

if RunService:IsClient() then return nil end

local DamageService

local MeleeComponent = Component.new({ Tag = "Melee" })

function MeleeComponent:Construct()
	self.Trove = Trove.new()
	self.Config = MeleeConfig[self.Instance.Name]
end

function MeleeComponent:Start()
	DamageService = DamageService or Knit.GetService("DamageService")
	self.Trove:Connect(self.Instance.Activated, function() self:OnActivated() end)
	self.Trove:Connect(self.Instance.Equipped, function() self:OnEquipped() end)
	self.Trove:Connect(self.Instance.Unequipped, function() self:OnUnequipped() end)
end

function MeleeComponent:Stop() self.Trove:Clean() end

function MeleeComponent:GetPlayer(): Player?
	if self.Instance.Parent.Parent:IsA("Player") then return self.Instance.Parent.Parent end
	return Players:GetPlayerFromCharacter(self.Instance.Parent)
end

function MeleeComponent:GetAnimator(): Animator?
	local player = self:GetPlayer()
	if not player or not player.Character then return end
	local humanoid = player.Character:FindFirstChild("Humanoid") :: Humanoid?
	return humanoid and humanoid:FindFirstChild("Animator")
end

function MeleeComponent:OnEquipped()
	local animator = self:GetAnimator()
	self.SlashTrack = animator:LoadAnimation(self.Instance.Slash)
	self.EquipTrove = self.Trove:Extend()
	self.EquipTrove:Connect(self.Instance.Handle.Touched, function(...) self:OnTouched(...) end)
end

function MeleeComponent:OnUnequipped()
	if self.EquipTrove then self.EquipTrove:Clean() end
	if self.SlashTrack then self.SlashTrack:Stop() end
end

function MeleeComponent:OnActivated()
	if self.SlashTrack then self.SlashTrack:Play(0, 1e3) end
end

function MeleeComponent:OnTouched(part: BasePart)
	local humanoid = part.Parent:FindFirstChild("Humanoid")
	if not humanoid then return end
	DamageService:Damage(humanoid, self.Config.Damage, self:GetPlayer())
end

return MeleeComponent
