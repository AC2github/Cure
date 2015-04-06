
--- Create dirs
file.CreateDir("cure")
file.CreateDir("cure/errors")
file.CreateDir("cure/admin")
file.CreateDir("cure/store")
file.CreateDir("cure/store_trade")
file.CreateDir("cure/store_craft")
file.CreateDir("cure/mysql")
file.CreateDir("cure/chat")
file.CreateDir("cure/connections")

-- Enums
TYPE_LUA = 1
TYPE_ADMIN = 2
TYPE_STORE = 3
TYPE_STORE_TRADE = 4
TYPE_STORE_CRAFT = 5
TYPE_MYSQL = 6
TYPE_CHAT = 7
TYPE_CONNECT = 8

-- Type of logs
local errorstrings = {}
errorstrings[TYPE_LUA] = "[LUA LOG]"
errorstrings[TYPE_ADMIN] = "[ADMIN LOG]"
errorstrings[TYPE_STORE] = "[STORE LOG]"
errorstrings[TYPE_STORE_TRADE] = "[STORE TRADE LOG]"
errorstrings[TYPE_STORE_CRAFT] = "[STORE CRAFT LOG]"
errorstrings[TYPE_MYSQL] = "[MYSQL LOG]"
errorstrings[TYPE_CHAT] = "[CHAT LOG]"
errorstrings[TYPE_CONNECT] = "[CONNECT LOG]"

-- Network
util.AddNetworkString("Cure.logs")

-- Tables
Cure.Error = {}

-- Keep logs
local logs = {}

Cure.Error.Types = {
	-- Lua
	[TYPE_LUA] = function(time, str)
		if (file.Exists("cure/errors/"..time..".txt", "DATA")) then
			local contents = file.Read("cure/errors/"..time..".txt", "DATA")
			str = contents.."\n"..str
			
			file.Append("cure/errors/"..time..".txt", str)
		else
			file.Write("cure/errors/"..time..".txt", str)
		end
	end,
	
	-- Admin
	[TYPE_ADMIN] = function(time, str)
		if (file.Exists("cure/admin/"..time..".txt", "DATA")) then
			local contents = file.Read("cure/admin/"..time..".txt", "DATA")
			str = contents.."\n"..str
			
			file.Write("cure/admin/"..time..".txt", str)
		else
			file.Write("cure/admin/"..time..".txt", str)
		end
	end,
	
	-- Store
	[TYPE_STORE] = function(time, str)
		if (file.Exists("cure/store/"..time..".txt", "DATA")) then
			local contents = file.Read("cure/store/"..time..".txt", "DATA")
			str = contents.."\n"..str
			
			file.Write("cure/store/"..time..".txt", str)
		else
			file.Write("cure/store/"..time..".txt", str)
		end
	end,
	
	-- Store trade
	[TYPE_STORE_TRADE] = function(time, str)
		if (file.Exists("cure/store_trade/"..time..".txt", "DATA")) then
			local contents = file.Read("cure/store_trade/"..time..".txt", "DATA")
			str = contents.."\n"..str
			
			file.Write("cure/store_trade/"..time..".txt", str)
		else
			file.Write("cure/store_trade/"..time..".txt", str)
		end
	end,
	
	-- Store craft
	[TYPE_STORE_CRAFT] = function(time, str)
		if (file.Exists("cure/store_craft/"..time..".txt", "DATA")) then
			local contents = file.Read("cure/store_craft/"..time..".txt", "DATA")
			str = contents.."\n"..str
			
			file.Write("cure/store_craft/"..time..".txt", str)
		else
			file.Write("cure/store_craft/"..time..".txt", str)
		end
	end,
	
	-- Database
	[TYPE_MYSQL] = function(time, str)
		if (file.Exists("cure/mysql/"..time..".txt", "DATA")) then
			local contents = file.Read("cure/mysql/"..time..".txt", "DATA")
			str = contents.."\n"..str
			
			file.Write("cure/mysql/"..time..".txt", str)
		else
			file.Write("cure/mysql/"..time..".txt", str)
		end
	end,

	-- Chat
	[TYPE_CHAT] = function(time, str)
		if (file.Exists("cure/chat/"..time..".txt", "DATA")) then
			local contents = file.Read("cure/chat/"..time..".txt", "DATA")
			str = contents.."\n"..str
			
			file.Write("cure/chat/"..time..".txt", str)
		else
			file.Write("cure/chat/"..time..".txt", str)
		end
	end,

	-- Connect
	[TYPE_CONNECT] = function(time, str)
		if (file.Exists("cure/connections/"..time..".txt", "DATA")) then
			local contents = file.Read("cure/connections/"..time..".txt", "DATA")
			str = contents.."\n"..str
			
			file.Write("cure/connections/"..time..".txt", str)
		else
			file.Write("cure/connections/"..time..".txt", str)
		end
	end
}

-- Print
function Cure.Error.Print(str)
	if (CLIENT) then MsgN("[Cure] " .. str ) end
	if (SERVER) then print("[Cure] ".. str ) end
end

-- Send logs to admins
function Cure.Error.SendLog(ply, log)
	net.Start("Cure.logs", ply)
		net.WriteString(log)
	net.Send(ply)
end

-- Send initialize logs
function Cure.Error.SendAllLogs(ply)
	for k,v in pairs(logs) do
		net.Start("cure.logs", ply)
			net.WriteString(v)
		net.Send(ply)
	end
end

-- Log errors
function Cure.Error.Log(str, error_type)
	if not (str) then return end
	
	local time = os.date("%d%m%y")
	str = "["..os.date("%X").."] " .. str
	
	-- Log it
	if (Cure.Error.Types[error_type]) then
		Cure.Error.Types[error_type](time, str)
	end
		
	Cure.Error.Print(Format("Logged "..(errorstrings[error_type] or "[UNKNOW LOG]").." with contents %s.", str))
	
	table.insert(logs, str)
	
	for k, v in pairs(player.GetAll()) do
		if (v:IsSuperAdmin()) then
			Cure.Error.SendLog(v, str)
		end
	end
end