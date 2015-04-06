HELP_TEXT = [[
Welcome to Deathrun!

The goal of a Runner is to make it to the end of the map. 
The map, in most cases, is just one huge death-trap.
To make it to the end, you'll have to somehow
survive all the traps activated by the Death players.

The goal of a Death is to kill all of the Runners by utilizing the traps within the map.

Spectating Controls:
Left click: Spectate previous player.
Right click: Spectate next player.
Reload: Cycle through spectating modes.
Crouch: Unspectate player.

Chat Commands:
rtv: Vote to start a map vote.
timeleft: View the amount of rounds before the map changes.
rtd: Roll the dice, see if the luck shines upon you.
]]

RULE_TEXT = [[
1. Trapspamming or trapstealing is not allowed
2. Cheating and hacks are not allowed.	
3. Micspamming and Chatspamming are not allowed.
4. Free runs are not allowed.
5. Respect the admins and moderators.
6. Have respect for the other players.
7. Dont advertise on the server.
8. Dont use offensive names or sprays.
9. Dont delay the game, afk is kick.
10. Camping is not allowed, because its not fair.
11. For the admins & Mods: Dont abuse.
12. What an Admin/Mod says, goes.
]]

local CREDIT_TEXT = [[
Special thanks to:

AC and Anonymous for developing and putting out their 
hardcore sexy time working on the code and designs for this server to be possible!

From the Owner, Admin and Moderators:
Thank you to the players who join this server 
everyday and make the community great, you guys are awesome!
]]

local PARENT_MAINMENU = 1
local PARENT_MENU = 2

local function CreateTextLabel(parent, text, font, x, y)
	if (gDeathrunMenu.Text) then
		gDeathrunMenu.Text:Remove()
	end

	parent = parent or PARENT_MAINMENU
	local menu

	if (parent == PARENT_MAINMENU) then
		menu = gDeathrunMenu:GetMainPanel():Add("DLabel")
	else
		menu = gDeathrunMenu:Add("DLabel")
	end

	menu:SetText(text)
	menu:SetPos(x or 10, y or 10)
	menu:SetFont(font or "mainmenu.title.small")
	menu:SizeToContents()

	return menu
end

gDeathrunJukebox = vgui.Create("deathrun.vgui.jukeboxplayer")
gDeathrunJukebox:Javascript([[player.pauseVideo();]])
gDeathrunJukebox:Hide()

usermessage.Hook("cure_mainframe", function()
	if (gDeathrunMenu) and not (gDeathrunMenu:IsVisible()) then
		-- Open
		gDeathrunMenu:SetVisible(true)

		-- Hide jukebox parent
		if not (gDeathrunMenu:GetActiveTab().name == "All") then
			gDeathrunJukebox:Hide()
		end

		-- Update song list
		if (gDeathrunMenu.songlist) and (gDeathrunMenu.songlist:IsValid()) then
			gDeathrunMenu.songlist:Update()
		end

		return
	elseif (gDeathrunMenu) and (gDeathrunMenu:IsVisible()) then
			-- Just toogle
			gDeathrunMenu:Hide()
	else
		-- Create
		gDeathrunMenu = vgui.CreateFromTable(MAIN_PANEL)
	end

	-- General
	local general = gDeathrunMenu:AddCategory("General")
	general:AddOption("Help", "icon16/help.png", function()
		-- Remove panel
		gDeathrunMenu:ClearMainPanel()

		-- Categories
		gDeathrunMenu:AddTab("Information about our server")

		-- Options
		gDeathrunMenu:AddTabOption("Deathrun", function()
		 	gDeathrunMenu.Text = CreateTextLabel(PARENT_MAINMENU, HELP_TEXT)
		end)

		gDeathrunMenu:AddTabOption("Store", function()
		 	gDeathrunMenu.Text = CreateTextLabel(PARENT_MAINMENU, RULE_TEXT)
		end)

		gDeathrunMenu:SetActiveTab("Deathrun")
	end)

	general:AddOption("Rules", "icon16/script.png", function()
		-- Remove panel
		gDeathrunMenu:ClearMainPanel()

		-- Categories
		gDeathrunMenu:AddTab("Rules in our server")

		gDeathrunMenu:AddTabOption("Deathrun", function()
		 	gDeathrunMenu.Text = CreateTextLabel(PARENT_MAINMENU, RULE_TEXT)
		end)

		gDeathrunMenu:SetActiveTab("Deathrun")
	end)

	general:AddOption("Donate", "icon16/heart.png", function()
	end)

	general:AddOption("Credits", "icon16/book.png", function()
		-- Remove panel
		gDeathrunMenu:ClearMainPanel()

		-- Categories
		gDeathrunMenu:AddTab("People who made this all possible")

		gDeathrunMenu:AddTabOption("Credits", function()
		 	gDeathrunMenu.Text = CreateTextLabel(PARENT_MAINMENU, CREDIT_TEXT)
		end)

		gDeathrunMenu:SetActiveTab("People who made this all possible")
	end)

	general:AddOption("Settings", "icon16/cog.png")

	local awards = gDeathrunMenu:AddCategory("Awards")
	awards:AddOption("Achievements", "icon16/rosette.png", function()
		-- Clear
		gDeathrunMenu:ClearMainPanel()

		-- Remove
		if (gDeathrunMenu.Text) then
			gDeathrunMenu.Text:Remove()
		end

		-- Text
		gDeathrunMenu:AddTab("Achievements")

		-- Achievements menu
		gDeathrunMenu.achievements = gDeathrunMenu:GetMainPanel():Add("deathrun.vgui.achievementpanel")
		gDeathrunMenu.achievements.remove = true

		-- All types
		for i = 1, #Cure.Achievements.Categories do
			gDeathrunMenu:AddTabOption(Cure.Achievements.Categories[i], function()
				gDeathrunMenu.achievements:SetType(i)
				gDeathrunMenu.achievements:Update()
			end)
		end

		-- Tab
		gDeathrunMenu:SetActiveTab("Level")

		-- First category
		gDeathrunMenu.achievements:SetType(1)
	end)

	awards:AddOption("Stats", "icon16/vcard.png", function()
		-- Clear
		gDeathrunMenu:ClearMainPanel()

		-- Remove
		if (gDeathrunMenu.Text) then
			gDeathrunMenu.Text:Remove()
		end

		-- Create
		gDeathrunMenu.stats = gDeathrunMenu:GetMainPanel():Add("deathrun.vgui.statsmenu")
	end)

	--awards:AddOption("Leaderboards", "icon16/table.png")

	-- Market
	local market = gDeathrunMenu:AddCategory("Market")

	market:AddOption("Store", "icon16/cart.png", function()
		-- Remove panel
		gDeathrunMenu:ClearMainPanel()

		-- Categories
		gDeathrunMenu:AddTab("Store")
		gDeathrunMenu:AddTabOption("Hats")
		gDeathrunMenu:AddTabOption("Trails")
		gDeathrunMenu:AddTabOption("Models")
		gDeathrunMenu:AddTabOption("Tags")
		gDeathrunMenu:AddTabOption("Taunts")
		gDeathrunMenu:AddTabOption("Misc")
	end)

	market:AddOption("Inventory", "icon16/box.png")
	--market:AddOption("Trade", "icon16/arrow_switch.png")
	--market:AddOption("Craft", "icon16/wrench.png")

	-- Jukebox
	local jukebox = gDeathrunMenu:AddCategory("Jukebox")

	jukebox:AddOption("Songs", "icon16/music.png", function()
		-- Clear
		gDeathrunMenu:ClearMainPanel()

		-- Remove
		if (gDeathrunMenu.Text) then
			gDeathrunMenu.Text:Remove()
		end

		-- Categories
		gDeathrunMenu:AddTab("Songs")
		gDeathrunMenu:AddTabOption("All", function()
			gDeathrunMenu.songlist = gDeathrunMenu:GetMainPanel():Add("deathrun.vgui.jukebox")
			gDeathrunMenu.songlist:SetTable(Cure.Jukebox.Songs)
			gDeathrunMenu.songlist.remove = true

			local x, y = gDeathrunMenu:GetMainPanel():GetPos()

			gDeathrunMenu.Text = CreateTextLabel(PARENT_MENU, [[
			Welcome to the jukebox
			Find a song you want to add to queue then click on it to do so.
			To turn the jukebox just drag the volume slider to 0%.
			]], "mainmenu.title.small2", x, y - 15)

			-- Move panel down
			local x, y, w, h = gDeathrunMenu:GetModifiedMainPanel()
			gDeathrunMenu:ModifyMainPanel(x, y + 45, w, h - 100)
			x, y, w, h = gDeathrunMenu:GetModifiedMainPanel()

			gDeathrunJukebox:SetParent(gDeathrunMenu)
			gDeathrunJukebox:SetPos(x - 6, gDeathrunMenu:GetTall() - 60)
			gDeathrunJukebox:SetSize(w + 6, 60)
			gDeathrunJukebox:Performlayout()
			gDeathrunJukebox:Show()

			gDeathrunMenu.songlist:Update()
		end)

		gDeathrunMenu:SetActiveTab("All")
	end)

	jukebox:AddOption("Queue", "icon16/control_fastforward_blue.png", function()
		-- Clear
		gDeathrunMenu:ClearMainPanel()

		-- Remove
		if (gDeathrunMenu.Text) then
			gDeathrunMenu.Text:Remove()
		end

		gDeathrunMenu:AddTab("Queue")
		gDeathrunMenu:AddTabOption("Queue", function()
			gDeathrunMenu.queue = gDeathrunMenu:GetMainPanel():Add("deathrun.vgui.jukebox")
			gDeathrunMenu.queue:SetTable(Cure.Jukebox.Queue)
			gDeathrunMenu.queue:Update()
		end)

		gDeathrunMenu:SetActiveTab("Queue")
	end)

	if (LocalPlayer():IsAdmin()) then
		local admin = gDeathrunMenu:AddCategory("Admin")
		admin:AddOption("Commands", "icon16/lightning.png")
		admin:AddOption("Bans", "icon16/delete.png")
		admin:AddOption("Ranks", "icon16/star.png")
	end

	-- Set first page
	gDeathrunMenu:SetActive("Help")

	-- Popup
	gDeathrunMenu:MakePopup()
end)