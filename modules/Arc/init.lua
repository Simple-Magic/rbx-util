local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

--[=[
	@class Arc
]=]
local Arc = {}
Arc.__index = Arc

--[=[
	@within Arc
	@prop Alpha Vector3
	Arc Start position.
]=]
--[=[
	@within Arc
	@prop Omega Vector3
	Arc End position.
]=]
--[=[
	@within Arc
	@prop MaxHeight number
	Arc height at peak.
]=]
--[=[
	@within Arc
	@prop Visible boolean
	Wether arc is visible or not.
]=]

--[=[
	Creates `Arc` instance.
]=]
function Arc.new(alpha: Vector3, omega: Vector3): Arc
	local arc = setmetatable({
		Alpha = alpha,
		Omega = omega,
		MaxHeight = 10,
		Visible = false,
	}, Arc)
	arc:_Construct()
	return arc
end

--[=[
	Destroys `Arc` instance.
]=]
function Arc:Destroy() self.Part:Destroy() end

function Arc:_Construct()
	self.Part = Instance.new("Part")
	self.Part.Anchored = true
	self.Part.CanCollide = false
	self.Part.CanQuery = false
	self.Part.CanTouch = false
	self.Part.Size = Vector3.zero
	self.Part.CFrame = CFrame.new()
	self.Part.Name = "Arc"
	self.Part.Parent = Workspace
	self.Attachments = {} :: Table<number, Attachment>
	self.Beams = {} :: Table<number, Beam>
end

--[=[
	Calculate arc attachments and beams.
]=]
function Arc:Calculate()
	local direction = self.Omega - self.Alpha
	local distance = direction.Magnitude
	local steps = math.floor(distance / 2)
	for i = 0, steps do
		local progress = i / steps
		local position = self.Alpha
			+ direction * progress
			+ Vector3.yAxis * self:_GetHeight(progress)
		self.Attachments[i] = self.Attachments[i] or Instance.new("Attachment")
		self.Attachments[i].CFrame = CFrame.new(position)
		self.Attachments[i].Name = "Attachment" .. i
		pcall(function() self.Attachments[i].Parent = self.Part end)
		if i == 0 then continue end
		self.Beams[i] = self.Beams[i] or Instance.new("Beam")
		self.Beams[i].Attachment0 = self.Attachments[i - 1]
		self.Beams[i].Attachment1 = self.Attachments[i]
		self.Beams[i].Name = "Beam" .. i
		self.Beams[i].Enabled = self.Visible
		pcall(function() self.Beams[i].Parent = self.Part end)
	end
	local attachmentCount = #self.Attachments
	for i = steps + 1, attachmentCount do
		self.Attachments[i]:Destroy()
		self.Attachments[i] = nil
	end
	local beamCount = #self.Beams
	for i = steps + 1, beamCount do
		self.Beams[i]:Destroy()
		self.Beams[i] = nil
	end
end

--[=[
	Tween part in arc.
]=]
function Arc:Tween(part: BasePart, tweenInfo: TweenInfo)
	local direction = self.Omega - self.Alpha
	local distance = direction.Magnitude
	local steps = math.floor(distance / 4)
	local stepTime = tweenInfo.Time / steps
	local stepInfo = TweenInfo.new(stepTime, Enum.EasingStyle.Linear)
	for i = 1, steps do
		local progress = i / steps
		local position = self.Alpha
			+ direction * progress
			+ Vector3.yAxis * self:_GetHeight(progress)
		TweenService:Create(part, stepInfo, { CFrame = CFrame.new(position) }):Play()
		task.wait(stepTime)
	end
end

function Arc:_GetHeight(progress: number): number
	return self.MaxHeight - self.MaxHeight * (2 * progress - 1) ^ 2
end

return Arc
