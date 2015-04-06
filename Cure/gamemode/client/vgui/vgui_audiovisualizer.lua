local AUDIO = {}

AccessorFunc(AUDIO, "m_ply", "Ply")
AccessorFunc(AUDIO, "m_color", "Color")

function surface.DrawLineEx(x1,y1, x2,y2, w, col)
	w = w or 1
	col = col or color_white
	local dx,dy = x1-x2, y1-y2
	local ang = math.atan2(dx, dy)
	local dst = math.sqrt((dx * dx) + (dy * dy))
	x1 = x1 - dx * 0.5
	y1 = y1 - dy * 0.5
	draw.NoTexture()
	surface.SetDrawColor(col)
	surface.DrawTexturedRectRotated(x1, y1, w, dst, math.deg(ang))
end


function AUDIO:Init()
	self.Vis = {}
	self.Next = true
	self.Last =  50
end

function AUDIO:Paint()
	if not self:GetPly() or not IsValid(self:GetPly()) or not self:GetPly():IsPlayer() then return end
	local ply = self:GetPly()
	local voice_volume = ply:VoiceVolume()*150
	if self.Next then
		local x1, y1, x2, y2 = 250, self.Last, 250+5, 50-voice_volume
		self.Vis[#self.Vis+1] = vgui.Create("VisualizerLine", self)
		self.Vis[#self.Vis]:SetSize(250, 50)
		self.Vis[#self.Vis]:SetColor(self:GetColor())
		self.Vis[#self.Vis]:SetP({x1,y1,x2,y2})
		self.Last = y2
		self.Next = false
	end
end

function AUDIO:Think()
	for _, elem in pairs(self.Vis)do
		if IsValid(elem) then
			local x, y = elem:GetPos()
			elem:SetPos(x-1,y)
			if x < -250 then
				elem:Remove()
			end
		end
	end
	if IsValid(self.Vis[#self.Vis]) then
		local x, y = self.Vis[#self.Vis]:GetPos()
		if x <= -4 then
			self.Next = true
		end
	end
end
vgui.Register("AudioVisualizer", AUDIO)

------

local LINE = {}

AccessorFunc(LINE, "m_p", "P")
AccessorFunc(LINE, "m_color", "Color")

function LINE:Paint()
	local col = color_white
	local p = self:GetP()
	local ply = self:GetParent():GetPly()

	if (ply:Team() == TEAM_DEATH) and (ply:Alive()) then
		col = Color(255, 36, 0, 255)
	elseif (ply:Team() == TEAM_RUNNER) and (ply:Alive()) then
		col = Color(59, 185, 255, 255)
	else
		col = Color(255, 255, 255, 255)
	end

	if (ply:IsAdmin()) then
		col = HSVToColor(math.sin(0.3*RealTime())*128 + 127, 1, 1) 
	end

	--col = team.GetColor(ply:Team())
	col.a = 50
	surface.DrawLineEx(p[1]-5, p[2], p[3]-5, p[4], 2, col)
	draw.NoTexture()
	col.a = 30
	surface.SetDrawColor(col)
	surface.DrawPoly({
		{x = p[1]-5, y = 50, u = 0, v = 0},
		{x = p[1]-5, y = p[2], u = 0, v = 1},
		{x = p[3]-5, y = p[4], u = 1, v = 1},
		{x = p[3]-5, y = 50, u = 1, v = 0},
	})
end
vgui.Register("VisualizerLine", LINE)