local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Knit = require(script.Parent.Parent.Knit)
local Player = Players.LocalPlayer

local LoadingService

local LoadingController = Knit.CreateController({ Name = "LoadingController" })

function LoadingController:KnitInit()
	self.Gui = script.Parent.Loading:Clone()
	self.Gui.Enabled = false
	self.Gui.Parent = Player.PlayerGui
	self.Blur = Instance.new("BlurEffect")
	self.Rotation = 0
	self.DotRadius = 20
end

function LoadingController:KnitStart()
	LoadingService = Knit.GetService("LoadingService")
	LoadingService.Loading:Connect(function(...) self:SetLoading(...) end)
end

function LoadingController:SetLoading(loading: boolean)
	self.Gui.Enabled = loading
	self.Blur.Parent = loading and Lighting or nil
	while self.Gui.Enabled do
		self.Rotation += 360
		self.DotRadius = self.DotRadius == 20 and 10 or 20
		TweenService:Create(self.Gui.Frame.Anchor, TweenInfo.new(1), {
			Rotation = self.Rotation,
		}):Play()
		TweenService:Create(self.Gui.Frame.Anchor.Frame.UIStroke, TweenInfo.new(1), {
			Thickness = self.DotRadius,
		}):Play()
		task.wait(1)
	end
end

return LoadingController
