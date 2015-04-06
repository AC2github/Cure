
Cure.Stats = {}
Cure.Stats.Data = {}

-- Register a valid stat
function Cure.Stats.Add(id)
        table.insert(Cure.Stats.Data, {id = id})
end
 
-- Check if a stat is valid
function Cure.Stats.IsValid(id)
        -- Simple loop
        for k, v in pairs(Cure.Stats.Data) do
                if (v.id == id) then
                        return true
                end
        end
 
        -- Nope
        return false
end
 
-- Add whatever you want to track here
Cure.Stats.Add("deaths")
Cure.Stats.Add("timeplayed")
Cure.Stats.Add("damage")
Cure.Stats.Add("wins")
Cure.Stats.Add("loses")
Cure.Stats.Add("headshots")
Cure.Stats.Add("kills")
Cure.Stats.Add("xp")