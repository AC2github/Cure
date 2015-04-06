--[[
		Jukebox

		Please do not modifiy any code below.

		Credits:
		AC² - Main code, textures
		Unknown - Playing his annoying drum while writing this code. MOST HORRIBLE DRUM EVER
--]]

local PANEL = {}
local Duration = 0
local pressed = false
local i = 0
local isplaying = false
local html =  [[
<!DOCTYPE html>
<html>
  <body>
    <!-- 1. The <iframe> (and video player) will replace this <div> tag. -->
    <div id="player"></div>

    <script>
      // 2. This code loads the IFrame Player API code asynchronously.
      var tag = document.createElement('script');

      tag.src = "https://www.youtube.com/iframe_api";
      var firstScriptTag = document.getElementsByTagName('script')[0];
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

      // 3. This function creates an <iframe> (and YouTube player)
      //    after the API code downloads.
      var player;
      function onYouTubeIframeAPIReady() {
        player = new YT.Player('player', {
          height: '0',
          width: '0',
          videoId: '',
          events: {
            'onReady': onPlayerReady,
          }
        });
      }

      // 4. The API will call this function when the video player is ready.
      function onPlayerReady(event) {
        event.target.playVideo();
      }

      function stopVideo() {
        player.stopVideo();
      }

      stopVideo();
    </script>
  </body>
</html>
]]
-- Init
function PANEL:Init()
	-- First called unparented anyway
	self:SetSize(0, 0)

	-- HTML
	Cure.Jukebox.HTML = vgui.Create("DHTML", self)
	Cure.Jukebox.HTML:SetAllowLua(true)
	Cure.Jukebox.HTML:SetHTML(html)
	Cure.Jukebox.HTML:SetSize(500,500)
	Cure.Jukebox.HTML:SetPos(10, 510)
	Cure.Jukebox.HTML:Hide()

	-- Add JS-LUA thing function
	Cure.Jukebox.HTML:AddFunction("jukebox", "isplaying", function(p) Cure.Jukebox.IsHTMLPlaying = p end)

	-- Name
	local x, y = Cure.Jukebox.HTML:GetPos()
	self.sSongName = self:Add("DLabel")
	self.sSongName:SetFont("mainmenu.title.small")
	self.sSongName:SetText("No song playing")
	self.sSongName:SetTextColor(Color(176, 176, 176, 255))
	self.sSongName:SizeToContents()

	x, y = self.sSongName:GetPos()

	self.sDuration = self:Add("DLabel")
	self.sDuration:SetFont("mainmenu.title.small")
	self.sDuration:SetTextColor(Color(176, 176, 176, 255))
	self.sDuration:SetText("00:00")
	self.sDuration:SizeToContents()

	-- Play
	self.PlayButton = self:Add("DImageButton")
	self.PlayButton:SetSize(16, 16)
	self.PlayButton:SetIcon("icon16/control_pause.png")
	self.PlayButton.OnMousePressed = function()
		if (pressed) then
			self.PlayButton:SetImage("icon16/control_pause.png")
		else
			self.PlayButton:SetImage("icon16/control_play.png")
		end

		Cure.Jukebox.Pause(not pressed)

		pressed = not pressed
	end

	self.SoundImage = self:Add("DImage")
	self.SoundImage:SetImage("icon16/sound.png")
	self.SoundImage:SetSize(16, 16)

	-- Volume
	self.VolumeSlider = self:Add("Slider")
	self.VolumeSlider:SetWide(150)
	self.VolumeSlider:SetMin(0) 
	self.VolumeSlider:SetMax(1) 
	self.VolumeSlider:SetText("")
	self.VolumeSlider:SetDecimals(1)
	self.VolumeSlider:SetConVar("jukebox_volume")
	self.VolumeSlider:SetValue(tonumber(GetConVarNumber("jukebox_volume")))

	-- Slider
	self.VolumeSlider.Paint = function(self, w, h)
		surface.SetDrawColor(Color(32, 34, 41, 255))
		surface.DrawRect(0, h / 2, w - 50, 1)

		return false
	end

	print(self.VolumeSlider.Knob)

	-- Text
	self.VolumeSlider.PaintOver = function(self, w, h)
		draw.SimpleText(tostring(math.Round(GetConVarNumber("jukebox_volume") * 100)).."%", "mainmenu.title.small2", w - 25, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	-- Time
	self.CurrentTime = self:Add("DLabel")
	self.CurrentTime:SetFont("mainmenu.title.small")
	self.CurrentTime:SetTextColor(Color(176, 176, 176, 255))
	self.CurrentTime:SetText("00:00")
	self.CurrentTime:SizeToContents()

	-- Remove
	if (timer.Exists("jukebox.timer")) then timer.Destroy("jukebox.timer") end

	-- Timer
	timer.Create("jukebox.timer", .5, 0, function()
		-- Keep checking
		Cure.Jukebox.CheckHTMLPlaying()

		if (Cure.Jukebox.IsPlayingSong == false) then
			isplaying = false
			i = 0
			Duration = 0
			return
		end

		-- Check if we are playing
		if (Cure.Jukebox.IsVideoPlaying()) then
			-- Bool
			isplaying = true
		else
			-- Bool
			isplaying = false
		end

		if (isplaying) then
			-- Increase
			i = i + .5

			-- Update
			self.CurrentTime:SetText(string.ToMinutesSeconds(i))
			self.CurrentTime:SizeToContents()
		else
			-- Update
			self.CurrentTime:SetText("00:00")
			self.CurrentTime:SizeToContents()
		end
	end)

	-- Bar
	self.ProgressBar = self:Add("DPanel")

	-- Oh dear
	self.ProgressBar.Paint = function(self, w, h)
		surface.SetDrawColor(Color(32, 34, 41, 255))
		surface.DrawRect(0, h / 2, w, 1)

		surface.SetDrawColor(Color(85, 160, 101, 255))
		surface.DrawRect(0, h / 2, ((w / tonumber(Duration)) * i), 1)
	end
end

-- Run javascript
function PANEL:Javascript(str)
	Cure.Jukebox.HTML:QueueJavascript(str)
end

-- Performlayout
function PANEL:Performlayout()
	-- Name
	self.sSongName:SetPos(9, 0)

	-- New pos
	local x, y = self.sSongName:GetPos()

	-- Play
	self.PlayButton:SetPos(x, 30)

	-- Volume
	x, y = self.PlayButton:GetPos()
	self.SoundImage:SetPos(x + 30, y)
	self.VolumeSlider:SetPos(x + 55, y - 8)

	x, y = self.VolumeSlider:GetPos()

	self.CurrentTime:SetPos(x + 5 + 150, y + 7)

	x, y = self.CurrentTime:GetPos()
	local w, h = self.CurrentTime:GetSize()

	self.ProgressBar:SetPos(x + w + 5, y)

	x, y = self.ProgressBar:GetPos()

	self.ProgressBar:SetSize(self:GetWide() - x - w - 10, 20)

	w, h = self.ProgressBar:GetSize()

	self.sDuration:SetPos(x + w + 8, y)
end

-- Set the HTML to open something
function PANEL:PlayURL(name, duration, link)
	-- Convert
	--link = "https://www.youtube.com/embed/"..link.."?&autoplay=1&controls=0&rel=0&start=0&enablejsapi=1&version=3&playerapiid=ytplayer"

	gDeathrunJukebox:Javascript(
		[[
		try { 
			player.loadVideoById(']]..link..[[');
			player.playVideo();
		} catch (e) {}
		]]
	)

	-- Play
	--Cure.Jukebox.HTML:OpenURL(link)

	-- Name
	self.sSongName:SetText("Now playing... "..name)
	self.sSongName:SizeToContents()

	-- Current time
	self.CurrentTime:SetText("00:00")
	self.CurrentTime:SizeToContents()

	-- Time
	self.sDuration:SetText(string.ToMinutesSeconds(duration))
	self.sDuration:SizeToContents()

	-- Eh
	Duration = tonumber(duration)
	i = 0
end

-- Paint
function PANEL:Paint(w, h)
	local x, y = self.sSongName:GetPos()
	local _w, _h = self.sSongName:GetSize()

	surface.SetDrawColor(Color(48, 49, 52, 255))
	surface.DrawRect(5, y + _h + 5, w, 1)
end

-- Register
vgui.Register("deathrun.vgui.jukeboxplayer", PANEL, "EditablePanel")