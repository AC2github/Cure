
local PlayerVoicePanels = {}

-- Called when you start talking
function Cure:PlayerStartVoice(ply)
	-- Valid check
	if not (ply:IsValid()) then return end

	-- There'd be an exta one if voice_loopback is on, so remove it.
	GAMEMODE:PlayerEndVoice(ply)

	local i = #PlayerVoicePanels + 1
	PlayerVoicePanels[i] = {}

	-- Create
	PlayerVoicePanels[i].Panel = vgui.Create("deathrun.vgui.voicepanel")
	PlayerVoicePanels[i].Panel:SetPlayer(ply)
	PlayerVoicePanels[i].Player = ply

	-- Pos
	if (i == 1) then
		PlayerVoicePanels[i].Panel:SetPos(ScrW() - 300, ScrH() - 100)

		print("ONLY ONE PANEL")
	else
		local x, y = PlayerVoicePanels[i-1].Panel:GetPos()
		PlayerVoicePanels[i].Panel:SetPos(x, y - 55) 
	end
	
	print("PANELS: "..i)
	print(ply)
end

-- Remove invalid panels
local function VoiceClean()
	for k, v in pairs(PlayerVoicePanels) do
		if not (IsValid(v.Panel)) then
			GAMEMODE:PlayerEndVoice(v.Player)
		end
	end
end
timer.Create( "VoiceClean", 10, 0, VoiceClean)

-- Called when you stop talking
function Cure:PlayerEndVoice(ply)
	-- Loop
	for k, v in pairs(PlayerVoicePanels) do
		-- Find
		if (v.Player == ply) then
			-- Remove
			PlayerVoicePanels[k].Panel:Remove()
			PlayerVoicePanels[k] = nil

			-- Stop
			break
		end
	end
end
