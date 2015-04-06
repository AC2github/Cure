
-- Store
Cure.Team = {}
Cure.Team.Suicide = {}
Cure.Team.Speed = {}
Cure.Team.Weapons = {}
Cure.Team.Teams = {}
Cure.Team.EnableCollisions = false

-- Simple check
function Cure.Team.HasWon(teamid)
	if (team.NumPlayers(teamid) >= 1) then return true end
	return false
end

-- Register team
function Cure.Team.RegisterTeam(teamid, name)
	Cure.Team.Teams[#Cure.Team.Teams+1] = { ["id"] = teamid, ["name"] = name }
end

-- Disable player killing themself
function Cure.Team.PreventSuicide(teamid)
	table.insert(Cure.Team.Suicide, teamid)
end

-- Team collisions
function Cure.Team.SetTeamCollisionEnabled(bool)
	Cure.Team.EnableCollisions = bool
end

-- Set speed
function Cure.Team.SetSpeed(teamid, speed)
	Cure.Team.Speed[teamid] = speed
end

-- Give weapons
function Cure.Team.GiveWeapons(teamid, ...)
	local args = {...}
	
	Cure.Team.Weapons[teamid] = args
end