local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Component = require(script.Parent.Parent.Component)
local ItemComponent = require(script.Parent.ItemComponent)
local Knit = require(script.Parent.Parent.Knit)
local Trove = require(script.Parent.Parent.Trove)

local DamageService

local MeleeComponent = Component.new({ Tag = "Melee" })

function MeleeComponent:Construct() self.Trove = Trove.new() end

function MeleeComponent:Start()
	Knit.OnStart():await()
	DamageService = DamageService or Knit.GetService("DamageService")
	if RunService:IsServer() then
		CollectionService:AddTag(self.Instance, "Item")
		self.Trove:Connect(self.Instance.AncestryChanged, function() self:OnServerAncestry() end)
		task.wait()
		self:OnServerAncestry()
	end
end

function MeleeComponent:Stop() self.Trove:Clean() end

function MeleeComponent:GetDamage(): number return self.Instance:GetAttribute("Damage") or 10 end

function MeleeComponent:Activate()
	local swing = self.Instance.Handle:FindFirstChild("Swing") :: Sound
	if swing then swing:Play() end
end

function MeleeComponent:OnServerAncestry()
	self.AncestryTrove = self.AncestryTrove or Trove.new()
	self.AncestryTrove:Clean()
	local item = self:GetComponent(ItemComponent)
	local player = item and item:GetPlayer()
	if player then
		self.Instance.Handle.CanTouch = true
		self.AncestryTrove:Connect(
			self.Instance.Handle.Touched,
			function(...) self:OnTouch(...) end
		)
	end
end

function MeleeComponent:OnTouch(part: BasePart)
	if self.Debounce then return end
	local item = self:GetComponent(ItemComponent)
	local player = item and item:GetPlayer()
	if not player then return end
	local humanoid = part.Parent:FindFirstChild("Humanoid")
	if not humanoid then return end
	self.Debounce = true
	task.delay(0.3, function() self.Debounce = false end)
	DamageService:Damage(humanoid, self:GetDamage(), player)
end

return MeleeComponent
