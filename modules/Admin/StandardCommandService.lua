local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local AdminService

local StandardCommandService = Knit.CreateService({ Name = "StandardCommandService" })

function StandardCommandService:KnitStart()
	AdminService = Knit.GetService("AdminService")
	AdminService:AddCommand("Damage", nil, function(...) return self:_Damage(...) end)
	AdminService:AddCommand("ForceField", "/ff", function(...) return self:_ForceField(...) end)
	AdminService:AddCommand("Heal", nil, function(...) return self:_Heal(...) end)
	AdminService:AddCommand("Info", nil, function(...) return self:_Info(...) end)
	AdminService:AddCommand("Kill", nil, function(...) return self:_Kill(...) end)
	AdminService:AddCommand("Teleport", "/tp", function(...) return self:_Teleport(...) end)
	AdminService:AddCommand("UnForceField", "/unff", function(...) return self:_UnFF(...) end)
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
