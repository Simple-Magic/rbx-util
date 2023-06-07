local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Component = require(script.Parent.Parent.Component)
local Trove = require(script.Parent.Parent.Trove)
local compose = require(script.Parent.Parent.compose)
local GunConfig = require(script.Parent.GunConfig)

local GunComponent = Component.new({ Tag = "Gun" })

function GunComponent:Construct()
	self.Trove = Trove.new()
	self.Config = GunConfig[self.Instance.Name]
	if RunService:IsClient() then
		self.Gui = compose("ScreenGui", { Name = "Gun" }, {
			compose("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(0.5, 0, 0.7, 0),
				Size = UDim2.new(0, 0, 0, 0),
				Text = "",
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 20,
				TextStrokeColor3 = Color3.new(0, 0, 0),
				TextStrokeTransparency = 0.5,
			}),
		})
	end
end

function GunComponent:Start()
	if RunService:IsServer() then
		self.Trove:Connect(self.Instance.Activated, function() self:OnActivated() end)
		self.Trove:Connect(self.Instance.Equipped, function() self:OnEquipped() end)
		self.Trove:Connect(self.Instance.Unequipped, function() self:OnUnequipped() end)
	elseif RunService:IsClient() then
		self.Trove:Connect(
			self.Instance.Equipped,
			function() self.Gui.Parent = Players.LocalPlayer.PlayerGui end
		)
		self.Trove:Connect(self.Instance.Unequipped, function() self.Gui.Parent = nil end)
		self.Trove:Connect(self.Instance.Changed, function() self:OnChange() end)
		self:OnChange()
	end
end

function GunComponent:Stop() self.Trove:Clean() end

function GunComponent:OnChange()
	self.Gui.TextLabel.Text = ("%d %s %d"):format(
		self:GetAmmo(),
		self:GetReloading() and "R" or "/",
		self.Config.ClipSize
	)
end

function GunComponent:GetAmmo(): number return self.Instance:GetAttribute("Ammo") or 0 end
function GunComponent:SetAmmo(value: number) return self.Instance:SetAttribute("Ammo", value) end
function GunComponent:GetReloading(): boolean
	return self.Instance:GetAttribute("Reloading") or false
end
function GunComponent:SetReloading(value: boolean)
	return self.Instance:SetAttribute("Reloading", value)
end

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
	self.EquipSequence = (self.EquipSequence or 0) + 1
	local animator = self:GetAnimator()
	self.ShotTrack = animator:LoadAnimation(self.Instance.Shot)
	self.ReloadTrack = animator:LoadAnimation(self.Instance.Reload)
	self.Instance.Handle.Equip:Play()
end

function GunComponent:OnUnequipped()
	self.EquipSequence = (self.EquipSequence or 0) + 1
	if self.ShotTrack then self.ShotTrack:Stop() end
	if self.ReloadTrack then self.ReloadTrack:Stop() end
	self.Instance.Handle.Equip:Stop()
	self.Instance.Handle.Reload:Stop()
	self.Instance.Handle.Shot:Stop()
end

function GunComponent:OnActivated()
	if self:GetReloading() then return end
	if self:GetAmmo() > 0 then
		self:SetAmmo(self:GetAmmo() - 1)
		if self.ShotTrack then self.ShotTrack:Play(0, 1e3) end
		self.Instance.Handle.Shot:Play()
	else
		self:Reload()
	end
end

function GunComponent:Reload()
	self:SetReloading(true)
	self.ReloadTrack:Play(0, 1e3)
	self.Instance.Handle.Reload:Play()
	local current = self.EquipSequence
	task.wait(self.Config.ReloadTime)
	if self.EquipSequence == current then self:SetAmmo(self.Config.ClipSize) end
	self:SetReloading(false)
end

return GunComponent
