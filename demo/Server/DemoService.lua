local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Arc = require(ReplicatedStorage.Packages.Arc)

local AnnouncementService
local CountdownService
local DialogueService
local HitmarkerService
local LoadingService
local LogService

local DemoService = Knit.CreateService({ Name = "DemoService" })

function DemoService:KnitStart()
	AnnouncementService = Knit.GetService("AnnouncementService")
	CountdownService = Knit.GetService("CountdownService")
	DialogueService = Knit.GetService("DialogueService")
	HitmarkerService = Knit.GetService("HitmarkerService")
	LoadingService = Knit.GetService("LoadingService")
	LogService = Knit.GetService("LogService")
	Players.PlayerAdded:Connect(function(...) self:OnPlayer(...) end)
	for _, player in pairs(Players:GetPlayers()) do
		self:OnPlayer(player)
	end
end

function DemoService:OnPlayer(player: Player)
	player.CharacterAdded:Connect(function() self:OnCharacter(player) end)
	if player.Character then self:OnCharacter(player) end
end

function DemoService:OnCharacter(player: Player)
	self:AnnounceToolFor(player)
	self:CountdownToolFor(player)
	self:HitmarkerToolFor(player)
	self:LoadingToolFor(player)
	self:DialogueToolFor(player)
	self:ArcToolFor(player)
end

function DemoService:AnnounceToolFor(player)
	local tool = Instance.new("Tool")
	tool.Name = "Announce"
	tool.RequiresHandle = false
	tool.CanBeDropped = false
	tool.Parent = player.Backpack
	tool.Activated:Connect(
		function() AnnouncementService:AnnounceFor(player, "Sample Announcement") end
	)
end

function DemoService:CountdownToolFor(player)
	local tool = Instance.new("Tool")
	tool.Name = "Countdown"
	tool.RequiresHandle = false
	tool.CanBeDropped = false
	tool.Parent = player.Backpack
	tool.Activated:Connect(function() CountdownService:Countdown(3) end)
end

function DemoService:DialogueToolFor(player)
	local tool = Instance.new("Tool")
	tool.Name = "Dialogue"
	tool.RequiresHandle = false
	tool.CanBeDropped = false
	tool.Parent = player.Backpack
	tool.Activated:Connect(function()
		DialogueService:DialogueFor(player, {
			Title = "Sample Dialogue",
			Description = "Sample Dialogue",
			FreezePlayer = true,
		}):ConnectOnce(function(response: boolean?)
			if response then
				LogService:LogTo(player, "Dialogue: OK")
			elseif response == false then
				LogService:LogTo(player, "Dialogue: Cancel")
			else
				LogService:LogTo(player, "Dialogue: Blocked")
			end
		end)
	end)
end

function DemoService:HitmarkerToolFor(player)
	local tool = Instance.new("Tool")
	tool.Name = "Hitmarker"
	tool.RequiresHandle = false
	tool.CanBeDropped = false
	tool.Parent = player.Backpack
	tool.Activated:Connect(function() HitmarkerService:HitmarkerFor(player, "<b>+1</b>") end)
end

function DemoService:LoadingToolFor(player)
	local tool = Instance.new("Tool")
	tool.Name = "Loading"
	tool.RequiresHandle = false
	tool.CanBeDropped = false
	tool.Parent = player.Backpack
	tool.Equipped:Connect(function() LoadingService:SetLoadingFor(player, true) end)
	tool.Unequipped:Connect(function() LoadingService:SetLoadingFor(player, false) end)
end

function DemoService:ArcToolFor(player)
	local tool = Instance.new("Tool")
	tool.Name = "Arc"
	tool.RequiresHandle = false
	tool.CanBeDropped = false
	tool.Parent = player.Backpack
	local arc
	tool.Activated:Connect(function()
		if arc then arc:Destroy() end
		arc = Arc.new(Vector3.zero, Vector3.new(32, 0, 32))
	end)
end

return DemoService
