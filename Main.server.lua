local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

for _, instance in pairs(ServerStorage:GetDescendants()) do
	if not instance:IsA("ModuleScript") then continue end
	if
		instance.Name:match("Service$")
		or instance.Name:match("Component$")
		or instance.Name:match("Repository$")
	then
		local ok, msg = pcall(function() require(instance) end)
		if not ok and msg then warn(msg) end
	end
end

for _, instance in pairs(ReplicatedStorage:GetDescendants()) do
	if not instance:IsA("ModuleScript") then continue end
	if instance.Name:match("Service$") then
		local ok, msg = pcall(function() require(instance) end)
		if not ok and msg then warn(msg) end
	end
end

Knit.Start():catch(warn)
