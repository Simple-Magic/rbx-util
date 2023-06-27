local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Component = require(script.Parent.Parent.Component)
local PropComponent = require(script.Parent.PropComponent)
local Knit = require(script.Parent.Parent.Knit)
local Trove = require(script.Parent.Parent.Trove)

local DamageService

local MeleeComponent = Component.new({ Tag = "Melee" })

function MeleeComponent:Construct() self.Trove = Trove.new() end

function MeleeComponent:Start()
	Knit.OnStart():await()
	DamageService = DamageService or Knit.GetService("DamageService")
	if RunService:IsServer() then
		CollectionService:AddTag(self.Instance, "Prop")
		self.Trove:Connect(self.Instance.AncestryChanged, function() self:OnServerAncestry() end)
		task.wait()
		local prop = self:GetComponent(PropComponent)
		self.Config = prop.Config
		self:OnServerAncestry()
	end
end

function MeleeComponent:Stop() self.Trove:Clean() end

function MeleeComponent:Activate()
	local swing = self.Instance.Handle:FindFirstChild("Swing") :: Sound
	if swing then swing:Play() end
end

function MeleeComponent:OnServerAncestry()
	self.AncestryTrove = self.AncestryTrove or Trove.new()
	self.AncestryTrove:Clean()
	local prop = self:GetComponent(PropComponent)
	local player = prop and prop:GetPlayer()
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
	local prop = self:GetComponent(PropComponent)
	local player = prop and prop:GetPlayer()
	if not player then return end
	local humanoid = part.Parent:FindFirstChild("Humanoid")
	if not humanoid then return end
	self.Debounce = true
	task.delay(60 / self.Config.Rate, function() self.Debounce = false end)
	DamageService:Damage(humanoid, self.Config.Damage, player)
end

return MeleeComponent
