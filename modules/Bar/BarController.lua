local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Knit = require(script.Parent.Parent.Knit)
local compose = require(script.Parent.Parent.compose)

local PAD_X = 16
local GAP_X = 12
local UNIT = 32

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)

local BarController = Knit.CreateController({
	Name = "BarController",
	ScreenGui = compose("ScreenGui", {
		Name = "CustomBar",
		Parent = PlayerGui,
		ResetOnSpawn = false,
	}),
	_LeftItems = {} :: { Instance },
	_RightItems = {} :: { Instance },
})

function BarController:AddLeft(instance: Instance, priority: number?)
	self:Remove(instance, true)
	if priority then instance:SetAttribute("Priority", priority) end
	table.insert(self._LeftItems, instance)
	table.sort(self._LeftItems, function(lhs, rhs)
		local lhsPriority = lhs:GetAttribute("Priority") or 0
		local rhsPriority = rhs:GetAttribute("Priority") or 0
		return lhsPriority > rhsPriority
	end)
	instance.Parent = self.ScreenGui
	self:Update()
end

function BarController:AddRight(instance: Instance, priority: number?)
	self:Remove(instance, true)
	if priority then instance:SetAttribute("Priority", priority) end
	table.insert(self._RightItems, instance)
	table.sort(self._RightItems, function(lhs, rhs)
		local lhsPriority = lhs:GetAttribute("Priority") or 0
		local rhsPriority = rhs:GetAttribute("Priority") or 0
		return lhsPriority > rhsPriority
	end)
	instance.Parent = self.ScreenGui
	self:Update()
end

function BarController:Remove(instance: Instance, silent: boolean?)
	local lhsi, rhsi
	repeat
		lhsi = table.find(self._LeftItems, instance)
		if lhsi then table.remove(self._LeftItems, lhsi):Destroy() end
		rhsi = table.find(self._RightItems, instance)
		if rhsi then table.remove(self._RightItems, rhsi):Destroy() end
	until not (lhsi or rhsi)
	if not silent then self:Update() end
end

function BarController:Update()
	self:UpdateLeft()
	self:UpdateRight()
end

function BarController:UpdateLeft()
	local cursor = self:_LeftStart()
	for _, instance in pairs(self._LeftItems) do
		instance.AnchorPoint = Vector2.new(0, 1)
		instance.Size = UDim2.new(instance.Size.X.Scale, instance.Size.X.Offset, 0, UNIT)
		instance.Position = UDim2.new(cursor, UDim.new(0, 0))
		cursor += instance.Size.X + UDim.new(0, GAP_X)
	end
end

function BarController:UpdateRight()
	local cursor = self:_RightStart()
	for _, instance in pairs(self._RightItems) do
		instance.AnchorPoint = Vector2.new(1, 1)
		instance.Size = UDim2.new(instance.Size.X.Scale, instance.Size.X.Offset, 0, UNIT)
		instance.Position = UDim2.new(cursor, UDim.new(0, 0))
		cursor -= instance.Size.X + UDim.new(0, GAP_X)
	end
end

function BarController:_LeftStart(): UDim
	local left = self:_NativeLeftOffset()
	return UDim.new(0, PAD_X + left * (UNIT + GAP_X))
end

function BarController:_RightStart(): UDim
	local right = self:_NativeRightOffset()
	return UDim.new(1, -PAD_X - right * (UNIT + GAP_X))
end

function BarController:_NativeRightOffset(): number
	local right = 0
	if
		StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack)
		or StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu)
	then
		right += 1
	end
	return right
end

function BarController:_NativeLeftOffset(): number
	local left = 1
	if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat) then
		left += 1
	end
	return left
end

return BarController
