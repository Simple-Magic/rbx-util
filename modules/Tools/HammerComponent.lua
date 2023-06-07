local UserInputService = game:GetService("UserInputService")
local Component = require(script.Parent.Parent.Component)
local Trove = require(script.Parent.Parent.Trove)

local HammerComponent = Component.new({ Tag = "Hammer" })

function HammerComponent:Construct()
	self.Trove = Trove.new()
	self.Selection = {} :: Table<BasePart, SelectionBox>
end

function HammerComponent:Start()
	self.Trove:Connect(self.Instance.Equipped, function(...) self:OnEquipped(...) end)
	self.Trove:Connect(self.Instance.Unequipped, function() self:OnUnequipped() end)
end

function HammerComponent:Stop() self.Trove:Clean() end

function HammerComponent:OnEquipped(mouse: Mouse)
	self.Mouse = mouse
	self.EquipTrove = self.Trove:Extend()
	self.EquipTrove:Connect(UserInputService.InputEnded, function(...) self:OnRelease(...) end)
end

function HammerComponent:OnUnequipped()
	self.Mouse = nil
	if self.EquipTrove then self.EquipTrove:Clean() end
end

function HammerComponent:OnRelease(inputObject: InputObject, processed: boolean)
	if processed then return end
	if
		inputObject.UserInputType == Enum.UserInputType.MouseButton1
		or inputObject.KeyCode == Enum.KeyCode.ButtonR2
	then
		self:Touch(self.Mouse.Target)
	end
end

function HammerComponent:Touch(part: BasePart)
	if self.Selection[part] then
		self.Selection[part]:Destroy()
		self.Selection[part] = nil
	else
		self.Selection[part] = Instance.new("SelectionBox")
		self.Selection[part].Adornee = part
		self.Selection[part].Parent = part
	end
end

return HammerComponent
