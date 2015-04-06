-- table
local dicetable = {}

-- outcomes
dicetable[1] = function(ply)
        Cure.Player.PrintAll("[LOSE]: "..ply:Name().." has raped by the dice!")
        ply:SetHealth(1)
end

dicetable[2] = function(ply)
        Cure.Player.PrintAll("[WIN]: "..ply:Name().." restored some health!")
        ply:SetHealth(100)
end

dicetable[3] = function(ply)
        Cure.Player.PrintAll("[LOSE]: "..ply:Name().." was killed!")
        ply:Kill()
        XPM.Unlock(ply, "achv_death_rtd")
end

dicetable[4] = function(ply)
        Cure.Player.PrintAll("[WIN]: "..ply:Name().." won a speed boost!")
        ply:SetWalkSpeed(ply:GetWalkSpeed() + 25)
end

dicetable[5] = function(ply)
        Cure.Player.PrintAll("[LOSE]: "..ply:Name().." was slapped by the dice!")
        ply:TakeDamage(math.random(1, 50))
        ply:SetVelocity(Vector(0, 0, 500))
end

dicetable[6] = function(ply)
        Cure.Player.PrintAll("[WIN]: "..ply:Name().." won some armor!")
        ply:SetArmor(25)
end

local function RollTheDice(ply)
        if (ply:Team() == TEAM_SPECTATOR) or not (ply:Alive()) then
                ply:ChatPrint("You can't roll the dice when you're dead.")
                return
        end
        
        -- Var
        if not (ply.LastRoll) then
                ply.LastRoll = CurTime()
        end
        
        -- Simple check
        if (ply.LastRoll <= CurTime()) then
                ply.LastRoll = CurTime() + 80
                
                local randomresult = math.random(1, #dicetable)

                dicetable[randomresult](ply)
        else
                ply:ChatPrint("You need to wait "..math.Round(ply.LastRoll - CurTime()).." seconds before you can roll again!")
        end
end
Cure.AddChatCommand("!rtd", RollTheDice, true)
Cure.AddChatCommand("rtd", RollTheDice, true)