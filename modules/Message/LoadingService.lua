local Knit = require(script.Parent.Parent.Knit)

local LoadingService = Knit.CreateService({
	Name = "LoadingService",
	Client = { Loading = Knit.CreateSignal() },
})

function LoadingService:SetLoading(loading: boolean) self.Client.Loading:FireAll(loading) end

function LoadingService:SetLoadingFor(player: Player, loading: boolean)
	self.Client.Loading:Fire(player, loading)
end

return LoadingService
