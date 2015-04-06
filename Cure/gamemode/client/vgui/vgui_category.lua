--[[
		Category options

		Please do not modifiy any code below.

		Credits:
		AC² - Main code, textures
		Unknown - Ideas
--]]

local PANEL = {}

-- Initialize
function PANEL:Init()
	-- Size
	self:SetWide(200)
	self:SetTall(40)

	-- Label
	self.sName = self:Add("DLabel")
	self.sName:SetFont("mainmenu.title")
	self.sName:SetTextColor(Color(176, 176, 176, 255))

	-- Hold data
	self.Data = {}
end

-- Set the name
function PANEL:SetCategoryName(name)
	self.sName:SetText(name)
	self.sName:SizeToContents()
end

-- Get name
function PANEL:GetCategoryName()
	return (self.sName:GetText())
end

-- Get data
function PANEL:GetData()
	return self.Data
end

-- AddOption
function PANEL:AddOption(name, texture, func)
	local panel = (#self.Data + 1)

	-- Add
	self.Data[panel] = self:Add("DButton")
	self.Data[panel]:SetSize(self:GetWide(), 30)
	self.Data[panel]:SetPos(0, (panel * 30))
	self.Data[panel]:SetText("")
	self.Data[panel].Name = name
	self.Data[panel].Active = false
	self.Data[panel].OnMousePressed = function() 
		-- Ignore same menu
		if (self.Data[panel].Active) then return end

		-- Remove
		if (gDeathrunMenu) then
			gDeathrunMenu:ResetActiveButtons()
		end


		-- Hide jukebox
		if (gDeathrunJukebox:IsValid()) then
			gDeathrunJukebox:Hide()
		end

		-- Active
		self.Data[panel].Active = true
		
		-- Call func
		func() 
	end

	-- HOVER OVER
	self.Data[panel].OnCursorEntered = function(self)
		self.IsHovering = true
	end

	self.Data[panel].OnCursorExited = function(self)
		self.IsHovering = false
	end

	-- Cache
	local mat = Material(texture)

	-- Paint
	self.Data[panel].Paint = function(self)
		if (self.IsHovering) then
			draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(46, 47, 51))
		end

		if (mat) then
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.SetMaterial(mat)
			surface.DrawTexturedRect(5, 8, 16, 16)
		end

		draw.SimpleText(name, "mainmenu.title.small", 30, 15, Color(176, 176, 176, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	-- Update height
	self:SetTall(40 + (panel * 30))
end

-- Get width/height
function PANEL:GetTotalSize()
	-- Everything is stored in here
	local panel = #self.Data

	-- Simple
	return (40 + (panel * 30))
end

-- Paint
function PANEL:Paint(w, h)
	-- Calculate pos + width
	local x, y = self.sName:GetPos()
	local _w, _h = self.sName:GetSize()

	-- Draw
	surface.SetDrawColor(Color(90, 91, 95, 255))
	surface.DrawRect(0, _h + y + 5, w, 1)
end

-- Register
vgui.Register("deathrun.vgui.category", PANEL, "EditablePanel")