---------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- Client -----------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

function Client.StartFind(port)
	-- Starts searching for avalible servers
end

function Client.onFound(Ip, ServerName) -- EVENT
	-- Must setup in client code
	-- Event fired when StartFind Finds a server
	-- Fires once per unique Server
end

function Client.StopFind()
	-- Stops searching for avalible servers
	-- returns list of found servers { ipAddress, ServerName }
end

---------------------------------------------------------------------------------------------------------------------------------

function Client.StartClient(Ip, Port)
	-- Connects to the server at specified ip
	-- returns connection handler Conn
end

	Conn.UID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"		-- The users unique Id, Gets set automatically by the server

	function Conn.SendTo(UserIDorUSERNAME, Function, Arguments)
		-- Sends a command to the specified user via UserName or UID
	end

	function Conn.Send(Function, Arguments)
		-- Sends a command to all the clients
	end

	-- NOTE : In-order to set a client user name on the server send the function => SetUserName with the Arguments => 'username'
	-- EX : Conn.Send("SetUserName", {"reverseslayer"})

	function Conn.onReceive(Function, Arguments) -- EVENT
		-- Gets the function and Arguments that the server called for the client to perform
		-- Arguments will be a table if more than one or else will always return as a string
		-- Must setup in client code
		-- Event fired when receiving data from the server
	end

	function Conn.onDisconnect(errorMsg) -- Event
		-- Fires if the client looses connection to the server
	end

	function Conn.StopClient()
		-- Stops the connection to the server
		-- Garbage collects the Client
	end

---------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- Server -----------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

function Server.StartAdvertise( ServerName, Port )
	-- Starts advertising the server for Client.StartFind() to find the server
end

function Server.StopAdvertise()
	-- Stops advertising the server
end

---------------------------------------------------------------------------------------------------------------------------------

function Server.StartServer( UserName, Port )
	-- Starts the server
	-- returns connection handler Conn
end

	Conn.UID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"		-- The Hosts UID

	function Conn.SendTo(UserIDorUSERNAME, Function, Arguments)
		-- Sends a command to the clients with the unique id UID calling the function via function function with Arguments via Arguments table
	end

	function Conn.Send(Function, Arguments)
		-- Sends a command to all clients calling the function via function function with Arguments via Arguments table
	end
	
	function Conn.onReceive(Function, Arguments, From) -- EVENT
		-- Gets the function and Arguments that the server called for the client to perform
		-- Arguments will be a table if more than one or else will always return as a string
		-- Must setup in client code
		-- Event fired when receiving data from the client identified by UID
		-- From is the username that is attatched to the connection set by SetUserName function
	end

	-- NOTE : when the client send the function Conn.Send("SetUserName", {"username"}) to the server the function Conn.onReceive("UserJoined", {"username"}) on the host

	function Conn.StopServer()
		-- Stops the server
		-- Garbage collects server
	end