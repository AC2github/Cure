
// TODO
// Clean up code

-- Object
Cure.HUD = {}

-- Important vars
local w, h = ScrW(), ScrH()

-- Blood
local bloodeffect = {}
bloodeffect[1] = Material("spiceworks/hud/bloodeffects/blood1.png", "smooth")
bloodeffect[2] = Material("spiceworks/hud/bloodeffects/blood2.png", "smooth")
bloodeffect[3] = Material("spiceworks/hud/bloodeffects/blood3.png", "smooth")
bloodeffect[4] = Material("spiceworks/hud/bloodeffects/blood4.png", "smooth")

-- Keep track here
local bloodtable = {}

-- Vars
local time = 0
local alpha = 255
local textureid = 1
local heartbeat = 2

-- Keep track of vertex shitz
local vertex = {}
local outlines = {}

-- Vertex points
function Cure.HUD.AddVertexPoint(id, x, y, u, v)
	-- What are you doing?
	if not (id) then return end

	-- Doesn't exists
	if not (vertex[id]) then
		vertex[id] = {}
	end

	-- Get count
	local i = (#vertex[id] + 1)

	-- Add
	vertex[id][i] = {x = x, y = y, u = u or 1, v = v or 1}
end

-- Get points
function Cure.HUD.GetVertexPoints(id)
	if (id) then
		if (vertex[id]) then
			return vertex[id]
		end
	end

	return vertex or {}
end

-- Get a point
function Cure.HUD.GetVertexPoint(id, point)
	if (vertex[id]) and (vertex[id][point]) then
		return vertex[id][point]
	end
end

-- Modify a vertex point
function Cure.HUD.SetVertexPoint(id, point, x, y)
	if (vertex[id]) and (vertex[id][point]) then
		vertex[id][point].x = x
		vertex[id][point].y = y
	end
end

-- Draw points
function Cure.HUD.DrawVertexPoints(id, col)
	draw.NoTexture()
	surface.SetDrawColor(col)
	surface.DrawPoly(vertex[id])
end

-- Add an effect here
function Cure.HUD.AddBloodEffect(um)
	-- Get data
	local time, speed = um:ReadShort(), um:ReadFloat()

	-- Add it
	table.insert(bloodtable, {time = (time or 2) + CurTime(), alpha = 255, speedtime = speed or 2, textureid = math.random(1, #bloodeffect)})
end
usermessage.Hook("cure_bloodeffect", Cure.HUD.AddBloodEffect)

-- Draw blood
function Cure.HUD.DrawBlood()
	-- Get shit
	for k, blood in pairs(bloodtable) do
		if (blood.time <= CurTime()) then
			blood.alpha = blood.alpha - blood.speedtime
		end

		surface.SetDrawColor(Color(255, 255, 255, blood.alpha))
		surface.SetMaterial(bloodeffect[blood.textureid])
		surface.DrawTexturedRect(0, 0, w, h)

		if (blood.alpha <= 1) then
			table.remove(bloodtable, k)
		end
	end
end

-- table
local notfications = {}

-- Networking
function Cure.HUD.AddNotifcation(um)
	-- Get data
	local title, text, time, speed = um:ReadString(), um:ReadString(), um:ReadShort(), um:ReadFloat()

	-- Add it
	table.insert(notfications, {time = time + CurTime(), alpha = 255, speedtime = speed, title = title, text = text, y = 0})
end
usermessage.Hook("cure_texteffect", Cure.HUD.AddNotifcation)

-- Draw Special rounds
function Cure.HUD.DrawNotify()
	local text = notfications[1]

	if (text) then
		if (text.time <= CurTime()) then
			text.alpha = text.alpha - text.speedtime
		end

		if (text.y <= 10) then
			text.y = text.y + .2
		end

		draw.SimpleText(text.title, "hud.notify", w / 2, h - 200 + text.y, Color(255, 255, 255, text.alpha), TEXT_ALIGN_CENTER)

		surface.SetFont("hud.notify")
		local width, height = surface.GetTextSize(text.title)

		draw.SimpleText(text.text, "hud:text", w / 2, (h - 200) + (height - 15) + text.y, Color(255, 255, 255, text.alpha), TEXT_ALIGN_CENTER)

		if (text.alpha <= -5) then
			table.remove(notfications, 1)
		end
	end
end

-- Player names
function Cure:PostPlayerDraw(ply)
	if not (ply:Alive()) then return end
 
	local offset = Vector( 0, 0, 85 )
	local ang = LocalPlayer():EyeAngles()
	local pos = ply:GetPos() + offset + ang:Up()
 
 	-- Don't draw it after 512 units
 	if (LocalPlayer():GetPos():Distance(ply:GetPos()) > 512) then return end

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 90)
 

	cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.25 )
		draw.DrawText(ply:GetName(), "hud:text", 2, 2, (team.GetColor(ply:Team()) or color_white), TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

-- rounds
local roundhelp = {}
roundhelp[ROUND_WAITING] = "Waiting for players" 
roundhelp[ROUND_PREPARE] = "Preparing"
roundhelp[ROUND_ENDING] = "Round over"

-- Fonts
surface.CreateFont( "deathrun_health", {font = "coolvetica", size = 35, weight = 200, shadow = true, antialias = true})

-- HUD
local heart = Material("spiceworks/hud/heart.png")

local w, h = 476, 42.24
local x, y = 0, ScrH() - 65
local realy = ScrH() - 65

-- HUD OUTLINE (BLACK)
Cure.HUD.AddVertexPoint(1, x, y)
Cure.HUD.AddVertexPoint(1, x + w, y)
Cure.HUD.AddVertexPoint(1, x + w - h, y + h)
Cure.HUD.AddVertexPoint(1, x + w - ((h * 4) + 15), y + h)
Cure.HUD.AddVertexPoint(1, x + w - ((h * 4) + 30), y + h + 15)
Cure.HUD.AddVertexPoint(1, x, y + (h + 15))

-- HUD BACKGROUND (GREY)
Cure.HUD.AddVertexPoint(2, x + 1, y + 1)
Cure.HUD.AddVertexPoint(2, (x + w) - 4, y + 1)
Cure.HUD.AddVertexPoint(2, (x + w - h) - 1, (y + h) - 1)
Cure.HUD.AddVertexPoint(2, (x + w - ((h * 4) + 15)) - 2, (y + h) - 1)
Cure.HUD.AddVertexPoint(2, (x + w - ((h * 4) + 30)) - 1, (y + h + 15) - 1)
Cure.HUD.AddVertexPoint(2, x + 1, (y + (h + 15)) - 1)

y = y - 45
h = 42.24

-- HUD TIME BAR (BLACK)
Cure.HUD.AddVertexPoint(3, x, y)
Cure.HUD.AddVertexPoint(3, x + w - h, y)
Cure.HUD.AddVertexPoint(3, x + w, y + h)
Cure.HUD.AddVertexPoint(3, x, y + h)

-- HUD TIME BAR BACKGROUND (GREY)
Cure.HUD.AddVertexPoint(4, x + 1, y + 1)
Cure.HUD.AddVertexPoint(4, x + w - h - 2, y + 1)
Cure.HUD.AddVertexPoint(4, x + w - 3, y + h - 1)
Cure.HUD.AddVertexPoint(4, x + 1, y + h - 1)

-- HUD TIME BAR (POINTYBAR)
Cure.HUD.AddVertexPoint(10, x + 1, y + 1)
Cure.HUD.AddVertexPoint(10, x + w - h - 2, y + 1)
Cure.HUD.AddVertexPoint(10, x + w - 3, y + h - 1)
Cure.HUD.AddVertexPoint(10, x + 1, y + h - 1)

h = 22.5
y = y - h - 2
local _h = 42.24

-- VELOCITY (BLACK)
Cure.HUD.AddVertexPoint(5, x, y)
Cure.HUD.AddVertexPoint(5, (x + w - _h) - 23, y)
Cure.HUD.AddVertexPoint(5, x + w - _h, y + h)
Cure.HUD.AddVertexPoint(5, x, y + h)

-- VELOCITY (GREY)
Cure.HUD.AddVertexPoint(6, x + 1, y + 1)
Cure.HUD.AddVertexPoint(6, ((x + w - _h) - 23) - 1, y + 1)
Cure.HUD.AddVertexPoint(6, (x + w - _h - 1) - 2, y + h - 1)
Cure.HUD.AddVertexPoint(6, x + 1, y + h - 1)

-- VELOCITY (POINTYBAR)
Cure.HUD.AddVertexPoint(7, x + 1, y + 1)
Cure.HUD.AddVertexPoint(7, ((x + w - _h) - 23) - 1, y + 1)
Cure.HUD.AddVertexPoint(7, (x + w - _h - 1) - 2, y + h - 1)
Cure.HUD.AddVertexPoint(7, x + 1, y + h - 1)

h = 42.24
y = 2

-- XP BAR (BLACK)
Cure.HUD.AddVertexPoint(8, x, y)
Cure.HUD.AddVertexPoint(8, x + w, y)
Cure.HUD.AddVertexPoint(8, x + w - 30, y + 30)
Cure.HUD.AddVertexPoint(8, x, y + 30)

-- XP BAR (GREY)
Cure.HUD.AddVertexPoint(9, x + 1, y + 1)
Cure.HUD.AddVertexPoint(9, (x + w) - 2, y + 1)
Cure.HUD.AddVertexPoint(9, (x + w) - 31, y + 29)
Cure.HUD.AddVertexPoint(9, x + 1, y + 29)

-- Table
local xpnotifications = {}

-- Send from server
usermessage.Hook("cure.xp.notify", function(um)
	-- Read
	local amount = um:ReadLong()

	-- To table
	table.insert(xpnotifications, {time = CurTime() + 1, alpha = 255, title = tostring(amount), x = 0, speed = math.Rand(.5, .9)})
end)

-- XP notification
function Cure.HUD.DrawXPNotificaton()
	for k, v in pairs(xpnotifications) do
		if (v.title) then
			if (v.time <= CurTime()) then
				v.alpha = v.alpha - 2
			end

			v.x = math.Approach(v.x, ScrW(), v.speed)

			draw.SimpleText("+"..v.title.."xp", "hud:text.small", 475 + v.x, 10, Color(255, 255, 255, v.alpha), TEXT_ALIGN_LEFT)

			if (v.alpha <= -5) then
				table.remove(notfications, k)
			end
		end
	end
end

-- TO-DO
-- Optimize this
-- Or possible re-write
-- Unsure what the impact on the FPS is
local function DrawXP()
	render.ClearStencil();
	render.SetStencilEnable(true);

	local xp = math.Clamp(Cure.Level.GetXP(LocalPlayer()) / Cure.Level.GetXPFromLevel(Cure.Level.GetLevel(LocalPlayer())), 0, 1)

	h = 42.24
	y = 2

	render.SetStencilWriteMask(1);
	render.SetStencilTestMask(1);

	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER);
	render.SetStencilFailOperation(STENCILOPERATION_REPLACE);
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP);
	render.SetStencilPassOperation(STENCILOPERATION_KEEP);
	render.SetStencilReferenceValue(1);

	Cure.HUD.DrawVertexPoints(9, Color(34, 35, 39, 255))

	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL);
	render.SetStencilReferenceValue(1);
	render.SetStencilFailOperation(STENCILOPERATION_ZERO);
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO);
	render.SetStencilPassOperation(STENCILOPERATION_KEEP);

	draw.RoundedBox(0, x + 1 , y + 1, xp * (w - 2), (h - 2) + 15, Color(23, 122, 86, 255))
	draw.SimpleText("Level "..Cure.Level.GetLevel(LocalPlayer()), "hud:text.small", 5, y + (h / 2) - 5, Color(176, 176, 176, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	local text = string.Comma(Cure.Level.GetXP(LocalPlayer()))
	text = text.." / "..string.Comma(Cure.Level.GetXPFromLevel(Cure.Level.GetLevel(LocalPlayer()))).." xp"

	draw.SimpleText(text, "hud:text.small", w - 30, y + (h / 2) - 5, Color(176, 176, 176, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	render.SetStencilEnable(false)
end

local points = {}
points["velocity"] = {}
points["velocity"][1] = {x = Cure.HUD.GetVertexPoint(7, 1).x, y = Cure.HUD.GetVertexPoint(7, 1).y}
points["velocity"][2] = {x = Cure.HUD.GetVertexPoint(7, 4).x, y = Cure.HUD.GetVertexPoint(7, 4).y}

local function DrawVelocity()
	render.ClearStencil();
	render.SetStencilEnable(true);

	h = 22.5
	y = y - h - 2
	_h = 42.24

	render.SetStencilWriteMask(1);
	render.SetStencilTestMask(1);

	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER);
	render.SetStencilFailOperation(STENCILOPERATION_REPLACE);
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP);
	render.SetStencilPassOperation(STENCILOPERATION_KEEP);
	render.SetStencilReferenceValue(1);

	Cure.HUD.DrawVertexPoints(6, Color(148, 7, 50, 255))

	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL);
	render.SetStencilReferenceValue(1);
	render.SetStencilFailOperation(STENCILOPERATION_ZERO);
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO);
	render.SetStencilPassOperation(STENCILOPERATION_KEEP);

	local p = (LocalPlayer():GetObserverTarget() or LocalPlayer())
	local velocity = math.Clamp(p:GetVelocity():Length2D() / 1500, 0, 1)

	Cure.HUD.SetVertexPoint(7, 2, (velocity * w) - 65, points["velocity"][1].y)
	Cure.HUD.SetVertexPoint(7, 3, (velocity * w) - 45 , points["velocity"][2].y)

	draw.SimpleText("Velocity: "..math.Round(p:GetVelocity():Length2D()), "hud:text.small", x + 5, y + (h / 2) + 1, Color(176, 176, 176, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	render.SetStencilEnable(false)
end

points["timer"] = {}
points["timer"][1] = {x = Cure.HUD.GetVertexPoint(10, 1).x, y = Cure.HUD.GetVertexPoint(10, 1).y}
points["timer"][2] = {x = Cure.HUD.GetVertexPoint(10, 4).x, y = Cure.HUD.GetVertexPoint(10, 4).y}

local function DrawTimer()
	render.ClearStencil();
	local timer = math.Round(GetGlobalInt("roundtime") - CurTime())

	y = y - 45
	h = 42.24

	render.SetStencilEnable(true);

	render.SetStencilWriteMask(1);
	render.SetStencilTestMask(1);

	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER);
	render.SetStencilFailOperation(STENCILOPERATION_REPLACE);
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP);
	render.SetStencilPassOperation(STENCILOPERATION_KEEP);
	render.SetStencilReferenceValue(1);

	Cure.HUD.DrawVertexPoints(4, Color(62, 62, 62, 105))

	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL);
	render.SetStencilReferenceValue(1);
	render.SetStencilFailOperation(STENCILOPERATION_ZERO);
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO);
	render.SetStencilPassOperation(STENCILOPERATION_KEEP);

	timer = math.Clamp(timer / GetGlobalInt("roundtime.unchanged"), 0, 1)

	--draw.RoundedBox(0, x + 1 , y + 1, math.Clamp(timer / GetGlobalInt("roundtime.unchanged"), 0, 1) * (w - 2), (h - 2) + 15, Color(27, 91, 103, 255))
	Cure.HUD.SetVertexPoint(10, 2, (timer * w) - 45, points["timer"][1].y)
	Cure.HUD.SetVertexPoint(10, 3, (timer * w) - 4, points["timer"][2].y)

	timer = math.Round(GetGlobalInt("roundtime") - CurTime())
	timer = string.ToMinutesSeconds(timer) or "00:00"

	draw.SimpleText("Timeleft: "..timer, "hud:text", x + 5, y + (h / 2) + 1, Color(176, 176, 176, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	render.SetStencilEnable(false)
end

local function DrawHealth()
	-- Reset
	w, h = 476, 42.24
	y  = realy

	-- HEALTH
	render.ClearStencil();
	render.SetStencilEnable(true);

	render.SetStencilWriteMask(1);
	render.SetStencilTestMask(1);

	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER);
	render.SetStencilFailOperation(STENCILOPERATION_REPLACE);
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP);
	render.SetStencilPassOperation(STENCILOPERATION_KEEP);
	render.SetStencilReferenceValue(1);

	-- idk
	Cure.HUD.DrawVertexPoints(2, Color(62, 62, 62, 105))

	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL);
	render.SetStencilReferenceValue(1);
	render.SetStencilFailOperation(STENCILOPERATION_ZERO);
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO);
	render.SetStencilPassOperation(STENCILOPERATION_KEEP);

	local p = (LocalPlayer():GetObserverTarget() or LocalPlayer())
	draw.RoundedBox(0, x + 1 , y + 1, math.Clamp(p:Health() / 100, 0, 1) * (w - 2), (h - 2) + 15, Color(79, 12, 12, 255))

	surface.SetDrawColor(Color(255, 0, 0, 255))
	surface.SetMaterial(heart)
	surface.DrawTexturedRect(3, (y - h) + (54 / 2) + (h / 2) - 3, 54, 54)

	draw.SimpleText(p:Health(), "hud:title", w - x - 40, y - 7, Color(176, 176, 176, 255), TEXT_ALIGN_RIGHT)

	render.SetStencilEnable(false)
end

-- Paint
function GM:HUDPaint()
	-- Blood
	Cure.HUD.DrawBlood()

	-- Notifiations
	Cure.HUD.DrawNotify()

	-- Keys
	Cure.Keys.Draw()

	-- HEALTH
	Cure.HUD.DrawVertexPoints(1, Color(17, 18, 20, 255))
	Cure.HUD.DrawVertexPoints(2, Color(34, 35, 39, 255))


	DrawHealth()

	-- TIMER
	Cure.HUD.DrawVertexPoints(3, Color(17, 18, 20, 255))
	Cure.HUD.DrawVertexPoints(4, Color(34, 35, 39, 255))
	Cure.HUD.DrawVertexPoints(10, Color(27, 91, 103, 255))

	DrawTimer()

	-- VELOCITY
	Cure.HUD.DrawVertexPoints(5, Color(17, 18, 20, 255))
	Cure.HUD.DrawVertexPoints(6, Color(34, 35, 39, 255))

	-- Bar itself
	Cure.HUD.DrawVertexPoints(7, Color(148, 7, 50, 255))

	DrawVelocity()

	-- XP
	Cure.HUD.DrawVertexPoints(8, Color(17, 18, 20, 255))
	Cure.HUD.DrawVertexPoints(9, Color(34, 35, 39, 255))

	DrawXP()

	-- Get target
	local p = (LocalPlayer():GetObserverTarget())

	-- Spectating
	if (p) then
		draw.SimpleText("Spectating", "hud:text", ScrW() / 2, ScrH() - 125, color_white, TEXT_ALIGN_CENTER)
		draw.SimpleText(p:Name(), "hud:text.small", ScrW() / 2, ScrH() - 90, color_white, TEXT_ALIGN_CENTER)
		draw.SimpleText("Left/Right to switch between targets", "hud:text.small", ScrW() / 2, ScrH() - 65, color_white, TEXT_ALIGN_CENTER)
	end

	-- XP
	Cure.HUD.DrawXPNotificaton()
end

local hidetable = {"CHudSecondaryAmmo", "CHudAmmo", "CHudHealth", "CHudBatter", "CHudBatter", "CHudChat"}

-- Hide old hl2 hud
function HUDShouldDraw(name)
	for k, v in pairs(hidetable) do
		if (v == name) then
			return false
		end
    end
end
hook.Add("HUDShouldDraw","RemoveHUD", HUDShouldDraw)
