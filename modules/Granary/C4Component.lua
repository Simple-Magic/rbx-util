local RunService = game:GetService("RunService")
local Component = require(script.Parent.Parent.Component)
local Timer = require(script.Parent.Parent.Timer)
local BombSiteComponent = require(script.Parent.BombSiteComponent)

local C4Component = Component.new({ Tag = "C4" })

function C4Component:Construct()
	self.Timer = Timer.new(1)
	self.Timer.Tick:Connect(function() self:Step() end)
end

function C4Component:Start()
	if RunService:IsServer() then self.Timer:Start() end
end

function C4Component:Stop() self.Timer:Stop() end

function C4Component:Step()
	print("c4 step")
	for _, site in ipairs(BombSiteComponent:GetAll()) do
		if site:Contains(self.Instance.Handle) then
			self.Instance.Enabled = true
			return
		end
	end
	self.Instance.Enabled = false
end

return C4Component
