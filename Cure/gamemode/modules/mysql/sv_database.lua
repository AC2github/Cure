--[[
	Mysql wrapper

	Credits:
		- AC : Code
--]]

Cure.Database = {}
Cure.Database.Queue = {}

-- Easy
local database = Cure.Database

-- We need the module
require("mysqloo")

-- Custom error.
function Cure.Database.Error(err, log)
	if not (err) then return end
	print( "[Cure.Database] " .. err )
end

-- See if we have actuall data in the query
function Cure.Database.IsValidData(data)
	-- We have data
	if (data) and (data[1]) then return true end

	-- Nothing, :C
	return false
end

-- Make stuff safe.
function Cure.Database.Escape(str)
	-- See if we have a string
	if not (str) or not (database.DB) then return end
	
	-- make it escape
	return database.DB:escape(str)
end

-- Actually connects to the database
function Cure.Database.Connect()
	-- Make the object
	database.DB = mysqloo.connect("localhost", "root", "", "deathrun", 3306)
	database.Ready = false
	database.DB:connect()
	database.Error("Connecting to the Database...")
	
	-- Successfull connect
	function database.DB:onConnected()
		database.Error("Connected to the Database")
		database.Ready = true
		
		-- Run queries that didn't get send
		if (Cure.Database.Queue) and (#Cure.Database.Queue > 0) then
			local count = 0
			
			for k, v in pairs(Cure.Database.Queue) do
				if (v.query) then
					Cure.Database.Query(tostring(v.query), v.callback)
					Cure.Database.Queue[k] = nil
					count = count + 1
				end
			end
			
			database.Error("Send a total of "..count.." queries.")
		end
		
		-- Create our sql tables
		Cure.Database.Query([[CREATE TABLE IF NOT EXISTS cure_bans (id int NOT NULL AUTO_INCREMENT PRIMARY KEY, name text, steamid varchar(30), steamid64 varchar(64), reason text, time int, type int, ip varchar(40), admin text)]])
		Cure.Database.Query([[CREATE TABLE IF NOT EXISTS cure_admins (id int NOT NULL AUTO_INCREMENT PRIMARY KEY, name text, steamid varchar(30), steamid64 varchar(64), rank varchar(11), server text)]])
		Cure.Database.Query([[CREATE TABLE IF NOT EXISTS deathrun_player_awards(id text, name text, steamid varchar(20))]])
		Cure.Database.Query([[CREATE TABLE IF NOT EXISTS deathrun_player_stats (id text, value text, steamid varchar(20))]])
		Cure.Database.Query([[CREATE TABLE IF NOT EXISTS deathrun_player_shopitems (steamid varchar(20), id text, name text, trade boolean, attributes text, quality text, color text, effect text)]])
		Cure.Database.Query([[CREATE TABLE IF NOT EXISTS deathrun_player_shop (steamid varchar(20), name text, money int, hat text, trail text, model text, tag text, taunt text)]])
	end
	
	-- It failed
	function database.DB:onConnectionFailed(err)
		-- notify error
		database.Error(err, true)
	
		-- We are not ready
		self.Ready = false
		
		-- Try to reconnect in 30 seconds
		timer.Simple( 30, function()
			Cure.Database.Connect()
		end)
		
		-- Console
		database.Error("Could not connect to the database, check if your login is correct.")
	end
end

-- Send a query, optional callback
function Cure.Database.Query( query, callback )
	-- Cache our string
	local query_sql = query
	
	if not (database.DB) or not (database.Ready) then
		table.insert(Cure.Database.Queue, {["query"] = tostring(query_sql), ["callback"] = callback})
		
		if not (database.DB) then
			database.Connect()
		end
		
		return
	end
	
	-- object
	local query = database.DB:query(query)
	
	-- query failed
	function query:onError(sql, er)
		-- first check the database connection
		if (Cure.Database.DB:status() ~= mysqloo.DATABASE_CONNECTED) then
			table.insert(Cure.Database.Queue, {["query"] = tostring(query_sql), ["callback"] = callback})
			Cure.Database.Connect()
			return
		end
		
		Cure.Database.Error(sql.. " failed with error " ..er, true)
	end
	
	-- query success
	function query:onSuccess(data)
		if (callback) then
			callback(data)
		end
	end

	query:start()
end

hook.Add("Initialize", "Cure.Database.Connect", function()
	Cure.Database.Connect()
end)