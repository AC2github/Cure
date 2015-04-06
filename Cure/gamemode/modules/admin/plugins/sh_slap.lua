local PLUGIN = {}
PLUGIN.ID = "slap" -- unique id
PLUGIN.Name = "Slap" -- Name for in the menu
PLUGIN.Author = "massi-gear"
PLUGIN.Console = "slap" -- console command
PLUGIN.Help = "Slap players - !slap <name>"
PLUGIN.Chat = "!slap" -- Chat command
PLUGIN.Flag = "slap" -- flag required
     
 function PLUGIN:Call(ply, args)
	-- Find a target
	local target = Cure.Admin.FindPlayer(args[1])
	local slapvelocity = math.random(100, 200)
           
    -- Couldn't find him
    if not (target) then
		ply:ChatPrint( "Could not find player.")
        return
    end
	
	-- dead
	if not (target:Alive()) then 
		Cure.Admin.NotifyPlayer(ply, color_white, "Target is dead.")
		return
	end
	
	-- immunity
	if not (Cure.Admin.RankCanTarget(ply:GetRank(), target:GetRank())) then
		Cure.Admin.NotifyPlayer(ply, color_white, "Target their rank is higher than yours.")
		return
	end
	       
     -- Kill him
     if (target:IsValid()) then
		target:TakeDamage(0)
        target:SetVelocity(Vector(slapvelocity,slapvelocity,slapvelocity))
        Cure.Admin.NotifyAll(color_red, "[ADMIN] ", color_blue, ply:Name(), color_white, " slapped player ", color_red, target:Name(), color_white, ".")
		Cure.Error.Log("[ADMIN] "..ply:Name().." ran command slap on "..target:Name(), TYPE_ADMIN)
     end
end
     
-- Register plugin
Cure.Admin.RegisterPlugin(PLUGIN)