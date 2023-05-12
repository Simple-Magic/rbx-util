local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local TextChatService = game:GetService("TextChatService")
local AnnouncementComponent = require(script.Parent.AnnouncementComponent)
local Knit = require(script.Parent.Parent.Knit)
local StackQueue = require(script.Parent.Parent.StackQueue)
local compose = require(script.Parent.Parent.compose)

type AnnouncmentOptions = {
	Color: Color3?,
}

local AnnouncementService

local AnnouncementController = Knit.CreateController({
	Name = "AnnouncementController",
	ScreenGui = compose("ScreenGui", {
		Name = "Announcements",
		Parent = PlayerGui,
		ResetOnSpawn = false,
		DisplayOrder = 1,
	}),
	Queue = StackQueue.new(),
})

function AnnouncementController:KnitStart()
	AnnouncementService = Knit.GetService("AnnouncementService")
	AnnouncementService.Announced:Connect(function(...) self:Announce(...) end)
end

function AnnouncementController:Announce(message: string, options: AnnouncmentOptions?)
	options = options or {}
	local color = options.Color or Color3.new(1, 1, 1)
	self.Queue:Append(function()
		local msg =
			AnnouncementComponent.new():SetParent(self.ScreenGui):SetText(message):SetColor(color)
		local chatMessage = ('<font color="#%s">%s</font>'):format(color:ToHex(), message)
		TextChatService.TextChannels.RBXSystem:DisplaySystemMessage(chatMessage)
		msg:FadeIn()
		task.wait(2.5)
		task.spawn(function() msg:FadeOutAndDestroy() end)
	end)
end

return AnnouncementController
