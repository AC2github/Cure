--[[
	Kill notifications

	- Credits:
		- AC²

	- Note:
	Prbly not the best way of doing stuff
--]]

-- Store them
local deathnotifications = {}

-- Get count
function GM:GetDeathNotificationCount()
	return (#deathnotifications or 0)
end

-- Add a new one
function GM:AddDeathNotifcation(client, lenght)
	-- Get data
	local playerdata = net.ReadTable()
	local colordata = net.ReadTable()

	-- Get count
	local notify = Cure:GetDeathNotificationCount() + 1

	-- Create
	deathnotifications[notify] = vgui.CreateFromTable(NOTIFICATION)
	deathnotifications[notify]:SetData({playerdata.one, playerdata.text, playerdata.two})

	-- Ignore colors if non exist
	if not (colordata == nil) then
		deathnotifications[notify]:SetColors({colordata.one, colordata.two, colordata.three})
	end

	-- Recalculate where the pos
	local function CalculatePos()
		-- Ignore the first one
		if not (notify == 1) then
			-- Valid check
			if (deathnotifications[notify]) then
				-- Stop if removing, doesn't count
				if (deathnotifications[notify].IsRemoving) then return end

				-- Calculate
				local x, y = deathnotifications[notify-1]:GetPos()

				-- Set
				deathnotifications[notify]:SetPos(x, y + 50)
			end
		else
			-- Another valid check
			if (deathnotifications[notify]) then
				-- Set first
				deathnotifications[notify]:SetPos(ScrW() - deathnotifications[notify]:GetTotalLength(), 10)
			end
		end
	end

	-- Add a new one
	table.insert(deathnotifications, deathnotifications[notify])

	-- Calculate where to place it
	CalculatePos()

	-- Calculate aswell
	deathnotifications[notify].OnRemove = function()
		-- Remove from list
		table.remove(deathnotifications, 1)

		-- Update keys
		local t = {}
		table.Merge(deathnotifications, t)

		-- Reset
		deathnotifications = t

		-- Calculate
		CalculatePos()
	end
end
net.Receive("deathrun.killnotifications", GAMEMODE.AddDeathNotifcation)

