local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Knit = require(script.Parent.Parent.Knit)
local GunComponent = require(script.Parent.GunComponent)
local MeleeComponent = require(script.Parent.MeleeComponent)
local PropComponent = require(script.Parent.PropComponent)

local FirstPersonService

local PropService = Knit.CreateService({
	Name = "PropService",
	Client = {},
	Left = {} :: Table<Player, BasePart>,
	Right = {} :: Table<Player, BasePart>,
	Props = script.Parent.Props:GetChildren(),
})

function PropService:KnitInit()
	Players.PlayerAdded:Connect(function(...) self:OnPlayer(...) end)
	for _, player in ipairs(Players:GetPlayers()) do
		self:OnPlayer(player)
	end
end

function PropService:OnPlayer(player: Player)
	player.CharacterAdded:Connect(function() self:OnCharacter(player) end)
	player.CharacterRemoving:Connect(function() self:DropAll(player) end)
	if player.Character then self:OnCharacter(player) end
end

function PropService:OnCharacter(player: Player)
	local humanoid = player.Character:WaitForChild("Humanoid")
	humanoid.Died:Connect(function() self:DropAll(player) end)
	player.Character.ChildAdded:Connect(function(child)
		if child:IsA("Tool") then
			task.wait()
			self:PickUp(player, child)
		end
	end)
end

function PropService:DropAll(player: Player)
	for _, descendant in ipairs(player.Character:GetDescendants()) do
		if descendant:IsA("Tool") then self.Client:Drop(player, descendant) end
	end
end

function PropService:KnitStart() FirstPersonService = Knit.GetService("FirstPersonService") end

function PropService:PickUp(player: Player, instance: Tool)
	if self.Right[player] then
		if self.Left[player] then self.Client:Drop(player, self.Left[player]) end
		instance.Parent = player.Character.LeftHand
		self.Left[player] = instance
	else
		instance.Parent = player.Character.RightHand
		self.Right[player] = instance
	end
	local prop = PropComponent:FromInstance(instance)
	if prop then prop:Equip() end
end

function PropService.Client:Drop(player: Player, instance: Tool)
	instance.Parent = Workspace
	instance:PivotTo(player.Character:GetPivot() * CFrame.new(0, 0, -3 - math.random() * 5))
	if self.Server.Left[player] == instance then
		self.Server.Left[player] = nil
	elseif self.Server.Right[player] == instance then
		self.Server.Right[player] = nil
	end
end

function PropService.Client:Activate(player: Player, instance: Tool)
	if not instance.Enabled then return end
	local melee = MeleeComponent:FromInstance(instance)
	local gun = GunComponent:FromInstance(instance)
	local blocked
	if self.Server.Left[player] == instance then
		blocked = FirstPersonService:Recoil(player, "Left", melee)
	elseif self.Server.Right[player] == instance then
		blocked = FirstPersonService:Recoil(player, "Right", melee)
	end
	if not blocked then
		if melee then melee:Activate() end
		if gun then gun:Activate() end
	end
end

return PropService
