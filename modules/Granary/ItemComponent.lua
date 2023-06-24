local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Component = require(script.Parent.Parent.Component)
local Knit = require(script.Parent.Parent.Knit)
local Trove = require(script.Parent.Parent.Trove)

local ItemService

local ItemComponent = Component.new({ Tag = "Item" })

function ItemComponent:Construct() self.Trove = Trove.new() end

function ItemComponent:Start()
	Knit.OnStart():await()
	ItemService = ItemService or Knit.GetService("ItemService")
	if RunService:IsServer() then
		self.PointLight = self.Trove:Add(Instance.new("PointLight"))
		self.PointLight.Parent = self.Instance.Handle
		self.ProximityPrompt = self.Trove:Add(Instance.new("ProximityPrompt"))
		self.ProximityPrompt.HoldDuration = 0.2
		self.ProximityPrompt.ObjectText = self.Instance.Name
		self.ProximityPrompt.ActionText = "Equip"
		self.ProximityPrompt.Parent = self.Instance.Handle
		self.Trove:Connect(self.Instance.AncestryChanged, function() self:OnServerAncestry() end)
		self.Trove:Connect(
			self.ProximityPrompt.Triggered,
			function(player) ItemService:PickUp(player, self.Instance) end
		)
		task.wait()
		self:OnServerAncestry()
	elseif RunService:IsClient() then
		self.Trove:Connect(self.Instance.AncestryChanged, function() self:OnClientAncestry() end)
		task.wait()
		self:OnClientAncestry()
	end
end

function ItemComponent:Stop() self.Trove:Clean() end

function ItemComponent:GetPlayer(): Player?
	return Players:GetPlayerFromCharacter(self.Instance.Parent)
		or Players:GetPlayerFromCharacter(self.Instance.Parent.Parent)
end

function ItemComponent:GetGrip(): Attachment? return self.Instance.Handle:FindFirstChild("Grip") end

function ItemComponent:OnClientAncestry()
	self.AncestryTrove = self.AncestryTrove or Trove.new()
	self.AncestryTrove:Clean()
	self.Input = {}
	self.AncestrySequence = (self.AncestrySequence or 0) + 1
	local player = self:GetPlayer()
	if player == Players.LocalPlayer then
		self.AncestryTrove:Connect(
			UserInputService.InputBegan,
			function(...) self:OnUserInputBegan(...) end
		)
		self.AncestryTrove:Connect(
			UserInputService.InputEnded,
			function(...) self:OnUserInputEnded(...) end
		)
	end
end

function ItemComponent:OnUserInputEnded(inputObject: InputObject, processed: boolean)
	self.Input[inputObject.KeyCode] = nil
	self.Input[inputObject.UserInputType] = nil
end

function ItemComponent:OnUserInputBegan(inputObject: InputObject, processed: boolean)
	if processed then return end
	self.Input[inputObject.KeyCode] = true
	self.Input[inputObject.UserInputType] = true
	if inputObject.KeyCode == Enum.KeyCode.G or inputObject.KeyCode == Enum.KeyCode.ButtonB then
		ItemService:Drop(self.Instance)
	elseif
		self.Instance.Parent.Name:match("^Right")
		and (
			inputObject.UserInputType == Enum.UserInputType.MouseButton1
			or inputObject.KeyCode == Enum.KeyCode.ButtonL1
		)
	then
		repeat
			ItemService:Activate(self.Instance)
			task.wait(0.1)
		until not self.Input[Enum.UserInputType.MouseButton1]
			and not self.Input[Enum.KeyCode.ButtonL1]
	elseif
		self.Instance.Parent.Name:match("^Left")
		and (
			inputObject.UserInputType == Enum.UserInputType.MouseButton2
			or inputObject.KeyCode == Enum.KeyCode.ButtonR1
		)
	then
		repeat
			ItemService:Activate(self.Instance)
			task.wait(0.1)
		until not self.Input[Enum.UserInputType.MouseButton2]
			and not self.Input[Enum.KeyCode.ButtonR1]
	end
end

function ItemComponent:OnServerAncestry()
	self.AncestrySequence = (self.AncestrySequence or 0) + 1
	if self.Weld then self.Weld:Destroy() end
	local player = self:GetPlayer()
	if player then
		self.Instance.Handle.Anchored = false
		self.ProximityPrompt.Enabled = false
		self.PointLight.Enabled = false
		self.Weld = Instance.new("Weld")
		self.Weld.Part0 = self.Instance.Handle
		local grip = self:GetGrip()
		if grip then self.Weld.C0 = grip.CFrame end
		self.Weld.Part1 = self.Instance.Parent
		if self.Instance.Parent.Name:match("^Left") then
			self.Weld.C1 = self.Instance.Parent.LeftGripAttachment.CFrame
		elseif self.Instance.Parent.Name:match("^Right") then
			self.Weld.C1 = self.Instance.Parent.RightGripAttachment.CFrame
		end
		self.Weld.Parent = self.Instance
	elseif self.Instance:IsDescendantOf(Workspace) then
		self.PointLight.Enabled = true
		self.ProximityPrompt.Enabled = true
		self.Instance.Handle.Anchored = true
		self.Instance.Handle.CanCollide = false
		self.Instance.Handle.CanQuery = false
		self.Instance.Handle.CanTouch = false
		local current = self.AncestrySequence
		while self.AncestrySequence == current do
			self:Float()
			task.wait()
		end
	end
end

function ItemComponent:Float()
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
			and raycastResult.Instance.CanCollide
			and raycastResult.Instance.Anchored
		)
	if raycastResult then
		local _, rotY = self.Instance.Handle.CFrame:ToEulerAnglesYXZ()
		self.Instance.Handle.CFrame = CFrame.new(raycastResult.Position + Vector3.yAxis * 2)
			* CFrame.fromEulerAnglesYXZ(0, rotY, 0)
	end
	self.Instance.Handle.CFrame *= CFrame.Angles(0, 0.05, 0)
end

return ItemComponent
