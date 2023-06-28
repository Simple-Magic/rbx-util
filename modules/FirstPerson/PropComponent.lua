local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Component = require(script.Parent.Parent.Component)
local Knit = require(script.Parent.Parent.Knit)
local Trove = require(script.Parent.Parent.Trove)
local PropConfig = require(script.Parent.PropConfig)

local PropService

local PropComponent = Component.new({ Tag = "Prop" })

function PropComponent:Construct()
	self.Trove = Trove.new()
	self.Config = PropConfig[self.Instance.Name] or {}
end

function PropComponent:Start()
	Knit.OnStart():await()
	PropService = PropService or Knit.GetService("PropService")
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
			function(player) PropService:PickUp(player, self.Instance) end
		)
		task.wait()
		self:OnServerAncestry()
	elseif RunService:IsClient() then
		self.Trove:Connect(self.Instance.AncestryChanged, function() self:OnClientAncestry() end)
		task.wait()
		self:OnClientAncestry()
	end
end

function PropComponent:Stop() self.Trove:Clean() end

function PropComponent:Equip()
	local sound = self.Instance.Handle:FindFirstChild("Equip")
	if sound then sound:Play() end
end

function PropComponent:GetPlayer(): Player?
	for _, child in ipairs(Players:GetChildren()) do
		local character = child:IsA("Player") and child.Character or child:GetAttribute("Character")
		if character == self.Instance.Parent or character == self.Instance.Parent.Parent then
			return child
		end
	end
end

function PropComponent:GetSide(): string?
	if self.Instance.Parent.Name:match("^Left") then
		return "Left"
	elseif self.Instance.Parent.Name:match("^Right") then
		return "Right"
	end
end

function PropComponent:GetGrip(): Attachment?
	local side = self:GetSide()
	local grip = self.Instance.Handle:FindFirstChild(side .. "Grip")
	if not grip then grip = self.Instance.Handle:FindFirstChild("Grip") end
	return grip
end

function PropComponent:OnClientAncestry()
	self.AncestryTrove = self.AncestryTrove or Trove.new()
	self.AncestryTrove:Clean()
	self.AncestrySequence = (self.AncestrySequence or 0) + 1
	local player = self:GetPlayer()
	if player == Players.LocalPlayer then
		self.AncestryTrove:Connect(
			UserInputService.InputBegan,
			function(...) self:OnUserInputBegan(...) end
		)
	end
end

function PropComponent:OnUserInputBegan(inputObject: InputObject, processed: boolean)
	if processed then return end
	local sleep = 60 / (self.Config.Rate or 300)
	if inputObject.KeyCode == Enum.KeyCode.G or inputObject.KeyCode == Enum.KeyCode.ButtonB then
		PropService:Drop(self.Instance)
	elseif
		self.Instance.Parent.Name:match("^Right")
		and (inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.KeyCode == Enum.KeyCode.ButtonR2)
		and not self.Debounce
	then
		self.Debounce = true
		repeat
			PropService:Activate(self.Instance)
			task.wait(sleep)
		until not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
				and not UserInputService:IsKeyDown(Enum.KeyCode.ButtonR2)
			or not self.Config.Automatic
		self.Debounce = false
	elseif
		self.Instance.Parent.Name:match("^Left")
		and (inputObject.UserInputType == Enum.UserInputType.MouseButton2 or inputObject.KeyCode == Enum.KeyCode.ButtonL2)
		and not self.Debounce
	then
		self.Debounce = true
		repeat
			PropService:Activate(self.Instance)
			task.wait(sleep)
		until not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
				and not UserInputService:IsKeyDown(Enum.KeyCode.ButtonL2)
			or not self.Config.Automatic
		self.Debounce = false
	end
end

function PropComponent:OnServerAncestry()
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

function PropComponent:Float()
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

return PropComponent
