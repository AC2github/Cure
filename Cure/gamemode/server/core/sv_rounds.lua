
-- Set round time
function Cure.Rounds.SetRoundTime(roundtime)
	SetGlobalInt("roundtime", (CurTime() + (roundtime or 5) or 5))
	SetGlobalInt("roundtime.unchanged", roundtime)
end

-- Set Round phase
function Cure.Rounds.SetRoundPhase(roundphase)
	SetGlobalInt("roundphase", roundphase)
end

-- Total rounds
function Cure.Rounds.SetTotalRounds(rounds)
	TOTAL_ROUNDS = rounds
end

-- only called once
Cure.Rounds.Functions = {
	-- Not enough players
	[ROUND_WAITING] = function()
		Cure.Rounds.SetRoundTime(0)
	end,
	
	-- Cleanup
	[ROUND_PREPARE] = function()
		game.CleanUpMap()
		
		for k, v in pairs(player.GetAll()) do
			v:Freeze(true)
		end
		
		if (Cure.Rounds.GetTotalRounds() <= 0) then
			game.ConsoleCommand("changelevel "..Cure.MapVote.Nextmap.."\n")
		end
		
		Cure.Rounds.SetRoundTime(5)
	end,
	
	-- Start
	[ROUND_ACTIVE] = function()
		Cure.Rounds.SetRoundTime(300)
		
		for k, v in pairs(player.GetAll()) do
			v:Freeze(false)

			if (v:Team() == TEAM_RUNNER) then
				Cure:SendNotifcation(v, "Round has begun", "Get to the end of the map and kill death", 2, 1)
			else
				Cure:SendNotifcation(v, "Round has begun", "Kill all the runners", 2, 1)
			end
		end
		
		print( "Round has started" )
	end,
	
	-- End
	[ROUND_ENDING] = function(winner)
		if (type(winner) == "Player") then
			print( winner:Name() .. " has won the round" )
		else
			print( winner .." has won the round" )
		end
		
		-- Remove a round
		TOTAL_ROUNDS = TOTAL_ROUNDS - 1

		for k, v in pairs(player.GetAll()) do
			Cure:SendNotifcation(v, winner.." has won the round", TOTAL_ROUNDS.." rounds left", 2, 1)

			if (winner == "Death") then
				if (v:Team() == TEAM_DEATH) then
					Cure.Stats.Increase(v, "xp", 100)
				end
			else
				if (v:Team() == TEAM_RUNNER) then
					Cure.Stats.Increase(v, "xp", 500)
				end
			end	
		end
		
		-- Map vote!
		if (Cure.Rounds.GetTotalRounds() == 1) then
			Cure.MapVote.Start()
		end
		
		print( TOTAL_ROUNDS .. " rounds left." )
		
		-- Small wait time
		Cure.Rounds.SetRoundTime(5)

		-- Reset to default
		Cure.Events.SetActiveEvent("default")

		-- Change mode
		if (math.random(1, 1) == 1) then
			Cure.Events.SetActiveEvent(table.Random(Cure.Events.Data).ID)
		end
	end
}

-- functions
Cure.Rounds.ThinkFunctions = {
	
	-- Need more players
	[ROUND_WAITING] = function()
		if (#player.GetAll() < 2) then return end
		Cure.Rounds.SetRound(ROUND_PREPARE)
	end,
	
	-- Prepare
	[ROUND_PREPARE] = function()
		if (Cure.Rounds.GetRoundTime() <= 0) then
			Cure.Rounds.SetRound(ROUND_ACTIVE)
		end
	end,
	
	-- Playing
	[ROUND_ACTIVE] = function()
		if (Cure.Rounds.GetRoundTime() <= 0) then
			Cure.Rounds.SetRound(ROUND_ENDING, "Nobody")
			return
		end
		
		local players_team1 = team.NumPlayers(Cure.Team.Teams[1].id)
		local players_team2 = team.NumPlayers(Cure.Team.Teams[2].id)
		
		if (players_team1 == 0) then
			Cure.Rounds.SetRound(ROUND_ENDING, team.GetName(Cure.Team.Teams[2].id))
		elseif (players_team2 == 0) then
			Cure.Rounds.SetRound(ROUND_ENDING, team.GetName(Cure.Team.Teams[1].id))
		end
	end,
	
	-- End of round
	[ROUND_ENDING] = function()
		if (Cure.Rounds.GetRoundTime() <= 0) then
			Cure.Rounds.SetRound(ROUND_PREPARE)
			return
		end
	end
}

-- Set round phase
function Cure.Rounds.SetRound(roundphase, ... )
	if not (Cure.Rounds.Functions[roundphase]) then return end
	
	-- Get arguments
	local args = {...}
	
	-- Set stuff
	Cure.Rounds.SetRoundPhase(roundphase)
	
	-- Call a custom hook
	hook.Call("OnRoundSet", GAMEMODE, roundphase, unpack(args))
	
	-- Do other functions
	Cure.Rounds.Functions[roundphase](unpack(args))
end

-- Called every frame
function Cure.Rounds.Think()
	local round = Cure.Rounds.GetRoundPhase()
	
	-- When someone leaves
	if (round != ROUND_WAITING) then
		if (#player.GetAll() < 2) then
			Cure.Rounds.SetRoundPhase(ROUND_WAITING)
			return
		end
	end
	
	-- call functions
	if (Cure.Rounds.ThinkFunctions[round]) then
		Cure.Rounds.ThinkFunctions[round](self)
	end
end