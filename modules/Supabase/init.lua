local HttpService = game:GetService("HttpService")

--[=[
	@class Supabase
]=]
local Supabase = {}
Supabase.__index = Supabase

--[=[
	Creates `Supabase` instance.
]=]
function Supabase.new(uri: string, apiKey: string): Supabase
	return setmetatable({
		Uri = uri,
		ApiKey = apiKey,
	}, Supabase)
end

function Supabase:Rpc(procName: string, params: any): any
	local url = ("%s/rest/v1/rpc/%s"):format(self.Uri, procName)
	local body = HttpService:JSONEncode(params)
	local headers = { apiKey = self.ApiKey, ["Content-Type"] = "application/json" }
	local data
	pcall(function()
		local response = HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson, false, headers)
		data = HttpService:JSONDecode(response)
	end)
	return data
end

return Supabase
