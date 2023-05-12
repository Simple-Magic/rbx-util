local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Knit = require(script.Parent.Parent.Knit)
local DialogueTemplate = script.Parent.Dialogue

type DialogueOptions = {
	Title: string?,
	Description: string?,
	FreezePlayer: boolean?,
}

local DialogueService

local DialogueController = Knit.CreateController({ Name = "DialogueController" })

function DialogueController:KnitStart()
	DialogueService = Knit.GetService("DialogueService")
	DialogueService.Dialogue:Connect(function(...) self:CreateDialogue(...) end)
end

function DialogueController:CreateDialogue(id: number, options: DialogueOptions?)
	if self.Gui then return DialogueService:SendResponse(id, nil) end
	options = options or {}
	self.Gui = DialogueTemplate:Clone()
	self.Gui.Frame.Title.Text = options.Title or "?"
	self.Gui.Frame.Description.Text = options.Description or "..."
	if options.FreezePlayer then Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true end
	self.Gui.Frame.OkButton.MouseButton1Click:Connect(function()
		self.Gui:Destroy()
		self.Gui = nil
		DialogueService:SendResponse(id, true)
		Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
	end)
	self.Gui.Frame.CancelButton.MouseButton1Click:Connect(function()
		self.Gui:Destroy()
		self.Gui = nil
		DialogueService:SendResponse(id, false)
		Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
	end)
	self.Gui.Parent = Players.LocalPlayer.PlayerGui
	local tween = TweenService:Create(self.Gui.Frame, TweenInfo.new(0.2), {
		Position = self.Gui.Frame.Position,
	})
	self.Gui.Frame.Position = UDim2.new(0.5, 0, 0, 0)
	tween:Play()
end

return DialogueController
