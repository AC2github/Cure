
Cure.Spectator = {}

-- Easy
Cure.Spectator.Keys = {
	-- Left mouse
	[IN_ATTACK] = function( player )
		local target = Cure.Player.GetPrevPlayer( player:GetObserverTarget() )
		
		if (IsValid(target)) then
			player:Spectate( OBS_MODE_CHASE )
			player:SpectateEntity( target )
			player.SpectatorMode = OBS_MODE_CHASE
			
			SendUserMessage("spectator", player, target)
		end
	end,
	
	-- Right Mouse
	[IN_ATTACK2] = function( player )
		local target = Cure.Player.GetNextPlayer( player:GetObserverTarget() )
		
		if (IsValid(target)) then
			player:Spectate( OBS_MODE_CHASE )
			player:SpectateEntity( target )
			player.SpectatorMode = OBS_MODE_CHASE
			
			SendUserMessage("spectator", player, target)
		end
	end,
	
	-- Reload
	[IN_RELOAD] = function( player )
		local target = player:GetObserverTarget()
		if not IsValid(target) or not (target:IsPlayer()) then return end
		
		-- Change mode
		if (player.SpectatorMode == OBS_MODE_CHASE) then
			player.SpectatorMode = OBS_MODE_IN_EYE
		elseif (player.SpectatorMode == OBS_MODE_IN_EYE) then
			player.SpectatorMode = OBS_MODE_CHASE
		end
		
		player:Spectate( player.SpectatorMode )
		
		if not (target == player) then
			SendUserMessage("spectator", player, target)
		end
	end,
	
	-- Jump
	[IN_JUMP] = function( player )
		player:Spectate( OBS_MODE_ROAMING )
		SendUserMessage("spectator", player, nil)
	end,
	
	-- Duck
	[IN_DUCK] = function( player )
		player:Spectate( OBS_MODE_ROAMING )
		SendUserMessage("spectator", player, nil)
	end
}

-- Copied from deathrun
function Cure.Spectator.GetSpectating( ply ) 
	local tab = {}

	for k, v in pairs( player.GetAll() ) do
		if v:GetObserverTarget() == ply then
			tab[#tab+1] = v
		end
	end

	return tab
end

function Cure.Spectator.KeyPress(player, key)
	if not (player:Alive()) then
		if (Cure.Spectator.Keys[key]) then
			Cure.Spectator.Keys[key]( player )
		end
	end
end
