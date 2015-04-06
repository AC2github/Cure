
Cure.Rounds = {}

-- Enums
ROUND_WAITING = 1 
ROUND_PREPARE = 2 
ROUND_ACTIVE = 3 
ROUND_ENDING = 4 

-- How many rounds
TOTAL_ROUNDS = 15

-- Get round phase
function Cure.Rounds.GetRoundPhase()
	return GetGlobalInt( "roundphase" )
end

-- Get round time
function Cure.Rounds.GetRoundTime()
	return math.Round(math.max( GetGlobalInt( "roundtime" ) - CurTime(), 0 ))
end

-- Get total rounds
function Cure.Rounds.GetTotalRounds()
	return TOTAL_ROUNDS or 15
end