--[[
		Main panel

		Please do not modifiy any code below.

		Credits:
		AC² - Main code, textures
		Unknown - Ideas
--]]

-- Materials
local zoom = Material("icon16/zoom.png")
local logo = "spiceworks/vgui/mainmenu/spiceworks_logo_final.png"
local exitbutton = Material("spiceworks/vgui/mainmenu/mainmenu_exitbutton.png", "smooth")

-- Fonts
surface.CreateFont("mainmenu.title", {font="Verdana", size = 24, weigth = 200, antialias = true})
surface.CreateFont("mainmenu.title.small", {font="Verdana", size = 18, weigth = 200, antialias = true})
surface.CreateFont("mainmenu.title.small2", {font="Verdana", size = 16, weigth = 200, antialias = true})
surface.CreateFont("mainmenu.title.fat", {font="Verdana", size = 24, weigth = 1000, antialias = true, blursize = .5, shadow = true})
surface.CreateFont("mainmenu.textentry", {font="Verdana", size = 14, weigth = 200, antialias = true})

MAIN_PANEL = {
	-- Initalize
	Init = function(self)
		-- Get Screen width/height
		local w, h = ScrW(), ScrH()

		-- Size
		self:SetWide(w * .9)
		self:SetTall(h * .85)

		-- Center
		self:Center()

		-- Data
		self.CategoryData = {}

		h = (h * .065) - 2

		-- Image
		self.Logo = self:Add("DImage")
		self.Logo:SetPos(10, (h / 2) - 17)
		self.Logo:SetSize(32, 32)
		self.Logo:SetImage(logo)

		-- Title
		self.sTitle = self:Add("DLabel")
		self.sTitle:SetPos(47, (h / 2) - 16)
		self.sTitle:SetFont("mainmenu.title")
		self.sTitle:SetTextColor(Color(176, 176, 176, 255))
		self.sTitle:SetText("SpiceWorks")
		self.sTitle:SizeToContents()

		local w, h = self:GetSize()

		-- Categories
		self.Categories = self:Add("DScrollPanel")
		self.Categories:SetPos(0, (h * .065) + 1)
		self.Categories:SetSize(w * .20, self:GetTall() - (h * .065))

		-- Paint
		self.Categories.Paint = function(self) 
			-- Background
			draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(34, 35, 39, 255))

			-- Line next to
			surface.SetDrawColor(Color(58, 59, 61, 255))
			surface.DrawRect(self:GetWide() - 2, 0, 1, self:GetTall())

			-- Outline
			surface.SetDrawColor(Color(17, 18, 20, 255))
			surface.DrawOutlinedRect(0, -1, self:GetWide(), self:GetTall() + 1)
		end

		-- Scrollbars
		self.Categories.VBar.btnGrip.Paint = function(self)
			draw.RoundedBox(4, 2, 0, self:GetWide() - 4, self:GetTall(), Color(51, 52, 56, 255))
		end

		self.Categories.VBar.Paint = function(self)
			draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(28, 27, 32, 255))
		end

		-- Don't render these
		self.Categories.VBar.btnDown.Paint = function() end
		self.Categories.VBar.btnUp.Paint = function() end

		-- Avatar
		self.pAvatar = self.Categories:Add("AvatarImage")
		self.pAvatar:SetSize(64, 64)
		self.pAvatar:SetPos(10, 10)
		self.pAvatar:SetPlayer(LocalPlayer(), 64)
		--self.pAvatar:SetPaintManual(true)

		self.pAvatar.PaintOver = function(self)
			surface.SetDrawColor(Color(17, 18, 20, 255))
			surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
		end

		-- Get pos
		local x, y = self.pAvatar:GetPos()

		-- Welcome
		self.Welcome = self.Categories:Add("DLabel")
		self.Welcome:SetText("Welcome")
		self.Welcome:SetFont("mainmenu.title.small")
		self.Welcome:SetPos(x + 64 + 5, y + 20)
		self.Welcome:SizeToContents()

		-- Name
		self.pName = self.Categories:Add("DLabel")
		self.pName:SetPos(x + 64 + 5, y + 40)
		local name = LocalPlayer():Name()

		if (string.len(name) >= 18) then
			name = string.Left(name, 18).."..."
		end

		self.pName:SetText(name)
		self.pName:SetTextColor(Color(176, 176, 176, 255))
		self.pName:SetFont("mainmenu.textentry")
		self.pName:SizeToContents()

		-- Search bar
		self.SearchBar = self.Categories:Add("DPanel")
		self.SearchBar:SetSize(self.Categories:GetWide() - 20, 30)
		self.SearchBar:SetPos(10, y + 64 + 20)

		-- Black outline
		self.SearchBar.Paint = function(self)
			-- Outline
			surface.SetDrawColor(Color(17, 18, 20, 255))
			surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())

			-- Extra background
			surface.SetDrawColor(Color(40, 41, 45, 255))
			surface.DrawRect(1, 1, 30, self:GetTall() - 2)

			-- Zoom
			surface.SetDrawColor(Color(0, 0, 0, 255))
			surface.SetMaterial(zoom)
			surface.DrawTexturedRect(8, 8, 16, 16)
		end

		-- Search entry
		self.SearchEntry = self.SearchBar:Add("DTextEntry")
		self.SearchEntry:SetPos(30, 1)
		self.SearchEntry:SetSize(self.SearchBar:GetWide() - 31, self.SearchBar:GetTall() - 2)
		self.SearchEntry:SetText("This feature is disabled")
		self.SearchEntry:SetFont("mainmenu.textentry")

		self.SearchEntry.Paint = function(self)
			surface.SetDrawColor(Color(40, 41, 45, 255))
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			self:DrawTextEntryText(Color(176, 176, 176, 255), color_white, color_white)
		end

		-- Exit button at the top
		self.Exit = self:Add("DButton")
		self.Exit:SetPos(self:GetWide() - 42, ((h * .065) / 2) - 16)
		self.Exit:SetSize(32, 32)
		self.Exit:SetText("")

		self.Exit.Paint = function(self)
			surface.SetDrawColor(color_white)
			surface.SetMaterial(exitbutton)
			surface.DrawTexturedRect(0, 0, 32, 32)
		end

		self.Exit.DoClick = function() self:SetVisible(false) end

		-- Last but not least, the main panel that handles all other vgui
		self.MainPanel = vgui.Create("DScrollPanel", self)
		-- Calculate
		local x, y = self.Categories:GetPos()
		local w, h = self.Categories:GetSize()

		self.MainPanel:SetPos(x + w + 20, 150)
		self.MainPanel:SetSize(self:GetWide() - w - x - 52, self:GetTall() - 155)

		-- Scrollbars
		self.MainPanel.VBar.btnGrip.Paint = function(self)
			draw.RoundedBox(4, 2, 0, self:GetWide() - 4, self:GetTall(), Color(51, 52, 56, 255))
		end

		self.MainPanel.VBar.Paint = function(self)
			draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(28, 27, 32, 255))
		end

		-- Don't render these
		self.MainPanel.VBar.btnDown.Paint = function() end
		self.MainPanel.VBar.btnUp.Paint = function() end

		self.MainPanel.Paint = function(self)
			--draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), color_white)
		end
	end,

	-- Return main panel
	GetMainPanel = function(self)
		return self.MainPanel
	end,

	-- If we need to restore the mainpanel
	ResetMainPanel = function(self)
		-- Calculate
		local x, y = self.Categories:GetPos()
		local w, h = self.Categories:GetSize()

		self.MainPanel:SetPos(x + w + 20, 150)
		self.MainPanel:SetSize(self:GetWide() - w - x - 52, self:GetTall() - 175)
	end,

	-- Return pos, size
	GetModifiedMainPanel = function(self)
		local x, y = self.MainPanel:GetPos()
		local w, h = self.MainPanel:GetSize()

		return x, y, w, h
	end,

	-- Modify Size/Pos of the mainpanel
	ModifyMainPanel = function(self, x, y, w, h)
		self.MainPanel:SetPos(x, y)
		self.MainPanel:SetSize(w, h)
	end,

	-- Top menu tab
	AddTab = function(self, name)
		self.Tab = self:Add("deathrun.vgui.tabmenu")

		local x, y = self.Categories:GetPos()
		local w, h = self.Categories:GetSize()

		self.Tab:SetSize(self:GetWide() - w - x - 40, 100)
		self.Tab:SetPos(x + w + 10, y)
		self.Tab:SetTabTitle(name)
	end,

	-- Top menu tab option
	AddTabOption = function(self, name, func)
		-- Kiwi proof (idiot proof)
		if not (self.Tab) then return end
		-- I love when it is easy
		self.Tab:AddOption(name, func)
	end,

	-- Get tabs
	GetTabs = function(self)
		return self.Tab:GetData()
	end,

	-- Set active tab
	SetActiveTab = function(self, name)
		for k, v in pairs(self.Tab:GetData()) do
			v.Active = false

			if (v.name == name) then
				v.OnMousePressed()
				v.Active = true
				break
			end
		end
	end,

	-- Get active tab
	GetActiveTab = function(self)
		for k, v in pairs(self.Tab:GetData()) do
			if (v.Active) then
				return v
			end
		end
	end,

	-- Reset
	ClearMainPanel = function(self)
		self.MainPanel:Clear()
		--self.MainPanel:Rebuild()

		-- Remove tab
		if (self.Tab) then
			self.Tab:Remove()
		end

		-- Kill the children
		for k, v in pairs(self.MainPanel:GetChildren()) do
			if (v.remove) then
				v:Remove()
			end
		end

		-- MainPanel
		self:ResetMainPanel()
	end,

	-- Set Title
	SetTitle = function(self, title)
		-- Valid
		if not (title) then return end

		-- Set
		self.sTitle:SetText(title)
		self.sTitle:SizeToContents()
	end,

	-- Get title
	GetTitle = function(self)
		return (self.sTitle:GetText() or "#Default")
	end,

	-- Add an option
	AddCategory = function(self, name)
		local panel = (#self.CategoryData or 1) + 1
		-- Insert
		self.CategoryData[panel] = self.Categories:Add("deathrun.vgui.category")
		self.CategoryData[panel]:SetWide(self.Categories:GetWide() - 40)
		if (panel == 1) then
			self.CategoryData[panel]:SetPos(10, 140)
		else
			local x, y = self.CategoryData[panel-1]:GetPos()

			self.CategoryData[panel]:SetPos(10, y + self.CategoryData[panel-1]:GetTotalSize() + 5)
		end
		self.CategoryData[panel]:SetCategoryName(name)

		return self.CategoryData[panel]
	end,

	-- Get catergory
	GetCatergory = function(self)
		return self.CategoryData
	end,

	-- Remove all active buttons
	ResetActiveButtons = function(self)
		for k, v in pairs(self.CategoryData) do
			for i, j in pairs(v:GetData()) do
				j.Active = false
			end
		end
	end,

	-- Set active button tab thingie, i have no idea what I'm doing here
	SetActive = function(self, name)
		self:ResetActiveButtons()
		
		for k, v in pairs(self.CategoryData) do
			for i, j in pairs(v:GetData()) do
				if (j.Name == name) then
					j.OnMousePressed()
					break
				end
			end
		end
	end,

	-- Update every frame
	Think = function(self)
		local i = 200

		for k, v in pairs(self.CategoryData) do
			i = i + (v:GetTotalSize())
		end

		if (i >= self:GetTall()) then
			self.SearchBar:SetWide(self.Categories:GetWide() - 20 - 16)
			local w = self.SearchBar:GetWide()
			self.SearchEntry:SetWide(w - 20 - 11)
		end
	end,

	-- Paint
	Paint = function(self, w, h)
		-- Header
		surface.SetDrawColor(Color(34, 35, 39, 255))
		surface.DrawRect(0, 0, w, h * .065)

		-- Line below header
		surface.SetDrawColor(Color(58, 59, 61, 255))
		surface.DrawRect(0, h * .065, w, 1)

		-- Background
		surface.SetDrawColor(Color(17, 18, 20, 255))
		surface.DrawRect(0, (h * .065) + 1, w, h)

		-- Outline
		surface.DrawOutlinedRect(0, 0, w, h)
	end,
}

-- Register
MAIN_PANEL = vgui.RegisterTable(MAIN_PANEL, "EditablePanel")