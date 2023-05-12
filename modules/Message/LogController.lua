local TextChatService = game:GetService("TextChatService")
local Knit = require(script.Parent.Parent.Knit)

local LogService

local LogController = Knit.CreateController({ Name = "LogController" })

function LogController:KnitStart()
	LogService = Knit.GetService("LogService")
	LogService.Log:Connect(function(...) self:Log(...) end)
end

function LogController:Log(msg: string)
	TextChatService.TextChannels.RBXSystem:DisplaySystemMessage(msg)
end

return LogController
