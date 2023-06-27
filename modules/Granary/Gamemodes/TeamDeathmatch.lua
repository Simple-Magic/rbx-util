local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local Knit = require(script.Parent.Parent.Parent.Knit)
local Signal = require(script.Parent.Parent.Parent.Signal)
local Trove = require(script.Parent.Parent.Parent.Trove)
local SpawnerComponent = require(script.Parent.Parent.SpawnerComponent)

local AnnouncementService
local CageService
local CountdownService
local PropService

local TeamDeathmatch = {}
TeamDeathmatch.__index = TeamDeathmatch

function TeamDeathmatch.new()
	return setmetatable({
		End = Signal.new(),
		Trove = Trove.new(),
	}, TeamDeathmatch)
end

function TeamDeathmatch:Start()
	Knit.OnStart():await()
	AnnouncementService = AnnouncementService or Knit.GetService("AnnouncementService")
	CageService = CageService or Knit.GetService("CageService")
	CountdownService = CountdownService or Knit.GetService("CountdownService")
	PropService = PropService or Knit.GetService("PropService")
	self:_CreateTeams()
	self:_AssignPlayersToTeams()
	self:_SpawnPlayers()
	CountdownService:Countdown(3)
	task.wait(3)
	self:_ThawPlayers()
	self:_SpawnProps()
	self:_BindDeadToCage()
	repeat
		task.wait(1)
	until self:_GetWinner() or self.Stopped
	self:_AnnounceWinner()
	task.wait(3)
	self:Stop()
end

function TeamDeathmatch:Stop()
	self.Stopped = true
	self.End:Fire()
	self.Trove:Clean()
	for _, player in ipairs(Players:GetPlayers()) do
		player.Neutral = true
		player.TeamColor = BrickColor.Gray()
	end
end

function TeamDeathmatch:_GetWinner(): Team?
	local bluePlayers = {}
	local redPlayers = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if CageService:Contains(player) then continue end
		if player.TeamColor == BrickColor.new("Bright blue") then
			table.insert(bluePlayers, player)
		elseif player.TeamColor == BrickColor.new("Bright red") then
			table.insert(redPlayers, player)
		end
	end
	if #bluePlayers == 0 and #redPlayers > 0 then
		return Teams.Red
	elseif #redPlayers == 0 and #bluePlayers > 0 then
		return Teams.Blue
	end
end

function TeamDeathmatch:_AnnounceWinner()
	local winner = self:_GetWinner()
	if not winner then return end
	AnnouncementService:Announce(winner.Name .. " team won!")
end

function TeamDeathmatch:_SpawnProps()
	for _, spawner in ipairs(SpawnerComponent:GetAll()) do
		spawner:SpawnRandomProp()
	end
end

function TeamDeathmatch:_BindDeadToCage()
	for _, player in ipairs(Players:GetPlayers()) do
		local function onCharacter(character)
			local humanoid = character:WaitForChild("Humanoid")
			self.Trove:Connect(humanoid.Died, function()
				player:LoadCharacter()
				repeat
					task.wait()
				until player.Character
				CageService:Teleport(player)
			end)
		end
		self.Trove:Connect(player.CharacterAdded, onCharacter)
		if player.Character then onCharacter(player.Character) end
	end
end

function TeamDeathmatch:_CreateTeams()
	local teamRed = self.Trove:Construct(Instance, "Team")
	teamRed.TeamColor = BrickColor.new("Bright red")
	teamRed.Name = "Red"
	teamRed.Parent = Teams
	local teamBlue = self.Trove:Construct(Instance, "Team")
	teamBlue.TeamColor = BrickColor.new("Bright blue")
	teamBlue.Name = "Blue"
	teamBlue.Parent = Teams
end

function TeamDeathmatch:_AssignPlayersToTeams()
	local players = Players:GetPlayers()
	local index = 0
	repeat
		index += 1
		local player = table.remove(players, math.random(1, #players))
		player.Neutral = false
		player.Team = index % 2 == 1 and Teams.Blue or Teams.Red
		player.TeamColor = index % 2 == 1 and Teams.Blue.TeamColor or Teams.Red.TeamColor
	until #players == 0
end

function TeamDeathmatch:_SpawnPlayers()
	for _, player in ipairs(Players:GetPlayers()) do
		player:LoadCharacter()
		task.spawn(function()
			repeat
				task.wait()
			until player.Character
			local root = player.Character:WaitForChild("HumanoidRootPart")
			root.Anchored = true
		end)
	end
end

function TeamDeathmatch:_ThawPlayers()
	for _, player in ipairs(Players:GetPlayers()) do
		local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if root then root.Anchored = false end
	end
end

return TeamDeathmatch
