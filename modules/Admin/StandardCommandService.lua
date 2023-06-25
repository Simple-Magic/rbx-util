local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local Knit = require(script.Parent.Parent.Knit)

local AdminService
local AnnouncementService
local CountdownService
local DialogueService
local LogService

local StandardCommandService = Knit.CreateService({ Name = "StandardCommandService" })

function StandardCommandService:KnitStart()
	AdminService = Knit.GetService("AdminService")
	AnnouncementService = Knit.GetService("AnnouncementService")
	CountdownService = Knit.GetService("CountdownService")
	DialogueService = Knit.GetService("DialogueService")
	LogService = Knit.GetService("LogService")
	AdminService:AddCommand("Announce", nil, function(...) return self:_Announce(...) end)
	AdminService:AddCommand("Countdown", nil, function(...) return self:_Countdown(...) end)
	AdminService:AddCommand("Damage", nil, function(...) return self:_Damage(...) end)
	AdminService:AddCommand("ForceField", "/ff", function(...) return self:_ForceField(...) end)
	AdminService:AddCommand("Give", nil, function(...) return self:_Give(...) end)
	AdminService:AddCommand("Heal", nil, function(...) return self:_Heal(...) end)
	AdminService:AddCommand("Help", "/?", function(...) return self:_Help(...) end)
	AdminService:AddCommand("Vote", nil, function(...) return self:_Vote(...) end)
	AdminService:AddCommand("Info", nil, function(...) return self:_Info(...) end)
	AdminService:AddCommand("Kill", nil, function(...) return self:_Kill(...) end)
	AdminService:AddCommand("Teleport", "/tp", function(...) return self:_Teleport(...) end)
	AdminService:AddCommand("Tools", nil, function(...) return self:_Tools(...) end)
	AdminService:AddCommand("UnForceField", "/unff", function(...) return self:_UnFF(...) end)
end

function StandardCommandService:_Announce(_: TextSource, source: string)
	local parameters = AdminService.commandParameters(source)
	AnnouncementService:Announce(table.concat(parameters, " "))
end

function StandardCommandService:_Countdown(_: TextSource, source: string)
	local parameters = AdminService.commandParameters(source)
	CountdownService:Countdown(tonumber(parameters[1]) or 0)
end

function StandardCommandService:_Vote(_: TextSource, source: string)
	local parameters = AdminService.commandParameters(source)
	local description = table.concat(parameters, " ")
	local players = Players:GetPlayers()
	local votes = {}
	for _, player in ipairs(players) do
		DialogueService:DialogueFor(player, {
			Title = "Vote?",
			Description = description,
			FreezePlayer = true,
			OkText = "Yes",
			CancelText = "No",
		}):ConnectOnce(function(response: boolean?) table.insert(votes, response) end)
	end
	local start = DateTime.now().UnixTimestampMillis
	repeat
		task.wait()
	until #votes >= #players or DateTime.now().UnixTimestampMillis > start + 10e3
	local yesCount = 0
	local noCount = 0
	for _, vote in ipairs(votes) do
		if vote then
			yesCount += 1
		elseif vote == false then
			noCount += 1
		end
	end
	LogService:LogAll(
		("%s\n%d voted 'yes' and %d voted 'no'."):format(description, yesCount, noCount)
	)
end

function StandardCommandService:_Teleport(origin: TextSource, source: string): string
	local player = Players:GetPlayerByUserId(origin.UserId)
	local parameters = AdminService.commandParameters(source)
	local targetName = parameters[#parameters] :: string
	table.remove(parameters, #parameters)
	local target = AdminService.playerFromName(targetName, player)
	local x, y, z
	if not target or not target.Character then
		x, y, z = table.unpack(targetName:split(","))
	end
	local players = AdminService.playersFromNames(parameters, player)
	local count = 0
	for _, plr in ipairs(players) do
		if not plr.Character then continue end
		if target and target.Character then
			plr.Character:PivotTo(target.Character:GetPivot())
		elseif x and y and z then
			plr.Character:PivotTo(CFrame.new(tonumber(x) or 0, tonumber(y) or 0, tonumber(z) or 0))
		end
		count += 1
	end
	return ("Teleported %d players."):format(count)
end

function StandardCommandService:_Give(origin: TextSource, source: string): string
	local player = Players:GetPlayerByUserId(origin.UserId)
	local parameters = AdminService.commandParameters(source)
	local tools = AdminService.tools()
	local tool = tools[parameters[1]:lower()]
	table.remove(parameters, 1)
	local players = AdminService.playersFromNames(parameters, player)
	for _, plr in ipairs(players) do
		local clone = tool:Clone()
		clone.Parent = plr.Character
	end
	return ("Gave %d %s's."):format(#players, tool.Name)
end

function StandardCommandService:_Damage(origin: TextSource, source: string): string
	local player = Players:GetPlayerByUserId(origin.UserId)
	local parameters = AdminService.commandParameters(source)
	local amount = tonumber(parameters[1]) or 0
	table.remove(parameters, 1)
	local players = AdminService.playersFromNames(parameters, player)
	local count = 0
	for _, plr in ipairs(players) do
		local humanoid = plr.Character and plr.Character:FindFirstChild("Humanoid") :: Humanoid?
		if humanoid then
			humanoid:TakeDamage(amount)
			count += 1
		end
	end
	return ("Damaged %d players (%d)."):format(count, amount)
end

function StandardCommandService:_Heal(origin: TextSource, source: string): string
	local player = Players:GetPlayerByUserId(origin.UserId)
	local players = AdminService.playersFromNames(AdminService.commandParameters(source), player)
	local count = 0
	for _, plr in ipairs(players) do
		local humanoid = plr.Character and plr.Character:FindFirstChild("Humanoid") :: Humanoid?
		if humanoid and humanoid.Health > 0 then
			humanoid.Health = humanoid.MaxHealth
			count += 1
		end
	end
	return ("Healed %d players."):format(count)
end

function StandardCommandService:_Help(): string
	local output = "<b>Commands:</b>\n"
	for _, child in ipairs(TextChatService:GetChildren()) do
		if child:IsA("TextChatCommand") then
			output ..= ("- %s, %s\n"):format(child.PrimaryAlias, child.SecondaryAlias)
		end
	end
	return output
end

function StandardCommandService:_Tools(): string
	local output = "<b>Tools:</b>\n"
	for _, tool in pairs(AdminService.tools()) do
		output ..= ("- %s\n"):format(tool.Name)
	end
	return output
end

function StandardCommandService:_Info(origin: TextSource, source: string): string
	local player = Players:GetPlayerByUserId(origin.UserId)
	local players =
		AdminService.playersFromNames(AdminService.commandParameters(source), player) :: { Player }
	local output = "\n"
	for _, plr in ipairs(players) do
		output ..= ("UserId: %s\n"):format(plr.UserId)
		output ..= ("Name: %s\n"):format(plr.Name)
		output ..= ("DisplayName: %s\n"):format(plr.DisplayName)
		output ..= ("TeamColor: %s\n"):format(plr.TeamColor.Name)
		if plr.Character then
			output ..= "Character:\n"
			local cframe = plr.Character:GetPivot() :: CFrame
			output ..= ("- Position: %d, %d, %d\n"):format(
				math.round(cframe.Position.X),
				math.round(cframe.Position.Y),
				math.round(cframe.Position.Z)
			)
			output ..= ("- ForceField: %s\n"):format(
				plr.Character:FindFirstChild("ForceField") and "Yes" or "No"
			)
			local humanoid = plr.Character:FindFirstChild("Humanoid") :: Humanoid?
			if humanoid then
				output ..= "Humanoid:\n"
				output ..= ("- Health: %d\n"):format(humanoid.Health)
				output ..= ("- MaxHealth: %d\n"):format(humanoid.MaxHealth)
			end
		end
		output ..= "\n"
	end
	return output
end

function StandardCommandService:_Kill(origin: TextSource, source: string): string
	local player = Players:GetPlayerByUserId(origin.UserId)
	local players = AdminService.playersFromNames(AdminService.commandParameters(source), player)
	local count = 0
	for _, plr in ipairs(players) do
		local humanoid = plr.Character and plr.Character:FindFirstChild("Humanoid") :: Humanoid?
		if humanoid then
			humanoid.Health = 0
			count += 1
		end
	end
	return ("Killed %d players."):format(count)
end

function StandardCommandService:_ForceField(origin: TextSource, source: string): string
	local player = Players:GetPlayerByUserId(origin.UserId)
	local players = AdminService.playersFromNames(AdminService.commandParameters(source), player)
	local count = 0
	for _, plr in ipairs(players) do
		local ff = plr.Character and plr.Character:FindFirstChild("ForceField")
		if ff then continue end
		ff = Instance.new("ForceField")
		ff.Parent = plr.Character
		count += 1
	end
	return ("Added %d force fields."):format(count)
end

function StandardCommandService:_UnFF(origin: TextSource, source: string): string
	local player = Players:GetPlayerByUserId(origin.UserId)
	local players = AdminService.playersFromNames(AdminService.commandParameters(source), player)
	local count = 0
	for _, plr in ipairs(players) do
		local ff = plr.Character and plr.Character:FindFirstChild("ForceField")
		if ff then
			ff:Destroy()
			count += 1
		end
	end
	return ("Removed %d force fields."):format(count)
end

return StandardCommandService
