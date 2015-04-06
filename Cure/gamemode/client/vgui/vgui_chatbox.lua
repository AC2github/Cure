--[[
		Chatbox

		Please do not modifiy any code below.

		Credits:
		AC² - Main code
		Breakpoint - richobject code
--]]

local PANEL = {}

-- Initialize
function PANEL:Init()
	-- Get screen w/h
	local w, h = ScrW(), ScrH()

	-- Size
	self:SetWide(w * .38)
	self:SetTall(h * .35)

	-- Pos
	self:SetPos(5, (h - 170) - self:GetTall())

	-- Tab
	self.Tabs = {}

	-- Message holder
	if not (MessageHolder) then
		MessageHolder = vgui.Create("DScrollPanel", self)
		MessageHolder:SetSize(self:GetWide() - 10, self:GetTall() - 75)
		MessageHolder.OriginalHeigth = self:GetTall()
		MessageHolder.Data = {}

		-- Unparent when our frame is no longer valid
		-- Reparent when it becomes valid again
		MessageHolder.Think = function()
			if (MessageHolder:GetParent():GetName() == "EditablePanel") then
				MessageHolder:SetPos(5, 35)
			else
				-- Calculate pos
				local h = MessageHolder.OriginalHeigth
				MessageHolder:SetPos(11, ScrH() - h - 138)
			end
		end

		-- Paint
		MessageHolder.Paint = function(self, w, h)
			-- Not the best way
			if not (self:GetParent():GetName() == "EditablePanel") then return end

			-- Background
			surface.SetDrawColor(Color(42, 42, 42, 255))
			surface.DrawRect(0, 0, w, h)

			-- Border
			surface.SetDrawColor(Color(0, 0, 0, 255))
			surface.DrawOutlinedRect(0, 0, w, h)
		end
	else
		-- Reparent first
		MessageHolder:SetParent(self)
	end

	-- Scrollbars
	MessageHolder.VBar.btnGrip.Paint = function(self)
		if (MessageHolder:GetParent():GetName() == "EditablePanel") then
			draw.RoundedBox(4, 2, 0, self:GetWide() - 4, self:GetTall(), Color(51, 52, 56, 255))
		end
	end

	MessageHolder.VBar.Paint = function(self)end
	MessageHolder.VBar.btnDown.Paint = function() end
	MessageHolder.VBar.Paint = function() end
	MessageHolder.VBar.btnUp.Paint = function() end

	-- Textentry
	self.TextEntry = self:Add("DTextEntry")
	self.TextEntry:SetPos(5, self:GetTall() - 35)
	self.TextEntry:SetSize(self:GetWide() - 10, 30)
	self.TextEntry:SetMultiline(false)
	self.TextEntry.Paint = function(self, w, h)
		-- Background
		surface.SetDrawColor(Color(91, 93, 91, 255))
		surface.DrawRect(0, 0, w, h)

		-- Border
		surface.SetDrawColor(Color(0, 0, 0, 255))
		surface.DrawOutlinedRect(0, 0, w, h)

		-- Text color
		self:DrawTextEntryText(Color(176, 176, 176, 255), color_white, color_white)
	end

	self.TextEntry.OnEnter = function(self)
		-- Remove text
		MessageHolder:SetText("")

		-- Close chatbox
		self:GetParent():Close()

		-- Empty strings
		if (self:GetText() == " ") or (self:GetText() == "") then return end

		-- SPEAK 
		RunConsoleCommand("say", self:GetText())
	end

	-- Get focus
	self.TextEntry:RequestFocus()
end

function PANEL:Close()
	-- Remove parent
	MessageHolder:SetParent(vgui.GetWorldPanel())

	-- Now hide
	self:Hide()

	-- Remove mouse
	gui.EnableScreenClicker(false)
end

-- Add a button
function PANEL:AddTab(name, icon, onpress)
	-- Get count
	local pnl = (#self.Tabs + 1)

	-- Create tab
	self.Tabs[pnl] = self:Add("DButton")

	-- Size
	surface.SetFont("mainmenu.textentry")
	local w, h = surface.GetTextSize(name)


	self.Tabs[pnl]:SetSize(w + 10 + 20, 28)

	-- Calculate pos
	if (pnl == 1) then
		self.Tabs[pnl]:SetPos(0, 0)
	else
		local x, y = self.Tabs[pnl-1]:GetPos()
		local w, h = self.Tabs[pnl-1]:GetSize()
		self.Tabs[pnl]:SetPos(x + w + 1, y)
	end

	local icon = Material(icon)

	-- WE MUST PAINT LITTLE BUTTON
	self.Tabs[pnl].Paint = function(self, w, h)
		-- Background
		surface.SetDrawColor(Color(25, 25, 25, 255))
		surface.DrawRect(0, 0, w, h)

		-- Icon
		surface.SetDrawColor(color_white)
		surface.SetMaterial(icon)
		surface.DrawTexturedRect(5, (h / 2 - 8), 16, 16)

		-- Text
		draw.SimpleText(name, "mainmenu.textentry", 25, h / 2, Color(176, 176, 176, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		-- Stop drawing other stuff
		return true
	end
end

-- Paint
function PANEL:Paint(w, h)
	-- Main bg
	surface.SetDrawColor(Color(62, 62, 62, 255))
	surface.DrawRect(0, 28, w, h - 28)

	-- Border
	surface.SetDrawColor(Color(0, 0, 0, 255))
	surface.DrawOutlinedRect(0, 28, w, h - 28)
end

-- Register
vgui.Register("deathrun.vgui.chatbox", PANEL, "EditablePanel")
