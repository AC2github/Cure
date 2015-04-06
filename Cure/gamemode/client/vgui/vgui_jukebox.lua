--[[
		Jukebox

		Please do not modifiy any code below.

		Credits:
		AC² - Main code, textures
		Unknown - Ideas
--]]

local PANEL = {}

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
	self.Table = Cure.Jukebox.Songs
end

-- Clear
function PANEL:Clear()
	self.Layout:Clear()
end

-- Set table
function PANEL:SetTable(tbl)
	self.Table = tbl
end

-- Add a song
function PANEL:AddSong(name, length, link)
	local pnl = (#self.Data + 1)

	-- New
	self.Data[pnl] = vgui.Create("DButton")
	self.Data[pnl]:SetSize(self.Layout:GetWide(), 30)
	self.Data[pnl]:SetText("")

	self.Data[pnl].OnCursorEntered = function(self)
		self.Active = true
	end

	self.Data[pnl].OnCursorExited = function(self)
		self.Active = false
	end

	self.Data[pnl].DoClick = function()	
		RunConsoleCommand("jukebox_addtoqueue", link)
	end

	self.Data[pnl].DoRightClick = function()
		-- Admin only
		if not (LocalPlayer():IsAdmin()) then return end

		-- Shitty menu
	   	local options = DermaMenu() 

	   	-- Edit
    	options:AddOption("Edit", function() end)

	   	-- Remove option
    	options:AddOption("Remove", function()
    		-- Remove
    		RunConsoleCommand("jukebox_removefromlist", link)

    		-- Remove from list
    		self.Data[pnl]:Remove()

    		-- Update list
    		self.Layout:Layout()
    	end) 

    	options:Open() 
    end

	-- Convert
	length = string.ToMinutesSeconds(length)

	-- Paint
	self.Data[pnl].Paint = function(self)
		-- Background
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(18, 19, 21, 255))

		-- Hover
		if (self.Active) then
			draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(176, 176, 176, 100))
		end

		-- Name
		draw.SimpleText(name, "mainmenu.title.small", 2, 15, Color(176, 176, 176, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		-- Length
		draw.SimpleText(length, "mainmenu.title.small", self:GetWide() - 10 - 16, 15, Color(176, 176, 176, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)		

		-- White border
		surface.SetDrawColor(Color(83, 84, 87, 255))
		surface.DrawRect(0, self:GetTall() - 1, self:GetWide(), 1)
	end

	-- Add to list
	self.Layout:Add(self.Data[pnl])
end

-- Update
function PANEL:Update()
	-- Clear
	self:Clear()

	-- Sort
	table.SortByMember(self.Table, "title", function(a, b) return a > b end)

	-- Meh
	local song = {}

	-- Re-add
	for i = 1, #self.Table do
		local song = Cure.Jukebox.GetSongDataFromLink(self.Table[i].link)
		local name, length, link = song.title, song.length, song.link

		self:AddSong(name, length, link)
	end
end

-- Paint
function PANEL:Paint(w, h)
end

-- Register
vgui.Register("deathrun.vgui.jukebox", PANEL, "EditablePanel")