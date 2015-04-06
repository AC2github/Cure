-- Handles those keys on your screen
-- Copied from deathrun, not by me

Cure.Keys = {}

util.AddNetworkString( "_KeyPress" )
util.AddNetworkString( "_KeyRelease" )

local WantKeys = {}
WantKeys[IN_JUMP] = true
WantKeys[IN_MOVELEFT] = true
WantKeys[IN_MOVERIGHT] = true
WantKeys[IN_DUCK] = true
WantKeys[IN_BACK] = true
WantKeys[IN_FORWARD] = true

function Cure.Keys.LogPress( ply, key )
	if not WantKeys[key] then return end

	local spec = Cure.Spectator.GetSpectating(ply)
	if #spec < 1 then return end

	net.Start( "_KeyPress" )
		net.WriteEntity( ply )
		net.WriteInt( key, 16 )
	net.Send( spec )
end

function Cure.Keys.KeyPress( ply, key )
	if not IsValid(ply) then return end

	if ply:Alive() then 
		Cure.Keys.LogPress( ply, key )
		return 
	end
end

function Cure.Keys.KeyRelease( ply, key )
	if not WantKeys[key] then return end

	local spec = Cure.Spectator.GetSpectating(ply)
	if #spec < 1 then return end

	net.Start( "_KeyRelease" )
		net.WriteEntity( ply )
		net.WriteInt( key, 16 )
	net.Send( spec )
end