local Knit = require(script.Parent.Parent.Knit)
local compose = require(script.Parent.Parent.compose)

local UNIT = 32

local ClockService
local BarController

local ClockController = Knit.CreateController({
	Name = "ClockController",
	Frame = compose("Frame", {
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.5,
		Name = "Clock",
		Size = UDim2.new(0, UNIT * 2, 0, UNIT),
	}, {
		Instance.new("UICorner"),
		compose("Frame", {
			Name = "Progress",
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 16, 1, 0),
			ZIndex = 1,
		}, { Instance.new("UICorner") }),
		compose("TextLabel", {
			BackgroundTransparency = 1,
			Font = Enum.Font.Code,
			RichText = true,
			Size = UDim2.new(1, 0, 1, 0),
			Text = "",
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = 18,
			TextStrokeColor3 = Color3.new(0, 0, 0),
			TextStrokeTransparency = 0.7,
			ZIndex = 2,
		}),
	}),
	_StartMillis = nil :: number?,
	_EndMillis = nil :: number?,
})

function ClockController:KnitStart()
	BarController = Knit.GetController("BarController")
	ClockService = Knit.GetService("ClockService")
	BarController:AddRight(self.Frame, 100)
	self:_SetSeconds(0)
	ClockService.Clock:Connect(function(...) self:_Update(...) end)
	task.spawn(function() self:_Sonar() end)
end

function ClockController:_GetUptimeMillis()
	if not self._StartMillis then return 0 end
	local nowMillis = DateTime.now().UnixTimestampMillis
	if self._EndMillis and nowMillis > self._EndMillis then return 0 end
	return nowMillis - self._StartMillis
end

function ClockController:_Sonar()
	while task.wait(0.5) or true do
		self:_Update(self._StartMillis, self._EndMillis)
	end
end

function ClockController:GetProgress(): number
	if not self._StartMillis or not self._EndMillis then return 0 end
	local nowMillis = DateTime.now().UnixTimestampMillis
	return math.min(1, (nowMillis - self._StartMillis) / (self._EndMillis - self._StartMillis))
end

function ClockController:_Update(startMillis: number?, endMillis: number?)
	self._StartMillis = startMillis
	self._EndMillis = endMillis
	self:_SetSeconds(self:_GetUptimeMillis())
	self:_SyncProgress()
end

function ClockController:_SyncProgress()
	local progress = self:GetProgress()
	self.Frame.Progress.Size = UDim2.new(progress, 16 * (1 - progress), 1, 0)
	self.Frame.Progress.BackgroundTransparency = 0.9 - progress * 0.5
end

function ClockController:_SetSeconds(uptimeMillis: number)
	local uptimeSeconds = math.floor(uptimeMillis / 1e3)
	local uptimeMinutes = math.floor(uptimeSeconds / 60)
	local uptimeHours = math.floor(uptimeMinutes / 60)
	local seconds = uptimeSeconds % 60
	local minutes = uptimeMinutes % 60
	if uptimeHours > 0 then
		local fmt = "%02d:%02d:%02d"
		self.Frame.TextLabel.Text = fmt:format(uptimeHours, minutes, seconds)
		self.Frame.Size = UDim2.new(0, UNIT * 3, 0, UNIT)
		BarController:UpdateRight()
		return
	end
	self.Frame.Size = UDim2.new(0, UNIT * 2, 0, UNIT)
	BarController:UpdateRight()
	if minutes > 0 then
		local fmt = "%02d:%02d"
		self.Frame.TextLabel.Text = fmt:format(minutes, seconds)
	elseif seconds > 0 then
		local fmt = '<font transparency="0.5">%02d:</font>%02d'
		self.Frame.TextLabel.Text = fmt:format(minutes, seconds)
	else
		local fmt = '<font transparency="0.5">%02d:%02d</font>'
		self.Frame.TextLabel.Text = fmt:format(minutes, seconds)
	end
end

return ClockController
