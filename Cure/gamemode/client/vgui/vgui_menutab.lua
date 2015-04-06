--[[
		Tabs

		Please do not modifiy any code below.

		Credits:
		AC² - Main code, textures
		Unknown - Ideas
--]]

local PANEL = {}

-- Initialize
function PANEL:Init()
	self:SetWide(100)
	self:SetTall(100)

	-- Data
	self.Data = {}

	-- Name
	self.sName = self:Add("DLabel")
	self.sName:SetPos(10, 10)
	self.sName:SetTextColor(Color(176, 176, 176, 255))
	self.sName:SetFont("mainmenu.title.fat")
end

-- Set title
function PANEL:SetTabTitle(title)
	self.sName:SetText(title)
	self.sName:SizeToContents()
end

-- Add an option
function PANEL:AddOption(name, func)
	local pnl = #self.Data + 1

	self.Data[pnl] = self:Add("DButton")
	local panel = self.Data[pnl]

	panel:SetSize(75, 30)

	if (pnl == 1) then
		local x, y = self.sName:GetPos()
		local w, h = self.sName:GetSize()

		panel:SetPos(x, y + h + 10)
	else
		local x, y = self.Data[pnl-1]:GetPos()
		panel:SetPos(x + 75 + 5, y)
	end

	-- No active
	panel.Active = false

	-- OnMousePressed
	self.Data[pnl].OnMousePressed = function()
		if (self.Data[pnl].Active) then return end
		
		-- Remove old active
		for k, v in pairs(self.Data) do
			v.Active = false
		end

		-- New active
		self.Data[pnl].Active = true

		-- run function
		func()
	 end

	-- Remove text
	panel:SetText("")

	-- Name it
	panel.name = name

	-- Paint
	panel.Paint = function(self)
		draw.SimpleText(name, "mainmenu.title.small", 5, 15, Color(176, 176, 176, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		return true
	end

	return panel
end

-- Get data
function PANEL:GetData()
	return self.Data
end

-- Paint
function PANEL:Paint(w, h)
	local btn = self.Data[1]
	local x, y = btn:GetPos()
	local _w, _h = btn:GetSize()

	surface.SetDrawColor(Color(83, 84, 87, 255))
	surface.DrawRect(x, y + _h + 5, w, 1)

	for k, v in pairs(self.Data) do
		if (v.Active) then
			surface.SetDrawColor(Color(132, 189, 0, 200))
			local x, y = v:GetPos()
			local w, h = v:GetSize()
			surface.DrawRect(x, v:GetTall() + y + 5, v:GetWide(), 1)
		end
	end
end

-- Register
vgui.Register("deathrun.vgui.tabmenu", PANEL, "EditablePanel")
