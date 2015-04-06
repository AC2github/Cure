--[[
		Voice panel

		Please do not modifiy any code below.

		Credits:
		AC²- Main code
		Anonymous  - Other bit of code
--]]

-- Panel
local PANEL = {}

-- Initialize
function PANEL:Init()
	-- Parent size
	local w, h = self:GetParent()

	-- Size
	self:SetSize(w, h)
end

-- Paint
function PANEL:Paint(w, h)
	surface.SetDrawColor(Color(0, 0, 0, 255))
	surface.DrawRect(0, 0, w, h)
end

-- Register
vgui.Register("deathrun.vgui.statsmenu", PANEL, "EditablePanel")