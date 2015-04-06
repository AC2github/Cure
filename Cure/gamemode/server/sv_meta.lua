local meta = FindMetaTable( "Player" )
if not (meta) then return end

util.AddNetworkString("cure.chatprint")

-- Override alive
meta.OldAlive = meta.OldAlive or meta.Alive
function meta:Alive()
	if (self:Team() == TEAM_SPECTATOR) then return false end
	return self:OldAlive()
end

-- Override chatprint
-- Function chatbox
meta.OldChatPrint = meta.OldChatPrint or meta.ChatPrint
function meta:ChatPrint(str, icon)
	net.Start("cure.chatprint")
		net.WriteString(str)
		net.WriteString(icon or "icon16/world.png")
	net.Send(self)
end

-- Fucks chatbox
function meta:ParseName()
	return Cure.NoParse(self:Name())
end

-- See if a player is a spectator
function meta:IsSpectator()
	return (self:Team() == TEAM_SPECTATOR)
end

-- See if a player is afk
function meta:IsAway()
	return self.IsAFK
end
