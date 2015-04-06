-- Draw keys on the screen

-- Object
Cure.Keys = {}

-- Stuff
local keys = {}
local draw_keys = false
local keyup = Material("keyboard/key_up.png", "smooth alphatest")
local keyleft = Material("keyboard/key_left.png", "smooth alphatest")
local keyjump = Material("keyboard/key_jump.png", "smooth alphatest")

-- Networking
net.Receive( "_KeyPress", function()
	local ply = net.ReadEntity()
	if not IsValid(ply) then print( "Invalid keypress player." ) return end
	local num = net.ReadInt(16)

	if not keys[ply] then
		keys[ply] = {}
	end

	keys[ply][num] = true
end )

net.Receive( "_KeyRelease", function()
	local ply = net.ReadEntity()
	if not IsValid(ply) then print( "Invalid keyrelease player." ) return end
	local num = net.ReadInt(16)

	if not keys[ply] then
		keys[ply] = {}
	end

	keys[ply][num] = false
end )

-- Called in HUDPaint
function Cure.Keys.Draw()
	local ply = LocalPlayer()
	local ob = ply:GetObserverTarget()
	
	if ob and IsValid(ob) and ob:IsPlayer() and ob:Alive() then
		ply = ob
		draw_keys = true
	else
		draw_keys = false
	end

	if not keys[ply] then
		keys[ply] = {}
	end

	if draw_keys then
		local w, h = 50, 50
		local x, y = ScrW() - 135, ScrH() - 130

		local Keys = keys[ply] or {}

		-- top
		if Keys[IN_FORWARD] then
			draw.RoundedBox(4, x - 1, y - 1, w + 2, h + 2, Color(10, 10, 10, 230))
			draw.RoundedBox(4, x, y, w, h, Color(100, 10, 10, 255))
			draw.RoundedBox(4, x, y, w, h / 2, Color(200, 10, 10, 255))
		else
			draw.RoundedBox(4, x, y, w, h, Color(10, 10, 10, 230))
		end
		
		draw.SimpleText("w", "vgui:button", x + (w/2), y + (h/2), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		-- left
		if Keys[IN_MOVELEFT] then
			surface.SetDrawColor(Color(200, 10, 10, 255))
			draw.RoundedBox(4, x - 61, y + 59, w + 2, h + 2, Color(10, 10, 10, 230))
			draw.RoundedBox(4, x - 60, y + 60, w, h, Color(100, 10, 10, 255))
			draw.RoundedBox(4, x - 60, y + 60, w, h / 2, Color(200, 10, 10, 255))
		else
			draw.RoundedBox(4, x - 60, y + 60, w, h, Color(10, 10, 10, 230))
		end

		draw.SimpleText("a", "vgui:button", x - 60 + (w/2), y + 60 + (h/2), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		-- right
		if Keys[IN_MOVERIGHT] then
			draw.RoundedBox(4, x + 59, y + 59, w + 2, h + 2, Color(10, 10, 10, 230))
			draw.RoundedBox(4, x + 60, y + 60, w, h, Color(100, 10, 10, 255))
			draw.RoundedBox(4, x + 60, y + 60, w, h / 2, Color(200, 10, 10, 255))
		else
			draw.RoundedBox(4, x + 60, y + 60, w, h, Color(10, 10, 10, 230))
		end

		draw.SimpleText("d", "vgui:button", x + 60 + (w/2), y + 60 + (h/2), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		-- and down we go
		if Keys[IN_BACK] then
			surface.SetDrawColor(Color(200, 10, 10, 255))
			draw.RoundedBox(4, x - 1, y + 59, w + 2, h + 2, Color(10, 10, 10, 230))
			draw.RoundedBox(4, x, y + 60, w, h, Color(100, 10, 10, 255))
			draw.RoundedBox(4, x, y + 60, w, h / 2, Color(200, 10, 10, 255))
		else
			draw.RoundedBox(4, x, y + 60, w, h, Color(10, 10, 10, 230))
		end

		draw.SimpleText("s", "vgui:button", x + (w/2), y + 60 + (h/2), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		-- Jump
		if Keys[IN_JUMP] then
			draw.RoundedBox(4, x - 376, y + 59, 300, h, Color(10, 10, 10, 230))
			draw.RoundedBox(4, x - 375, y + 60, 298, h, Color(100, 10, 10, 255))
			draw.RoundedBox(4, x - 375, y + 60, 298, h / 2 - 2, Color(200, 10, 10, 255))
		else
			surface.SetDrawColor(Color(255, 255, 255, 255))
			draw.RoundedBox(4, x - 375, y + 60, 300, h, Color(10, 10, 10, 230))
		end

		draw.SimpleText("jump", "vgui:button", (x - 255) + (w/2), y + 60 + (h/2), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end