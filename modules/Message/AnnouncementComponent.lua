local TweenService = game:GetService("TweenService")
local compose = require(script.Parent.Parent.compose)
local Maid = require(script.Parent.Parent.Maid)

local FONT = Enum.Font.SourceSansBold
local AnnouncmentTemplate = compose("Frame", {
	BackgroundTransparency = 1,
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0.1, 36),
	Size = UDim2.new(0.8, 0, 0.15, 0),
}, {
	compose("TextLabel", {
		BackgroundTransparency = 1,
		Font = FONT,
		Name = "Low",
		Position = UDim2.new(0, 1, 0, 1),
		Size = UDim2.new(1, 0, 1, 0),
		TextColor3 = Color3.new(0, 0, 0),
		TextScaled = true,
		TextTransparency = 1,
		ZIndex = 1,
	}),
	compose("TextLabel", {
		BackgroundTransparency = 1,
		Font = FONT,
		Name = "High",
		Position = UDim2.new(0, -1, 0, -1),
		Size = UDim2.new(1, 0, 1, 0),
		TextColor3 = Color3.new(1, 1, 1),
		TextScaled = true,
		TextTransparency = 1,
		ZIndex = 2,
	}),
})

local GOAL_TEXT_IN = { TextTransparency = 0 }
local GOAL_TEXT_OUT = { TextTransparency = 1 }
local GOAL_FRAME_IN = { Position = UDim2.new(0.5, 0, 0.1, 0), Size = UDim2.new(0.8, 0, 0.15, 0) }
local GOAL_FRAME_OUT =
	{ Position = UDim2.new(0.5, 0, 0.1, -36), Size = UDim2.new(0.25, 0, 0.075, 0) }

local AnnouncmentComponent = {}
AnnouncmentComponent.__index = AnnouncmentComponent

function AnnouncmentComponent.new(): AnnouncmentComponent
	local component = setmetatable({
		Maid = Maid.new(),
		TweenInfo = TweenInfo.new(0.2),
		Frame = AnnouncmentTemplate:Clone(),
	}, AnnouncmentComponent)
	component:SetText("")
	return component
end

function AnnouncmentComponent:SetParent(parent)
	self.Frame.Parent = parent
	return self
end

function AnnouncmentComponent:SetText(text: string)
	self.Frame.High.Text = text
	self.Frame.Low.Text = text
	return self
end

function AnnouncmentComponent:SetColor(color: Color3)
	self.Frame.High.TextColor3 = color
	return self
end

function AnnouncmentComponent:FadeIn()
	self.Maid:Destroy()
	for _, tween in
		pairs(self.Maid:Append({
			TweenService:Create(self.Frame, self.TweenInfo, GOAL_FRAME_IN),
			TweenService:Create(self.Frame.High, self.TweenInfo, GOAL_TEXT_IN),
			TweenService:Create(self.Frame.Low, self.TweenInfo, GOAL_TEXT_IN),
		}))
	do
		tween:Play()
	end
end

function AnnouncmentComponent:FadeOut()
	self.Maid:Destroy()
	for _, tween in
		pairs(self.Maid:Append({
			TweenService:Create(self.Frame, self.TweenInfo, GOAL_FRAME_OUT),
			TweenService:Create(self.Frame.High, self.TweenInfo, GOAL_TEXT_OUT),
			TweenService:Create(self.Frame.Low, self.TweenInfo, GOAL_TEXT_OUT),
		}))
	do
		tween:Play()
	end
end

function AnnouncmentComponent:FadeOutAndDestroy()
	self:FadeOut()
	task.wait(self.TweenInfo.Time)
	self.Frame:Destroy()
end

return AnnouncmentComponent
