--[[
    All data for achievements

    Credits:
        - AC²
--]]

Cure.Achievements = {}

-- Data
Cure.Achievements.Data = {}
Cure.Achievements.Handlers = {}
 
-- enums
ACHIEVEMENTS_CATEGORY_LEVEL = 1
ACHIEVEMENTS_CATEGORY_WINS = 2
ACHIEVEMENTS_CATEGORY_LOSES = 3
ACHIEVEMENTS_CATEGORY_KILL = 4
ACHIEVEMENTS_CATEGORY_DEATHS = 5
ACHIEVEMENTS_CATEGORY_DAMAGE = 6
ACHIEVEMENTS_CATEGORY_TIME = 7
ACHIEVEMENTS_CATEGORY_SHOP = 8
ACHIEVEMENTS_CATEGORY_MISC = 9

ACHIEVEMENTS_CATEGORY_SECRET = 11
 
-- Categories
Cure.Achievements.Categories = {}
Cure.Achievements.Categories[ACHIEVEMENTS_CATEGORY_LEVEL] = "Level"
Cure.Achievements.Categories[ACHIEVEMENTS_CATEGORY_WINS] = "Wins"
Cure.Achievements.Categories[ACHIEVEMENTS_CATEGORY_LOSES] = "Loses"
Cure.Achievements.Categories[ACHIEVEMENTS_CATEGORY_KILL] = "Kills"
Cure.Achievements.Categories[ACHIEVEMENTS_CATEGORY_DEATHS] = "Deaths"
Cure.Achievements.Categories[ACHIEVEMENTS_CATEGORY_DAMAGE] = "Damage"
Cure.Achievements.Categories[ACHIEVEMENTS_CATEGORY_TIME] = "Time"
Cure.Achievements.Categories[ACHIEVEMENTS_CATEGORY_SHOP] = "Shop"
Cure.Achievements.Categories[ACHIEVEMENTS_CATEGORY_MISC] = "Misc"
Cure.Achievements.Categories[ACHIEVEMENTS_CATEGORY_SECRET] = "Secrets"
 
-- Add an achievement
function Cure.Achievements.Add(id, name, desc, reward, category, preview, paintover)
        table.insert(Cure.Achievements.Data, {id = id, name = name, desc = desc, reward = reward, category = category, image = Material(preview) or "missing", paintover = paintover or nil})
end
 
-- Check if an achievement exists
function Cure.Achievements.IsValid(id)
        -- Simple loop
        for k, v in pairs(Cure.Achievements.Data) do
                if (v.id == id) then
                        return true
                end
        end
 
        -- Nope
        return false
end
 
-- Gets results from the data table
function Cure.Achievements.GetData(id)
        -- Simple check
        if not (Cure.Achievements.IsValid(id)) then return {} end
 
        -- Simple loop
        for k, v in pairs(Cure.Achievements.Data) do
                if (v.id == id) then
                        return v
                end
        end
 
        -- Shit
        return {}
end

-- Create all trackers of stats for achievements
-- Cure.Achievements.Handlers["deaths"] = {} etc
for k, v in pairs(Cure.Stats.Data) do
    Cure.Achievements.Handlers[v.id] = {}
end

-- Level handler
Cure.Achievements.Handlers["level"] = {}
 
-- Handlers for "kill x player" thingies
Cure.Achievements.Handlers["deaths"][1] = {deaths = 25, achv = "achv_deaths1"}
Cure.Achievements.Handlers["deaths"][2] = {deaths = 100, achv = "achv_deaths2"}
Cure.Achievements.Handlers["deaths"][3] = {deaths = 250, achv = "achv_deaths3"}
Cure.Achievements.Handlers["deaths"][4] = {deaths = 1000, achv = "achv_deaths4"}
 
Cure.Achievements.Handlers["wins"][1] = {wins = 10, achv = "achv_win1"}
Cure.Achievements.Handlers["wins"][2] = {wins = 25, achv = "achv_win2"}
Cure.Achievements.Handlers["wins"][3] = {wins = 100, achv = "achv_win3"}
Cure.Achievements.Handlers["wins"][4] = {wins = 500, achv = "achv_win4"}
Cure.Achievements.Handlers["wins"][5] = {wins = 1000, achv = "achv_win5"}
Cure.Achievements.Handlers["wins"][6] = {wins = 5000, achv = "achv_win6"}
 
Cure.Achievements.Handlers["damage"][1] = {damage = 10000, achv = "achv_damage1"}
Cure.Achievements.Handlers["damage"][2] = {damage = 50000, achv = "achv_damage2"}
Cure.Achievements.Handlers["damage"][3] = {damage = 100000, achv = "achv_damage3"}
Cure.Achievements.Handlers["damage"][4] = {damage = 500000, achv = "achv_damage4"}
Cure.Achievements.Handlers["damage"][5] = {damage = 1000000, achv = "achv_damage5"}
 
Cure.Achievements.Handlers["kills"][1] = {kills = 10, achv = "achv_kills1"}
Cure.Achievements.Handlers["kills"][2] = {kills = 25, achv = "achv_kills2"}
Cure.Achievements.Handlers["kills"][3] = {kills = 75, achv = "achv_kills3"}
Cure.Achievements.Handlers["kills"][4] = {kills = 250, achv = "achv_kills4"}
Cure.Achievements.Handlers["kills"][5] = {kills = 500, achv = "achv_kills5"}
Cure.Achievements.Handlers["kills"][6] = {kills = 1000, achv = "achv_kills6"}

for i = 1, 20 do
    Cure.Achievements.Handlers["level"][i*5] = {level = i*5, achv = "achv_level"..(i*5)}
end
 
Cure.Achievements.Handlers["timeplayed"][1] = {timeplayed = 60, achv = "achv_time1"}
Cure.Achievements.Handlers["timeplayed"][2] = {timeplayed = 120, achv = "achv_time2"}
Cure.Achievements.Handlers["timeplayed"][3] = {timeplayed = 300, achv = "achv_time3"}
Cure.Achievements.Handlers["timeplayed"][4] = {timeplayed = (60 * 24), achv = "achv_time4"}
Cure.Achievements.Handlers["timeplayed"][5] = {timeplayed = (60 * 24) * 2, achv = "achv_time5"}
Cure.Achievements.Handlers["timeplayed"][6] = {timeplayed = (60 * 24) * 7, achv = "achv_time6"}
Cure.Achievements.Handlers["timeplayed"][7] = {timeplayed = (60 * 24) * 30, achv = "achv_time7"}
 
 
-- Add achievements here
-- Misc
Cure.Achievements.Add("achv_ac", "MeetTheDeveloper()", "Play with AC²", 200, ACHIEVEMENTS_CATEGORY_MISC, "misc/ac")
Cure.Achievements.Add("achv_zolack", "Drunk like ZolacK", "Play with ZolacK", 200, ACHIEVEMENTS_CATEGORY_MISC, "misc/zolack")
 
-- Secrets
Cure.Achievements.Add("achv_secretphrase", "The secret","Know the secret phrase", 1000, ACHIEVEMENTS_CATEGORY_SECRET, "secret/secretphrase")
Cure.Achievements.Add("achv_saviours", "Saviours of my soul", "Have Matt and Merith playing at the same time", 1000, ACHIEVEMENTS_CATEGORY_SECRET, "secret/saviours")
Cure.Achievements.Add("achv_shit", "A win for AC", "Get Merith to say 'shit' or 'fuck'", 1000, ACHIEVEMENTS_CATEGORY_SECRET, "secret/shit")
 
-- Damage
Cure.Achievements.Add("achv_damage1", "Headache", "Deal a total of 10.000 damage to players", 1000, ACHIEVEMENTS_CATEGORY_DAMAGE, "damage/damage1")
Cure.Achievements.Add("achv_damage2", "Broken arm", "Deal a total of 50.000 damage to players", 1500, ACHIEVEMENTS_CATEGORY_DAMAGE, "damage/damage2")
Cure.Achievements.Add("achv_damage3", "Crash", "Deal a total of 100.000 damage to players", 2000, ACHIEVEMENTS_CATEGORY_DAMAGE, "damage/damage3")
Cure.Achievements.Add("achv_damage4", "Are you breathing now?", "Deal a total of 500.000 damage to players", 2500, ACHIEVEMENTS_CATEGORY_DAMAGE, "damage/damage4")
Cure.Achievements.Add("achv_damage5", "PAAAAAAIN", "Deal a total of 1.000.000 damage to players", 3000, ACHIEVEMENTS_CATEGORY_DAMAGE, "damage/damage5")
 
-- Death
Cure.Achievements.Add("achv_aaaa", "AAAAAAA YOURSELF", "Die by an explosion", 500, ACHIEVEMENTS_CATEGORY_DEATHS, "death/aaaa")
Cure.Achievements.Add("achv_firstblood", "First blood", "Be the first to die", 100, ACHIEVEMENTS_CATEGORY_DEATHS, "death/firstblood")
Cure.Achievements.Add("achv_lissy", "Sleeping Beauty", "Kill Lissy", 700, ACHIEVEMENTS_CATEGORY_DEATHS, "death/lissy")
Cure.Achievements.Add("achv_merith", "Meri Moo", "Kill Merith", 700, ACHIEVEMENTS_CATEGORY_DEATHS, "death/merith")
Cure.Achievements.Add("achv_deaths1", "I suck", "Die a total of 25 times", 250, ACHIEVEMENTS_CATEGORY_DEATHS, "death/deaths1")
Cure.Achievements.Add("achv_deaths2", "Die!", "Die a total of 100 times", 1000, ACHIEVEMENTS_CATEGORY_DEATHS, "death/deaths2")
Cure.Achievements.Add("achv_deaths3", "Cursed", "Die a total of 250 times", 2500, ACHIEVEMENTS_CATEGORY_DEATHS, "death/deaths3")
Cure.Achievements.Add("achv_deaths4", "Give your soul to me for eternity", "Die a total of 1000 times", 5000, ACHIEVEMENTS_CATEGORY_DEATHS, "death/deaths4")
 
-- Time played
Cure.Achievements.Add("achv_time1", "My first hour", "Play a total of 1 hour", 1000, ACHIEVEMENTS_CATEGORY_TIME, "time/time1")
Cure.Achievements.Add("achv_time2", "46 and 2", "Play a total of 2 hours", 2000, ACHIEVEMENTS_CATEGORY_TIME, "time/time2")
Cure.Achievements.Add("achv_time3", "Time is all we need", "Play a total of 5 hours", 5000, ACHIEVEMENTS_CATEGORY_TIME, "time/time3")
Cure.Achievements.Add("achv_time4", "24", "Play a total of 24 hours", 10000, ACHIEVEMENTS_CATEGORY_TIME, "time/time4")
Cure.Achievements.Add("achv_time5", "A few days maybe?", "Play a total of 48 hours", 20000, ACHIEVEMENTS_CATEGORY_TIME, "time/time5")
Cure.Achievements.Add("achv_time6", "7 days", "Play a total of 7 days", 70000, ACHIEVEMENTS_CATEGORY_TIME, "time/time6")
Cure.Achievements.Add("achv_time7", "I have a problem", "Play a month", 100000, ACHIEVEMENTS_CATEGORY_TIME, "time/time7")
 
-- Kills
Cure.Achievements.Add("achv_kills1", "A few shots", "Kill a total of 10 people", 600, ACHIEVEMENTS_CATEGORY_KILL, "kill/kills1")
Cure.Achievements.Add("achv_kills2", "Do the wicked see you?", "Kill a total of 25 people", 1000, ACHIEVEMENTS_CATEGORY_KILL, "kills/kills2")
Cure.Achievements.Add("achv_kills3", "Save me god", "Kill a total of 75 people", 1200, ACHIEVEMENTS_CATEGORY_KILL, "kills/kills3")
Cure.Achievements.Add("achv_kills4", "Someone is gonna die", "Kill a total of 250 peole", 2500, ACHIEVEMENTS_CATEGORY_KILL, "kills/kills4")
Cure.Achievements.Add("achv_kills5", "Indestructible", "Kill a total of 500 people", 5000, ACHIEVEMENTS_CATEGORY_KILL, "kills/kills5")
Cure.Achievements.Add("achv_kills6", "Master of war!", "Kill a total of 1000 people", 10000, ACHIEVEMENTS_CATEGORY_KILL, "kills/kills6")

--levels
Cure.Achievements.Add("achv_level5", "Noob", "Reach Level 5.", 2000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png", "9999")
Cure.Achievements.Add("achv_level10", "Beginner", "Reach Level 10.", 4000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png", "10")
Cure.Achievements.Add("achv_level15", "Better and better", "Reach Level 15.", 6000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png")
Cure.Achievements.Add("achv_level20", "I stay", "Reach Level 20.", 8000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png")
Cure.Achievements.Add("achv_level25", "1/4", "Reach Level 25.", 10000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png")
Cure.Achievements.Add("achv_level30", "Dreamer", "Reach Level 30.", 12000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png")
Cure.Achievements.Add("achv_level35", "So close, yet so far", "Reach Level 35.", 14000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png")
Cure.Achievements.Add("achv_level40", "Almost half", "Reach Level 40.", 16000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png")
Cure.Achievements.Add("achv_level45", "5%", "Reach Level 45.", 18000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png")
Cure.Achievements.Add("achv_level50", "Half way there", "Reach Level 50.", 20000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png")
Cure.Achievements.Add("achv_level55", "Getting there", "Reach Level 55.", 22000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png")
Cure.Achievements.Add("achv_level60", "My favourite number", "Reach Level 60.", 24000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png")
Cure.Achievements.Add("achv_level65", "Pee break", "Reach Level 65.", 28000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png")
Cure.Achievements.Add("achv_level70", "Almost", "Reach Level 70.", 30000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png")
Cure.Achievements.Add("achv_level75", "Coffe break", "Reach Level 75.", 32000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png")
Cure.Achievements.Add("achv_level80", "So close", "Reach Level 80.", 34000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png")
Cure.Achievements.Add("achv_level85", "Why you take so long to level?", "Reach Level 85.", 36000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png")
Cure.Achievements.Add("achv_level90", "10 more", "Reach Level 90.", 38000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png")
Cure.Achievements.Add("achv_level95", "I can almost taste it", "Reach Level 95.", 40000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png")
Cure.Achievements.Add("achv_level100", "Deathrun Master", "Reach Level 100.", 50000, ACHIEVEMENTS_CATEGORY_LEVEL, "spiceworks/achievements/level/level.png")

--wins
Cure.Achievements.Add("achv_win5", "Yes!", "Win a total of 5 times (as runner).", 1000, ACHIEVEMENTS_CATEGORY_WINS, "wins/win.png")
Cure.Achievements.Add("achv_win10", "Not bad", "Win a total of 10 times (as runner).", 1250, ACHIEVEMENTS_CATEGORY_WINS, "wins/win.png")
Cure.Achievements.Add("achv_win20", "It's a start", "Win a total of 20 times (as runner).", 1500, ACHIEVEMENTS_CATEGORY_WINS, "wins/win.png")
Cure.Achievements.Add("achv_win40", "Fast runner", "Win a total of 40 times (as runner).", 2500, ACHIEVEMENTS_CATEGORY_WINS, "wins/win.png")
Cure.Achievements.Add("achv_win75", "Run as fast as you can", "Win a total of 75 times (as runner).", 5000, ACHIEVEMENTS_CATEGORY_WINS, "wins/win.png")
Cure.Achievements.Add("achv_win100", "Pro runner", "Win a total of 100 times (as runner).", 7500, ACHIEVEMENTS_CATEGORY_WINS, "wins/win.png")
Cure.Achievements.Add("achv_win200", "Pro", "Win a total of 200 times (as runner).", 8000, ACHIEVEMENTS_CATEGORY_WINS, "wins/win.png")
Cure.Achievements.Add("achv_win500", "Elite", "Win a total of 500 times (as runner).", 9000, ACHIEVEMENTS_CATEGORY_WINS, "wins/win.png")
Cure.Achievements.Add("achv_win1000", "Hero", "Win a total of 1000 times (as runner).", 10000, ACHIEVEMENTS_CATEGORY_WINS, "wins/win.png")

--losses
Cure.Achievements.Add("achv_lose5", "You Suck!", "Lose a total of 5 times (as runner).", 1000, ACHIEVEMENTS_CATEGORY_LOSES, "losses/lose.png")
Cure.Achievements.Add("achv_lose10", "This is hard", "Lose a total of 10 times (as runner).", 1250, ACHIEVEMENTS_CATEGORY_LOSES, "losses/lose.png")
Cure.Achievements.Add("achv_lose20", "Come on you can do better then that!", "Lose a total of 20 times (as runner).", 1500, ACHIEVEMENTS_CATEGORY_LOSES, "losses/lose.png")
Cure.Achievements.Add("achv_lose40", "Quit gmod you suck", "Lose a total of 40 times (as runner).", 2500, ACHIEVEMENTS_CATEGORY_LOSES, "losses/lose.png")
Cure.Achievements.Add("achv_lose75", "You're bad!", "Lose a total of 75 times (as runner).", 5000, ACHIEVEMENTS_CATEGORY_LOSES, "losses/lose.png")
Cure.Achievements.Add("achv_lose100", "What are you doing?", "Lose a total of 100 times (as runner).", 7500, ACHIEVEMENTS_CATEGORY_LOSES, "losses/lose.png")
Cure.Achievements.Add("achv_lose200", "You arent even trying!", "Lose a total of 200 times (as runner).", 8000, ACHIEVEMENTS_CATEGORY_LOSES, "losses/lose.png")
Cure.Achievements.Add("achv_lose500", "Are you drunk?", "Lose a total of 500 times (as runner).", 9000, ACHIEVEMENTS_CATEGORY_LOSES, "losses/lose.png")
Cure.Achievements.Add("achv_lose1000", "Just leave your just to bad!", "Lose a total of 1000 times (as runner).", 10000, ACHIEVEMENTS_CATEGORY_LOSES, "losses/lose.png")