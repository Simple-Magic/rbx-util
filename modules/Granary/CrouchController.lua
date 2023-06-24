local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Knit = require(script.Parent.Parent.Knit)
local Trove = require(script.Parent.Parent.Trove)
local Player = Players.LocalPlayer

local CrouchController = Knit.CreateController({ Name = "CrouchController" })

function CrouchController:KnitInit()
	Player.CharacterAdded:Connect(function() self:OnCharacter() end)
	if Player.Character then self:OnCharacter() end
end

function CrouchController:OnCharacter()
	self.CharacterTrove = self.CharacterTrove or Trove.new()
	self.CharacterTrove:Clean()
	self.Humanoid = Player.Character:WaitForChild("Humanoid") :: Humanoid
	self.HumanoidRootPart = Player.Character:WaitForChild("HumanoidRootPart")
	local animator = self.Humanoid:WaitForChild("Animator") :: Animator
	local crouchIdle = Instance.new("Animation")
	crouchIdle.AnimationId = "rbxassetid://13847852714"
	self.CrouchIdleTrack = animator:LoadAnimation(crouchIdle)
	self.CharacterTrove:Connect(
		UserInputService.InputBegan,
		function(...) self:OnUserInputBegan(...) end
	)
	self.CharacterTrove:Connect(self.Humanoid.Changed, function()
		if self.Humanoid.Jump then
			self.Crouch = false
			self:Update()
		end
	end)
end

function CrouchController:OnUserInputBegan(inputObject: InputObject, processed: boolean)
	if processed then return end
	if
		inputObject.KeyCode == Enum.KeyCode.LeftControl
		or inputObject.KeyCode == Enum.KeyCode.ButtonY
	then
		self.Crouch = not self.Crouch
		self:Update()
	end
end

function CrouchController:Update()
	if self.Crouch then
		self.CrouchIdleTrack:Play(0, 10)
		self.HumanoidRootPart.CanCollide = false
		self.Humanoid.CameraOffset = Vector3.new(0, -2.5, 0)
		self.Humanoid.WalkSpeed = 8
	else
		self.CrouchIdleTrack:Stop()
		self.HumanoidRootPart.CanCollide = true
		self.Humanoid.CameraOffset = Vector3.zero
		self.Humanoid.WalkSpeed = 16
	end
end

return CrouchController
