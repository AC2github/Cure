--[[
		Achievements

		Please do not modifiy any code below.

		Credits:
		AC² - Main code, textures
		Unknown - Ideas, design
--]]

local PANEL = {}

-- Font
surface.CreateFont("mainmenu.achievement.title", {font="Verdana", size = 34, weigth = 400, antialias = true})

-- Initialize
function PANEL:Init()
	-- Get parent (mainpanel) its size
	local w, h = self:GetParent():GetSize()

	-- Checks
	if (w) and (h) then
		self:SetWide(w)
		self:SetTall(h)
	end

	-- Holder
	self.Layout = self:GetParent():Add("DIconLayout")
	self.Layout:SetSpaceX(0)
	self.Layout:SetSpaceY(0)
	self.Layout:SetPos(0, 0)
	self.Layout:SetSize(w, h - 200)

	-- Data
	self.Data = {}

	-- Table
	self.Table = Cure.Achievements.Data

	-- Type
	self.Type = ACHIEVEMENTS_CATEGORY_LEVEL
end

-- Clear
function PANEL:Clear()
	-- Clear
	self.Layout:Clear()

	-- Remove panels
	for k, v in pairs(self.Data) do
		v:Remove()
	end

	-- Reset
	self.Data = {}
end

-- Set type to display (level, win achv)
function PANEL:SetType(type)
	-- Set
	self.Type = type

	-- Update
	self:Update()
end

-- Add a song
function PANEL:AddAchievement(id, name, desc, image, paintover)
	local pnl = (#self.Data + 1)

	-- New
	self.Data[pnl] = vgui.Create("DPanel")
	self.Data[pnl]:SetSize(self.Layout:GetWide(), 55)

	self.Data[pnl].OnCursorEntered = function(self)
		self.Active = true
	end

	self.Data[pnl].OnCursorExited = function(self)
		self.Active = false
	end

	-- Paint
	self.Data[pnl].Paint = function(self)
		-- Background
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(18, 19, 21, 255))

		-- Hover
		if (self.Active) then
			draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(176, 176, 176, 100))
		end

		-- Image
		surface.SetDrawColor(color_white)
		surface.SetMaterial(image)
		surface.DrawTexturedRect(2, 2, 50, 50)

		-- Text over image
		if (paintover) then
			draw.SimpleText(paintover, "mainmenu.title.small2", 25, self:GetTall() / 2, Color(176, 176, 176, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		-- Name
		if table.HasValue(LocalPlayer().PlayerData["achievements"], id) then
			draw.SimpleText(name, "mainmenu.achievement.title", 55, 0, Color(11, 199, 39, 100), TEXT_ALIGN_LEFT)
		else
			draw.SimpleText(name, "mainmenu.achievement.title", 55, 0, Color(255, 6, 0, 100), TEXT_ALIGN_LEFT)
		end

		-- Desc
		draw.SimpleText(desc, "mainmenu.title.small", 57, 32, Color(176, 176, 176, 255), TEXT_ALIGN_LEFT)

		-- Locked/Unlocked
		if table.HasValue(LocalPlayer().PlayerData["achievements"], id) then
			draw.SimpleText("Unlocked", "mainmenu.title.fat", self:GetWide() - 60, self:GetTall() / 2, Color(11, 199, 39, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)		
		else
			draw.SimpleText("Locked", "mainmenu.title.fat", self:GetWide() - 55, self:GetTall() / 2, Color(255, 6, 0, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)		
		end

		-- White border
		surface.SetDrawColor(Color(83, 84, 87, 255))
		surface.DrawRect(0, self:GetTall() - 1, self:GetWide() - 17, 1)
	end

	-- Add to list
	self.Layout:Add(self.Data[pnl])
end

-- Update
function PANEL:Update()
	-- Clear
	self:Clear()

	-- Re-add
	for k,v in pairs(Cure.Achievements.Data) do
		if (self.Type == v.category) then
			self:AddAchievement(v.id, v.name, v.desc, v.image, v.paintover)
		end
	end

	self.Layout:Layout()
	self.Layout:PerformLayout()
end

-- Paint
function PANEL:Paint(w, h)
end

-- Register
vgui.Register("deathrun.vgui.achievementpanel", PANEL, "EditablePanel")