
-- dem tables
Cure.Notify = {}
Cure.Notify.DrawTable = {}

-- insert a message
function Cure.Notify.Add(str, duration)
	if (#Cure.Notify.DrawTable >= 8) then
		table.remove(Cure.Notify.DrawTable, 1)
	end

	table.insert(Cure.Notify.DrawTable,{text = str, duration = (duration + CurTime())})
end

-- Draw notifactions
function Cure.Notify.Draw()
	-- don't do anything when table is empty
	if (#Cure.Notify.DrawTable == 0) then return end
	
	-- vars
	local text, duration = Cure.Notify.DrawTable[1].text, Cure.Notify.DrawTable[1].duration
	local fadetime = CurTime() + 255
	local changetime = math.Approach(255, 0, fadetime + CurTime())
	print(changetime)
	local time = CurTime()

	-- Remove it when time has expired
	if (time > duration) then
		table.remove(Cure.Notify.DrawTable, 1)
		fadetime = CurTime() + 255
	end
	
	draw.SimpleText(text, "Trebuchet24", (ScrW() / 2), (ScrH() / 2 - 150), Color(255, 255, 255, changetime))
end
