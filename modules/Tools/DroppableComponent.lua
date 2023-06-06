local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Component = require(script.Parent.Parent.Component)
local Trove = require(script.Parent.Parent.Trove)
local Knit = require(script.Parent.Parent.Knit)

local DroppableService

local DroppableComponent = Component.new({ Tag = "Droppable" })

function DroppableComponent:Construct()
	self.Trove = Trove.new()
	if RunService:IsServer() then
		self.Light = Instance.new("PointLight")
		self.ProximityPrompt = Instance.new("ProximityPrompt")
		self.ProximityPrompt.HoldDuration = 0.2
		self.ProximityPrompt.ObjectText = self.Instance.Name
		self.ProximityPrompt.ActionText = "Equip"
	end
end

function DroppableComponent:Start()
	DroppableService = DroppableService or Knit.GetService("DroppableService")
	if RunService:IsServer() then
		self.Trove:Connect(self.Instance.AncestryChanged, function() self:OnAncestryChanged() end)
		self.Trove:Connect(
			self.ProximityPrompt.Triggered,
			function(player) DroppableService:PickUp(player, self.Instance) end
		)
		task.wait()
		self:OnAncestryChanged()
	elseif RunService:IsClient() then
		self.Trove:Connect(self.Instance.Equipped, function()
			if self.Instance.Parent ~= Players.LocalPlayer.Character then return end
			self:OnEquipped()
		end)
		self.Trove:Connect(self.Instance.Unequipped, function() self:OnUnequipped() end)
		self.Trove:Connect(
			Players.LocalPlayer.CharacterRemoving,
			function() self:OnUnequipped() end
		)
	end
end

function DroppableComponent:Stop() self.Trove:Clean() end

function DroppableComponent:GetPlayer(): Player?
	if self.Instance.Parent.Parent and self.Instance.Parent.Parent:IsA("Player") then
		return self.Instance.Parent.Parent
	end
	return Players:GetPlayerFromCharacter(self.Instance.Parent)
end

function DroppableComponent:OnEquipped()
	self.EquipTrove = self.Trove:Extend()
	self.EquipTrove:Connect(UserInputService.InputEnded, function(...) self:OnRelease(...) end)
end

function DroppableComponent:OnUnequipped()
	if self.EquipTrove then self.EquipTrove:Clean() end
end

function DroppableComponent:OnRelease(inputObject: InputObject, processed: boolean)
	if processed then return end
	if table.find({
		Enum.KeyCode.G,
		Enum.KeyCode.ButtonB,
	}, inputObject.KeyCode) then
		DroppableService:Drop(self.Instance)
	end
end

function DroppableComponent:OnAncestryChanged()
	self.AncestrySequence = (self.AncestrySequence or 0) + 1
	local current = self.AncestrySequence
	local player = self:GetPlayer()
	if player then
		self.Light.Parent = nil
		self.ProximityPrompt.Parent = nil
		self.Instance.Handle.Anchored = false
	elseif self.Instance:IsDescendantOf(Workspace) then
		self.Light.Parent = self.Instance.Handle
		self.ProximityPrompt.Parent = self.Instance.Handle
		self.Instance.Handle.Anchored = true
		self.Instance.Handle.CanCollide = false
		self.Instance.Handle.CanQuery = false
		self.Instance.Handle.CanTouch = false
		while self.AncestrySequence == current do
			self:Float()
			task.wait()
		end
	end
end

function DroppableComponent:Float()
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { self.Instance }
	local raycastResult
	repeat
		raycastResult =
			Workspace:Raycast(self.Instance.Handle.Position, Vector3.yAxis * -32, raycastParams)
		if raycastResult and raycastResult.Instance then
			raycastParams:AddToFilter(raycastResult.Instance.Parent)
		end
	until not raycastResult
		or not raycastResult.Instance
		or (
			not raycastResult.Instance.Parent:IsA("Tool")
			and not raycastResult.Instance.Parent:IsA("Accessory")
			and not raycastResult.Instance.Parent:FindFirstChild("Humanoid")
		)
	if raycastResult then
		local _, rotY = self.Instance.Handle.CFrame:ToEulerAnglesYXZ()
		self.Instance.Handle.CFrame = CFrame.new(raycastResult.Position + Vector3.yAxis * 2)
			* CFrame.fromEulerAnglesYXZ(0, rotY, 0)
	end
	self.Instance.Handle.CFrame *= CFrame.Angles(0, 0.05, 0)
end

return DroppableComponent
