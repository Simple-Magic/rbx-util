local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Knit = require(script.Parent.Parent.Knit)
local Trove = require(script.Parent.Parent.Trove)

local IsoCameraController = Knit.CreateController({
	Name = "IsoCameraController",
	Distance = 0.3,
	Angle = 0,
	FixedAngle = false,
	GamepadPosition = Vector2.zero,
	Trove = Trove.new(),
})

function IsoCameraController:KnitStart() self:Enable() end

function IsoCameraController:Disable() self.Trove:Clean() end

function IsoCameraController:Enable()
	self.Trove:BindToRenderStep(
		self.Name,
		Enum.RenderPriority.Camera.Value + 1,
		function() self:RenderStepped() end
	)
	self.Trove:Connect(UserInputService.InputChanged, function(...) self:OnInput(...) end)
	self.Trove:Connect(UserInputService.InputBegan, function(...) self:OnInput(...) end)
	self.Trove:Connect(UserInputService.InputEnded, function(...) self:OnInput(...) end)
	self.Trove:Connect(
		UserInputService.TouchStarted,
		function() self.SavedDistance = self.Distance end
	)
	self.Trove:Connect(
		UserInputService.TouchPinch,
		function(_, scale) self.Distance = math.clamp(self.SavedDistance / scale, 0, 1) end
	)
end

function IsoCameraController:OnInput(input: InputObject, processed: boolean)
	if not processed and input.UserInputType == Enum.UserInputType.MouseWheel then
		self.Distance = math.clamp(self.Distance - input.Position.Z / 10, 0, 1)
	elseif not processed and input.UserInputType == Enum.UserInputType.Touch then
		self.TouchDown = input.UserInputState ~= Enum.UserInputState.End
		if self.TouchDown and not self.FixedAngle then
			self.Angle -= input.Delta.X * 0.02
		end
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		self.MouseButton2Down = input.UserInputState == Enum.UserInputState.Begin
	elseif input.UserInputType == Enum.UserInputType.MouseMovement and self.MouseButton2Down then
		if not self.FixedAngle then
			self.Angle -= input.Delta.X * 0.02
		end
	elseif
		not processed
		and table.find({
			Enum.UserInputType.Gamepad1,
			Enum.UserInputType.Gamepad2,
			Enum.UserInputType.Gamepad3,
			Enum.UserInputType.Gamepad4,
			Enum.UserInputType.Gamepad5,
			Enum.UserInputType.Gamepad6,
			Enum.UserInputType.Gamepad7,
			Enum.UserInputType.Gamepad8,
		}, input.UserInputType)
	then
		self.GamepadPosition = input.Position
	end
end

function IsoCameraController:RenderStepped()
	if not self.FixedAngle then
		self.Angle -= self.GamepadPosition.X * 0.02
	end
	local character = Players.LocalPlayer.Character
	if not character then return end
	local pos = character:GetPivot().Position
	Workspace.CurrentCamera.CFrame = CFrame.new(
		(CFrame.new(pos) * CFrame.Angles(0, self.Angle, 0) * CFrame.new(
			Vector3.new(1, 1.4, 1) * (200 + 800 * self.Distance)
		)).Position,
		pos
	)
	workspace.CurrentCamera.FieldOfView = 5
end

return IsoCameraController
