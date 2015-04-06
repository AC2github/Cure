-- Cvars
CreateClientConVar("jukebox_volume", ".5", true, false)

-- Cvar callbacks
cvars.AddChangeCallback("jukebox_volume", function(cvar, oldvalue, newvalue)
	-- Clamp
	local value = math.Clamp(tonumber(newvalue), 0, 1)

	print("SET VOLUME")
	print("V: "..value)

	-- Set
	Cure.Jukebox.SetVolume(value)
end)

-- Receive new song to play
net.Receive("jukebox.songdata", function()
	-- Receive it
	local data = net.ReadTable()

	-- Store data
	Cure.Jukebox.CurrentSong = {length = data.length, title = data.title, link = data.link}

	-- We are playing
	Cure.Jukebox.IsPlayingSong = true

	-- Play
	gDeathrunJukebox:PlayURL(data.title, data.length, data.link)

	-- Volume
	Cure.Jukebox.SetVolume(tonumber(GetConVar("jukebox_volume"):GetFloat()))
end)

-- Receive data if we are playing
net.Receive("jukebox.isplaying", function()
	-- We are no longer playing
	Cure.Jukebox.IsPlayingSong = false

	-- Remove data
	Cure.Jukebox.CurrentSong = {}

	-- Html
	gDeathrunJukebox:PlayURL("nothing", 0, 0)
end)

-- Receive data of a new song
net.Receive("jukebox.addsong", function()
	-- Get data
	local data = net.ReadTable()

	-- Check data
	if (data) then
		-- Add
		Cure.Jukebox.AddSong(data.title, data.length, data.link)

		-- Sort
		table.SortByMember(Cure.Jukebox.Songs, "title", function(a, b) return a > b end)
	end
end)

-- Queue
net.Receive("jukebox.queue", function()
	-- Get data
	local data = net.ReadTable()

	-- Make this work with jukebox:SetTable function
	for k, v in pairs(data) do
		Cure.Jukebox.Queue[k] = {link = v}
	end
end)

-- Reset songs
net.Receive("jukebox.clearsongs", function()
	Cure.Jukebox.Songs = {}
end)

net.Receive("jukebox.networksongs", function()
	-- Get data
	local data = net.ReadTable()

	-- Data
	if (data) then
		Cure.Jukebox.AddSong(data.title, data.length, data.link)
	end
end)