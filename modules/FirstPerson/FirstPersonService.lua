local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Knit = require(script.Parent.Parent.Knit)

local FirstPersonService = Knit.CreateService({
	Name = "FirstPersonService",
	RecoilLock = {
		Left = {},
		Right = {},
	},
})

function FirstPersonService:KnitInit()
	Players.PlayerAdded:Connect(function(...) self:OnPlayer(...) end)
	for _, player in ipairs(Players:GetPlayers()) do
		self:OnPlayer(player)
	end
end

function FirstPersonService:OnPlayer(player: Player)
	player.CharacterAdded:Connect(function() self:OnCharacter(player) end)
	if player.Character then self:OnCharacter(player) end
end

function FirstPersonService:OnCharacter(player: Player)
	task.wait(1)
	local head = player.Character:WaitForChild("Head")
	local rightGrip = Instance.new("Attachment")
	rightGrip.Name = "RightGrip"
	rightGrip.CFrame = CFrame.new(1, -0.5, -5)
	rightGrip.Parent = head
	local leftGrip = Instance.new("Attachment")
	leftGrip.Name = "LeftGrip"
	leftGrip.CFrame = CFrame.new(-1, -0.5, -5)
	leftGrip.Parent = head
	for _, motor in ipairs({
		player.Character:WaitForChild("Head"):WaitForChild("Neck"),
		player.Character:WaitForChild("LeftHand"):WaitForChild("LeftWrist"),
		player.Character:WaitForChild("LeftLowerArm"):WaitForChild("LeftElbow"),
		player.Character:WaitForChild("LeftUpperArm"):WaitForChild("LeftShoulder"),
		player.Character:WaitForChild("RightHand"):WaitForChild("RightWrist"),
		player.Character:WaitForChild("RightLowerArm"):WaitForChild("RightElbow"),
		player.Character:WaitForChild("RightUpperArm"):WaitForChild("RightShoulder"),
	}) do
		local weld = Instance.new("Weld")
		weld.C0 = motor.C0
		weld.C1 = motor.C1
		weld.Name = motor.Name .. "Weld"
		weld.Part0 = motor.Part0
		weld.Part1 = motor.Part1
		weld.Parent = motor.Parent
		motor:Destroy()
	end
end

function FirstPersonService:Recoil(player: Player, side: string, double: boolean): boolean
	local head = player.Character and player.Character:FindFirstChild("Head")
	if not head then return end
	local grip = head:FindFirstChild(side .. "Grip")
	if not grip then return end
	if self.RecoilLock[side][player] then return true end
	self.RecoilLock[side][player] = true
	local origin = grip.CFrame
	task.spawn(function()
		TweenService:Create(grip, TweenInfo.new(0.02), { CFrame = origin * CFrame.new(0, 1, 0) })
			:Play()
		task.wait(0.02)
		if double then
			TweenService
				:Create(grip, TweenInfo.new(0.2), { CFrame = origin * CFrame.new(0, -3, 0) })
				:Play()
			task.wait(0.2)
			TweenService:Create(grip, TweenInfo.new(0.2), { CFrame = origin }):Play()
			task.wait(0.2)
		else
			TweenService:Create(grip, TweenInfo.new(0.05), { CFrame = origin }):Play()
			task.wait(0.05)
		end
		self.RecoilLock[side][player] = nil
	end)
end

return FirstPersonService
