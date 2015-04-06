--[[
		Voice panel

		Please do not modifiy any code below.

		Credits:
		AC²- Main code
		Anonymous  - Other bit of code
--]]

-- Fonts
surface.CreateFont("voicepanel.text", {font="Verdana", size = 12, weigth = 200, antialias = true})

-- Panel
local PANEL = {}

-- Initalize
function PANEL:Init()
	--size
	self:SetSize(250, 50)
	self:Center()

	-- Player
	self.pPlayer = {}

	-- Icon
	self.sIcon = Cure.Config.pIcons.user

	-- Visualizer
	self.pVisualizer = self:Add("AudioVisualizer")
	self.pVisualizer:SetSize(self:GetWide(), self:GetTall())

	--Avatar
	self.pAvatar = self:Add("AvatarImage")
	self.pAvatar:SetSize(32,32)
	self.pAvatar:SetPos(9, 9)
	self.pAvatar:SetPlayer(LocalPlayer(), 32)
	self.pAvatar.PaintOver = function()
		surface.SetDrawColor(Color(90, 91, 95, 200))
		surface.DrawOutlinedRect(0, 0, self.pAvatar:GetWide(), self.pAvatar:GetTall())
	end

	-- Name!
	self.sName = self:Add("DLabel")
	self.sName:SetPos(46, 7)
	self.sName:SetText("Anonymous")
	self.sName:SetFont("mainmenu.title.small")
	self.sName:SizeToContents()

	-- Rank
	self.sRank = self:Add("DLabel")
	self.sRank:SetPos(46, 28)
	self.sRank:SetText("Guest")
	self.sRank:SetFont("voicepanel.text")
	self.sRank:SizeToContents()

	-- Default
	self:SetPlayer(LocalPlayer())
end

-- Set player
function PANEL:SetPlayer(player)
	if not (player:IsValid()) then return end

	-- Cache
	self.pPlayer = player

	-- Name
	self.sName:SetText(self.pPlayer:Name())
	self.sName:SizeToContents()

	-- Avatar
	self.pAvatar:SetPlayer(self.pPlayer, 32)

	-- Rank
	--self.sRank:SetText(self.pPlayer:GetRank() or "Guest")
	self.sRank:SizeToContents()

	-- Icon
	self.sIcon = (Cure.Config.pIcons[self.pPlayer:GetRank()])

	-- Visualizer
	self.pVisualizer:SetPly(self.pPlayer)
end

-- Paint that shit
function PANEL:Paint(w, h)
	-- Player backgrounds
	if (Cure.Config.pBackgrounds[self.pPlayer:SteamID()]) then
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(Cure.Config.pBackgrounds[self.pPlayer:SteamID()])
		surface.DrawTexturedRect(0, 0, w, h)
	else
		if (self.pPlayer:Team() == TEAM_DEATH) and (self.pPlayer:Alive()) then
			surface.SetDrawColor(Color(177, 25, 25, 155))
		elseif (self.pPlayer:Team() == TEAM_RUNNER) and (self.pPlayer:Alive()) then
			surface.SetDrawColor(Color(45, 162, 191, 255))
		else
			surface.SetDrawColor(Color(160, 160, 160, 255))
		end

		surface.DrawRect(0, 0, w, h)
	end

	-- Team color
	if (self.pPlayer:Team() == TEAM_DEATH) and (self.pPlayer:Alive()) then
		surface.SetMaterial(Cure.Config.pBackgrounds[3]) 
	elseif (self.pPlayer:Team() == TEAM_RUNNER) and (self.pPlayer:Alive()) then
		surface.SetMaterial(Cure.Config.pBackgrounds[2]) 
	else
		surface.SetMaterial(Cure.Config.pBackgrounds[1])
	end

	surface.SetDrawColor(color_white)
	surface.DrawTexturedRect(0, 0, w, h)

	surface.SetDrawColor(Color(24, 24, 24, 205))
	surface.DrawRect(2, 2, w - 4, h - 4)

	-- Outline
	surface.SetDrawColor(Color(90, 91, 95, 255))
	surface.DrawOutlinedRect(0, 0, w, h)

	-- Underline the text
	surface.SetDrawColor(Color(176, 176, 176, 255))
	surface.DrawRect(46, 25, w - 54, 1)

	-- Rank Icon
	surface.SetDrawColor(color_white)
	surface.SetMaterial(self.sIcon)
	surface.DrawTexturedRect(w - 22, 9, 12, 12)
end

-- Register
vgui.Register("deathrun.vgui.voicepanel", PANEL, "DPanel")