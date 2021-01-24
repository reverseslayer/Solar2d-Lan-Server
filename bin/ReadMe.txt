---------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- Client -----------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

function Client.StartFind( Port )
	-- Starts searching for avalible servers
end

function Client.onFound( Ip, ServerName ) -- EVENT
	-- Must setup in client code
	-- Event fired when StartFind Finds a server
	-- Fires once per unique Server
end

function Client.StopFind()
	-- Stops searching for avalible servers
	-- returns list of found servers { ipAddress, ServerName }
end

---------------------------------------------------------------------------------------------------------------------------------

function Client.StartClient( Ip, Port )
	-- Connects to the server at specified ip
	-- returns connection handler Conn
end

	Conn.UID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"		-- The users unique Id, Gets set automatically by the server

	function Conn.SendTo( UserIDorUSERNAME, Function, Arguments )
		-- Sends a command to the specified user via UserName or UID
	end

	function Conn.Send( Function, Arguments )
		-- Sends a command to all the clients
	end

	-- NOTE : In-order to set a client user name on the server send the function => SetUserName with the Arguments => 'username'
	-- EX : Conn.Send("SetUserName", {"reverseslayer"})

	function Conn.onReceive( Function, Arguments ) -- EVENT
		-- Gets the function and Arguments that the server called for the client to perform
		-- Arguments will be a table if more than one or else will always return as a string
		-- Must setup in client code
		-- Event fired when receiving data from the server
	end

	function Conn.onDisconnect( ErrorMsg ) -- Event
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

	function Conn.SendTo( UserIDorUSERNAME, Function, Arguments )
		-- Sends a command to the clients with the unique id UID calling the function via function function with Arguments via Arguments table
	end

	function Conn.Send( Function, Arguments )
		-- Sends a command to all clients calling the function via function function with Arguments via Arguments table
	end
	
	function Conn.onReceive( Function, Arguments, From ) -- EVENT
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

---------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------- Vector2 -----------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

function Vector2.new( x, y )
	-- returns a v2 obj
end

	v2.x -- X vector size
	v2.y -- Y vector size

	function v2.Magnitude()
		-- returns the length of the vector2
	end

	function v2.Unit()
		-- returns the v2 of the same direction with a length of 1
	end

	function v2:Lerp( goal, alpha )
		-- alpha is 0 - 1
		-- returns the distance between v2 and vector2 goal by the percent alpha
		-- Ex. vector2.new(0, 0).Lerp(vector2.new(4, 4), 0.5) => gives you Vector2(2, 2)
	end

	function v2:Dot( otherV2 )
		-- returns the dot product of the 2 vector2's
	end

	-- Supported math

	Vector2 + Vector2
	Vector2 - Vector2
	vector2 * vector2
	vector2 / vector2
	vector2 * number
	vector2 / number

---------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------- Vector3 -----------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

function Vector3.new( x, y, z )
	-- returns a v3 obj
end

	v3.x -- X vector size
	v3.y -- Y vector size
	v3.z -- Z vector size

	function v3.Magnitude()
		-- returns the length of the vector2
	end

	function v3.Unit()
		-- returns the v2 of the same direction with a length of 1
	end

	function v3:Lerp( goal, alpha )
		-- alpha is 0 - 1
		-- returns the distance between v3 and vector3 goal by the percent alpha
		-- Ex. vector3.new(0, 0, 0).Lerp(vector3.new(4, 6, 8), 0.5) => gives you Vector2(2, 3, 4)
	end

	function v3:Dot( otherV3 )
		-- returns the dot product of the 2 vector3's
	end

	function v3:Cross( otherV3 )
		-- body
	end

	-- Supported math

	Vector3 + Vector3
	Vector3 - Vector3
	vector3 * vector3
	vector3 / vector3
	vector3 * number
	vector3 / number

---------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------- UDim2 -----------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

function UDim2.new( xScale, xOffset, yScale, yOffset )
	-- returns a UD2 object
end

function UDim2:FromOffset( xO, yO )
	-- Same as calling => UDim2.new(0, xO, 0, yO)
end

function UDim2:FromScale( xS, yS )
	-- Same as calling => UDim2.new(xS, 0, yS, 0)
end

	UD2.xScale  -- (0 - 1) where 0 is all the way on the left of the screen and 1 is all the way to the right of the screen
	UD2.xOffset -- the pixel offset in the x direction
	UD2.yScale  -- (0 - 1) where 0 is all the way on the top of the screen and 1 is all the way on the bottom of the screen
	UD2.yOffset -- the pixel offset in the x direction

	UD2.x -- The output from the (screenWidth * xScale) + xOffset
	UD2.y -- The output from the (screenHeight * yScale) + yOffset

	function UD2:Lerp( goal, alpha )
		-- alpha is 0 - 1
		-- returns the distance between v2 and vector2 goal by the percent alpha
		-- Ex. vector3.new(0, 0, 0).Lerp(vector3.new(4, 6, 8), 0.5) => gives you Vector2(2, 3, 4)
	end

---------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- Colors -----------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

function Colors.Rgb2Hsv( r, g, b )
	-- returns h, s, v
end

function Colors.Hsv2Rgb( h, s, v )
	-- returns r, g, b
end

function Colors.Str2Rgba( string )
	-- string formatted as #ffffffff
	-- returns r, g, b, a
end

function Colors.Rgba2Str( r, g, b, a )
	-- returns string formatted as #rrggbbaa
end

function Colors.Str2Rgb( string )
	-- string formatted as #ffffff
	-- returns r, g, b
end

function Colors.Rgb2Str( r, g, b )
	-- returns new string formatted as #rrggbb
end

---------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- Perspective ------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

function  Perspective.CreateView( layerCount )
	-- returns a paralax object Para with the number of paralax layers from layerCount
end

	function Para:setBounds( xMin, xMax, yMin, yMax )
		-- Sets how big the cameras viewpoint is

--		-----xMin----
--		|			|
--	   yMin		   yMax
--		|			|
--		-----xMax----
	end

	function Para.appendLayer()
		-- Creates a new layer Lay
	end

		function Lay:setCameraOffset( x, y )
			-- Offsets the layer to the camera via x, y
		end

	function Para:Add( Obj, Layer, isFocus )
		-- Adds a display object to a layer
		-- isFocus sets if the camera watches this object
		-- returns obj
	end

		function obj:toLayer( newLayer )
			-- Move an object to a layer
		end
		
		function obj:back()
			--Move an object back a layer
		end
		
		function obj:forward()
			--Moves an object forwards a layer
		end
		
		function obj:toCameraFront()
			--Moves an object to the very front of the camera
		end
		
		function obj:toCameraBack()
			--Moves an object to the very back of the camera
		end
		
		function obj:getPosition()
			--Returns objects paralaxed position {x, y}
		end

	function Para:TrackFocus()
		-- performs a single frame track focus
		-- makes the isFocus object the center of the screen
	end

	function Para:track()
		-- Begin auto-tracking
	end
	
	function Para:cancel()
		-- Stop auto-tracking
	end
	
	function Para:remove(obj)
		-- Remove an object from the Para
	end
	
	function Para:setFocus(obj)
		-- Set the view's focus
	end
	
	function Para:snap()
		-- Snap the view to the focus point
	end
	
	function Para:toPoint(x, y)
		-- Move the view to a point
	end
	
	function Para:layer(n)
		-- Get a layer of the Para
		-- returns Lay
	end
	
	function Para:destroy()
		-- Destroy the view
	end
	
	function Para:setParallax(...)
		-- Set layer parallax
	end
	
	function Para:layerCount()
		-- Get number of layers
	end

---------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------- base64 --------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

function base64:encode(input)
	-- returns a base64 encoded string
end

function base64:decode(input)
	-- returns a string from an encoded base64 string
end