local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Knit = require(script.Parent.Parent.Knit)
local Supabase = require(script.Parent.Parent.Supabase)

local AnalyticsService = Knit.CreateService({
	Name = "AnalyticsService",
	SessionIds = {} :: Table<Player, string>,
})

function AnalyticsService:Setup(uri: string, apiKey: string)
	self.Supabase = Supabase.new(uri, apiKey)
	self.ServerId = game.JobId or game.PrivateServerId
	self.Supabase:Rpc("create_log", {
		place_id = game.PlaceId,
		event = "SERVER_OPEN",
		server_id = self.ServerId,
	})
	game:BindToClose(function()
		self.Supabase:Rpc("create_log", {
			place_id = game.PlaceId,
			event = "SERVER_CLOSE",
			server_id = self.ServerId,
		})
	end)
	Players.PlayerAdded:Connect(function(...)
		self:OnPlayer(...)
	end)
	Players.PlayerRemoving:Connect(function(...)
		self:OnPlayerRemoving(...)
	end)
	for _, player in ipairs(Players:GetPlayers()) do
		self:OnPlayer(player)
	end
end

function AnalyticsService:OnPlayer(player: Player)
	self.SessionIds[player] = HttpService:GenerateGUID(false)
	self.Supabase:Rpc("create_log", {
		event = "PLAYER_JOIN",
		place_id = game.PlaceId,
		player_display_name = player.DisplayName,
		player_name = player.Name,
		server_id = self.ServerId,
		session_id = self.SessionIds[player],
		player_id = player.UserId,
	})
end

function AnalyticsService:OnPlayerRemoving(player: Player)
	self.Supabase:Rpc("create_log", {
		event = "PLAYER_LEAVE",
		place_id = game.PlaceId,
		player_display_name = player.DisplayName,
		player_name = player.Name,
		server_id = self.ServerId,
		session_id = self.SessionIds[player],
		player_id = player.UserId,
	})
	self.SessionIds[player] = nil
end

return AnalyticsService
