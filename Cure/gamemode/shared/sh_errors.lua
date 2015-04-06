
Cure.Error = {}

TYPE_ERROR = 1
TYPE_MAP = 2
TYPE_SHOP = 3

file.CreateDir( "cure" )
file.CreateDir( "cure/errors" )
file.CreateDir( "cure/errors/lua" )
file.CreateDir( "cure/errors/mapvote" )
file.CreateDir( "cure/errors/shop" )

Cure.Error.Types = {

	-- Lua
	[TYPE_ERROR] = function(time, str)
		if (file.Exists( "cure/errors/lua/"..time..".txt", "DATA")) then
			file.Append( "cure/errors/lua/"..time..".txt", str.."\n")
		else
			file.Write( "cure/errors/lua/"..time..".txt", str.."\n")
		end
	end,
	
	-- Mapvote
	[TYPE_MAP] = function(time, str)
		if (file.Exists( "cure/errors/mapvote/"..time..".txt", "DATA")) then
			file.Append( "cure/errors/mapvote/"..time..".txt", str.."\n")
		else
			file.Write( "cure/errors/mapvote/"..time..".txt", str.."\n")
		end
	end,
	
	-- Store
	[TYPE_SHOP] = function(time, str)
		if (file.Exists( "cure/errors/shop/"..time..".txt", "DATA")) then
			file.Append( "cure/errors/shop/"..time..".txt", str.."\n")
		else
			file.Write( "cure/errors/shop/"..time..".txt", str.."\n")
		end
	end
}

-- Print
function Cure.Error.Print( str )
	if (CLIENT) then MsgN("[ERROR]: " .. str ) end
	if (SERVER) then print("[ERROR]: ".. str ) end
end

-- Log them
function Cure.Error.Log( str, error_type )
	local time = os.date("%d%m%y")
	
	-- Log it
	if (Cure.Error.Types[error_type]) then
		Cure.Error.Types[error_type](time, str)
	end
		
	Cure.Error.Print( "Logged error to file." )
end