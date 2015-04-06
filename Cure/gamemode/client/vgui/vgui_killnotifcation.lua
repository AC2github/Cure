--[[
	Kill notifications (VGUI)

	- Credits:
		- AC²
		- Unknown (Kiwi)

	- Functions
		- SetData - (playername1, icon or text, playername2)
		- GetTotalLenght - Gives total length of width
		- GetData - gives data
		- SetColors - Set colors
		- OnRemove - called when it gets removed
--]]

-- Font
surface.CreateFont("deathrun.killnotification", {font = "Trebuchet MS", size = ScreenScale(10), weigth = 700, antialias = true, shadow = true})
surface.CreateFont("deathrun.killnotification.small", {font = "Trebuchet MS", size = ScreenScale(9), weigth = 700, antialias = true, shadow = true})

-- Materials
local background = Material("spiceworks/vgui/notification/notifications_background.png", "noclamp")

-- config
local SPACE_BETWEEN = 5

NOTIFICATION = {
	-- Initialize
	Init = function(self)
		local w, h = ScrW(), ScrH()
		-- Size
		self:SetWide(w * .15)
		self:SetTall(40)

		-- Pos
		self:SetPos(w - (w * .15) - 10, 10)

		-- First Avatar
		self.pPlayerOneAvatar = self:Add("AvatarImage")
		self.pPlayerOneAvatar:SetPos(5, 4)
		self.pPlayerOneAvatar:SetSize(32, 32)

		-- First name, first gap: 8px
		self.pPlayerOneName = self:Add("DLabel")
		self.pPlayerOneName:SetPos(40, 8)
		self.pPlayerOneName:SetFont("deathrun.killnotification")

		-- Middle text
		self.sMiddleText = self:Add("DLabel")
		self.sMiddleText:SetFont("deathrun.killnotification.small")

		-- Second player
		self.pPlayerTwoName = self:Add("DLabel")
		self.pPlayerTwoName:SetFont("deathrun.killnotification")

		-- Final avatar
		self.pPlayerTwoAvatar = self:Add("AvatarImage")

		-- Hold data for NOTIFICATION
		self.Data = {}

		-- How long should this stay
		self.iDieTime = CurTime() + 3

		-- Is removing
		self.IsRemoving = false
	end,

	-- Get total length of the panel
	GetTotalLength = function(self)
		local data = self:GetChildren()
		local w, h, x, y
		local iTotalSize = 0

		-- Calculate total width
		for k, v in pairs(data) do
			w = v:GetWide()
			iTotalSize = iTotalSize + w + SPACE_BETWEEN
		end

		return iTotalSize + SPACE_BETWEEN
	end,

	-- Fill data
	SetData = function(self, data)
		-- Valid check
		if not (data) then return end

		-- First and second argument should always be a player
		if not (type(data[1]) == "Player") then return end

		-- Set
		self.Data = data

		-- Update first label
		self.pPlayerOneName:SetText(data[1]:Name())
		self.pPlayerOneName:SizeToContents()

		-- Update avatar
		self.pPlayerOneAvatar:SetPlayer(data[1], 32)

		-- Get x, y, w and h
		local x, y = self.pPlayerOneName:GetPos()
		local w, h = self.pPlayerOneName:GetSize()

		-- Update middle text
		self.sMiddleText:SetText(data[2])
		self.sMiddleText:SetPos(x + w + SPACE_BETWEEN, y + 2)
		self.sMiddleText:SizeToContents()

		-- No third argument
		if not (data[3]) then
			self.pPlayerTwoAvatar:Remove()
			self.pPlayerTwoName:Remove()
		else
			-- Get x, y, w and h
			local x, y = self.sMiddleText:GetPos()
			local w, h = self.sMiddleText:GetSize()

			-- Update
			self.pPlayerTwoName:SetText(data[3]:Name())
			self.pPlayerTwoName:SetPos(x + w + SPACE_BETWEEN, y - 2)
			self.pPlayerTwoName:SizeToContents()

			-- Get x, y, w and h again...
			local x, y = self.pPlayerTwoName:GetPos()
			local w, h = self.pPlayerTwoName:GetSize()

			-- Update last item!
			self.pPlayerTwoAvatar:SetPos(x + w + SPACE_BETWEEN, 4)
			self.pPlayerTwoAvatar:SetSize(32, 32)
			self.pPlayerTwoAvatar:SetPlayer(data[3])
		end
	end,

	-- Set text colors
	SetColors = function(self, colors)
		-- Easy
		self.pPlayerOneName:SetTextColor(colors[1] or color_white)
		self.sMiddleText:SetTextColor(colors[2] or color_white)
		self.pPlayerTwoName:SetTextColor(colors[3] or color_white)
	end,

	-- Get data
	GetData = function(self)
		return self.Data
	end,

	-- OnRemove
	OnRemove = function()
	end,

	-- Think, something kiwi can't do
	Think = function(self)
		-- Calculate total size
		local length = self:GetTotalLength()
		self:SetWide(length)

		-- Time before they die
		if (self.iDieTime <= CurTime()) and (self.IsRemoving == false) then
			self:MoveTo(ScrW() - length - SPACE_BETWEEN, -40, 1, 0)
			self.IsRemoving = true
		else
			if (self.IsRemoving == false) then
				local x, y = self:GetPos()
				self:SetPos(ScrW() - length - SPACE_BETWEEN, y)
			end
		end

		-- 	Get Pos
		local x, y = self:GetPos()

		-- Remove it
		if (y <= -35) then
			self:Remove()
			self:OnRemove()
		end
	end,

	-- Paint
	Paint = function(self, w, h)
		-- Black box
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200)) -- White power

		-- Texture behind it
		surface.SetDrawColor(color_white)
		surface.SetMaterial(background)
		surface.DrawTexturedRectUV(2, 2, w - 4, h - 4, 0, 0, w / 16, h / 16)
	end,
}

NOTIFICATION = vgui.RegisterTable(NOTIFICATION, "EditablePanel")
