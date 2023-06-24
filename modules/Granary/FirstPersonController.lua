local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Knit = require(script.Parent.Parent.Knit)
local Trove = require(script.Parent.Parent.Trove)
local Player = Players.LocalPlayer

local FirstPersonController = Knit.CreateController({ Name = "FirstPersonController" })

function FirstPersonController:KnitInit()
	self.CharacterTrove = Trove.new()
	Player.CharacterAdded:Connect(function() self:OnCharacter() end)
	Player.CharacterRemoving:Connect(function() self.CharacterTrove:Clean() end)
	if Player.Character then self:OnCharacter() end
end

function FirstPersonController:OnCharacter()
	self.CharacterTrove:Clean()
	self:CreateViewModel()
	self.CharacterTrove:BindToRenderStep(
		self.Name .. ".Character",
		Enum.RenderPriority.Character.Value,
		function() self:CharacterStep() end
	)
end

function FirstPersonController:CreateViewModel()
	local viewModel = self.CharacterTrove:Add(Instance.new("Model"))
	viewModel.Name = "ViewModel"
	for _, child in ipairs({
		Player.Character:WaitForChild("LeftHand"),
		Player.Character:WaitForChild("RightHand"),
	}) do
		local clone = child:Clone()
		clone.CanCollide = false
		clone.CanQuery = false
		clone.CanTouch = false
		clone:ClearAllChildren()
		local weld = Instance.new("Weld")
		weld.Part0 = child
		weld.Part1 = clone
		weld.Parent = clone
		clone.Parent = viewModel
	end
	viewModel.Parent = Workspace.CurrentCamera
end

function FirstPersonController:CharacterStep()
	self:UpdateNeck()
	self:UpdateArm("Left")
	self:UpdateArm("Right")
end

function FirstPersonController:UpdateNeck()
	local head = Player.Character:FindFirstChild("Head")
	if not head then return end
	local neck = head:FindFirstChild("NeckWeld") :: Weld
	if not neck then return end
	local rotX = Workspace.CurrentCamera.CFrame:ToOrientation()
	neck.C0 = CFrame.new(neck.C0.Position) * CFrame.Angles(rotX, 0, 0)
end

function FirstPersonController:UpdateArm(side: string)
	local head = Player.Character:FindFirstChild("Head") :: BasePart
	local upperTorso = Player.Character:FindFirstChild("UpperTorso") :: BasePart
	local upperArm = Player.Character:FindFirstChild(side .. "UpperArm") :: BasePart
	local lowerArm = Player.Character:FindFirstChild(side .. "LowerArm") :: BasePart
	local hand = Player.Character:FindFirstChild(side .. "Hand") :: BasePart
	if not head or not upperTorso or not upperArm or not lowerArm or not hand then return end
	local grip = head:FindFirstChild(side .. "Grip") :: Attachment
	local shoulder = upperArm:FindFirstChild(side .. "ShoulderWeld") :: Weld
	local elbow = lowerArm:FindFirstChild(side .. "ElbowWeld") :: Weld
	local wrist = hand:FindFirstChild(side .. "WristWeld") :: Weld
	if not grip or not shoulder or not elbow or not wrist then return end
	shoulder.C0 = CFrame.new(
		shoulder.C0.Position,
		(upperTorso.CFrame:Inverse() * grip.WorldCFrame).Position
	) * CFrame.Angles(math.pi / 2, 0, 0)
end

return FirstPersonController
