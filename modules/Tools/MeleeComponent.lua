local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Component = require(ReplicatedStorage.Packages.Component)
local Trove = require(ReplicatedStorage.Packages.Trove)

if RunService:IsClient() then return end

local MeleeComponent = Component.new({ Tag = "Melee" })

function MeleeComponent:Construct() self.Trove = Trove.new() end

function MeleeComponent:Start()
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
end

function MeleeComponent:OnUnequipped() self.SlashTrack:Stop() end

function MeleeComponent:OnActivated() self.SlashTrack:Play(0, 1e3) end

return MeleeComponent
