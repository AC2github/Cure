--[[
		Chatbox message

		Please do not modifiy any code below.

		Credits:
		AC² - Main code

		Amount of crashes due to infinite loops: 4
--]]

local PANEL = {}
surface.CreateFont("chatbox.font", {font = "Open Sans", size = 19, weight = 400, shadow = true, blursize = .3, antialias = true})

-- Material
local gradient = surface.GetTextureID("gui/gradient.vmt")

-- Initialize
function PANEL:Init()
	-- Get size
	local w, h = self:GetParent():GetSize()

	-- Set size
	self:SetWide(w)
	self:SetTall(35)

	-- Data
	self.sText = ""
	self.pPlayer = LocalPlayer()
	self.Alpha = 255
	self.DieTime = CurTime() + 4

	-- Player
	self.pPlayer = {}
	self.pName = "Console"
	self.pRank = Cure.Config.pIcons.user
	self.pColor = color_white
	self.sText = "EMPTY STRING"
end

function PANEL:PerformLayout()
	self:SetWide(self:GetParent():GetWide())

	local _w, _h = -10, 0

	if (self.pName) then
		surface.SetFont("chatbox.font")
		_w, _h = surface.GetTextSize(self.pName)
	end

	local text = ParseMessage(self.sText, self:GetWide() - _w - 24 - 10 - 16)
	self:SetTall(text.totalHeight + 15)
end

function PANEL:SetText(text)
	self.sText = text
end

function PANEL:SetIcon(icon)
	self.pRank = icon
end

function PANEL:SetPlayer(player)
	-- Not valid
	if not (player) or not (player:IsValid()) then
		self.pPlayer = nil
		self.pName = nil
		self.pRank = Cure.Config.pIcons.world
		self.pColor = Color(255, 255, 255, 255)
		return
	end

	-- Cache
	self.pPlayer = player

	-- Name
	self.pName = player:Name()

	-- Rank
	self.pRank = (Cure.Config.pIcons[player:GetRank()] or Material("icon16/user.png"))

	-- Team color
	self.pColor = team.GetColor(self.pPlayer:Team())
end

function PANEL:GetText()
	return sText
end

-- Paint
function PANEL:Paint(w, h)
	-- Remove
	if (self.DieTime < CurTime()) then
		-- Go down
		self.Alpha = math.Approach(self.Alpha, 0, .35)

		-- Don't draw
		if (self.Alpha <= 0) then
			self.Alpha = 0
		end
	end

	-- Background
	if (Chatbox:IsVisible()) then
		surface.SetDrawColor(Color(24, 24, 24, 255))
		surface.DrawRect(0, 0, w, h)

		if (self.pPlayer) and (self.pPlayer:IsValid()) then
			if (Cure.Config.pBackgrounds[self.pPlayer:SteamID()]) then
				surface.SetDrawColor(Color(255, 255, 255, 50))
				surface.SetMaterial(Cure.Config.pBackgrounds[self.pPlayer:SteamID()])
				surface.DrawTexturedRect(0, 0, w, h)
			end
		end
	end

	surface.SetDrawColor(Color(0, 0, 0, self.Alpha))
	surface.SetTexture(gradient)
	surface.DrawTexturedRect(0, 0, w, h)

	-- Rank
	surface.SetDrawColor(Color(255, 255, 255, self.Alpha))
	surface.SetMaterial(self.pRank or Cure.Config.pIcons.user)
	surface.DrawTexturedRect(6, 10, 16, 16)

	local _w, _h = -10, 0

	-- Name
	if (self.pName) then
		draw.SimpleText(self.pName, "chatbox.font", 30, 8, Color(self.pColor.r, self.pColor.g, 	self.pColor.b, self.Alpha), TEXT_ALIGN_LEFT)

		-- Get size
		surface.SetFont("chatbox.font")
		_w, _h = surface.GetTextSize(self.pName)

		-- :
		draw.SimpleText(":", "chatbox.font", _w + 24 + 10, 8, Color(255, 255, 255, self.Alpha), TEXT_ALIGN_LEFT)
	end

	-- Message
	local text = ParseMessage(self.sText, w - _w - 24 - 10 - 16)
	text:Draw(_w + 24 + 18, 8, TEXT_ALIGN_LEFT, nil, self.Alpha)
end

-- Register
vgui.Register("deathrun.vgui.chatmessage", PANEL, "EditablePanel")
