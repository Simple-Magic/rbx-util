local RunService = game:GetService("RunService")
local Component = require(script.Parent.Parent.Component)
local Knit = require(script.Parent.Parent.Knit)
local Trove = require(script.Parent.Parent.Trove)

local CrateService

local CrateComponent = Component.new({ Tag = "Crate" })

function CrateComponent:Construct() self.Trove = Trove.new() end

function CrateComponent:Start()
	Knit.OnStart():await()
	CrateService = CrateService or Knit.GetService("CrateService")
	if RunService:IsServer() then
		self.ProximityPrompt = self.Trove:Add(Instance.new("ProximityPrompt")) :: ProximityPrompt
		self.ProximityPrompt.HoldDuration = 0.2
		self.ProximityPrompt.ObjectText = "Store"
		self.ProximityPrompt.ActionText = "Open"
		self.ProximityPrompt.Parent = self.Instance
		self.Trove:Connect(
			self.ProximityPrompt.Triggered,
			function(player) CrateService:Open(player, self.Instance) end
		)
	end
end

function CrateComponent:Stop() self.Trove:Clean() end

return CrateComponent
