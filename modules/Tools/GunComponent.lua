local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Component = require(ReplicatedStorage.Packages.Component)
local Trove = require(ReplicatedStorage.Packages.Trove)

if RunService:IsClient() then return end

local GunComponent = Component.new({ Tag = "Gun" })

function GunComponent:Construct() self.Trove = Trove.new() end

function GunComponent:Start()
	self.Trove:Connect(self.Instance.Activated, function() self:OnActivated() end)
	self.Trove:Connect(self.Instance.Equipped, function() self:OnEquipped() end)
	self.Trove:Connect(self.Instance.Unequipped, function() self:OnUnequipped() end)
end

function GunComponent:Stop() self.Trove:Clean() end

function GunComponent:GetPlayer(): Player?
	if self.Instance.Parent.Parent:IsA("Player") then return self.Instance.Parent.Parent end
	return Players:GetPlayerFromCharacter(self.Instance.Parent)
end

function GunComponent:GetAnimator(): Animator?
	local player = self:GetPlayer()
	if not player or not player.Character then return end
	local humanoid = player.Character:FindFirstChild("Humanoid") :: Humanoid?
	return humanoid and humanoid:FindFirstChild("Animator")
end

function GunComponent:OnEquipped()
	local animator = self:GetAnimator()
	self.ShotTrack = animator:LoadAnimation(self.Instance.Shot)
end

function GunComponent:OnUnequipped() self.ShotTrack:Stop() end

function GunComponent:OnActivated() self.ShotTrack:Play(0, 1e3) end

return GunComponent
