local votemaps = {}

local function CreateVoteMenu()
	ADB.Menu.RemoveMenu()
	
	local votetime = CurTime( ) + 30
	local menu = vgui.Create("iNFrame")
	menu:SetTitle("Vote")
	menu:SetSubTitle("Vote for a map")
	menu:SetSize(700, 295)
	menu:Initialize()
	menu:ShowCloseButton(close)
	menu:MakePopup()
	
	for k,v in pairs(votemaps) do
		local button = vgui.Create("iNPanel")
		button:SetText(v.id)
		button:SetSubText("Vote for "..v.id)
		button:SetDisabled(false)
		button:SetTall(50)
		button.DoClick = function()
			RunConsoleCommand("cure_vote", k)
			surface.PlaySound("buttons/button14.wav")
			menu:Exit()
		end
		
		menu:Add(button)
	end
	
	function menu:MenuThink()
		menu:SetTitle( "Vote ("..math.Round(votetime - CurTime())..")")
		
		if votetime - CurTime( ) <= 0 then
			menu:Exit()
		end
	end
end

net.Receive( "votemaps", function(len)
	votemaps = net.ReadTable()
	CreateVoteMenu()
end)