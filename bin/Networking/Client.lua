local socket = require( "socket" )  -- Connection to socket library
local JSON = require("json")

local function connectToServer( ip, port )
    local sock, err = socket.connect( ip, port )
    if sock == nil then
        return false
    end
    sock:settimeout( 0 )
    sock:setoption( "tcp-nodelay", true )  --disable Nagle's algorithm
    return sock
end

local function getIP()
    local s = socket.udp()  --creates a UDP object
    s:setpeername( "74.125.115.104", 80 )  --Google website
    local ip, sock = s:getsockname()
    return ip
end

local function Split(inputstr, sep)
    if inputstr ~= nil then
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        if #t == 1 then
            return t[1]
        else
            return t
        end
    end
end

local function BuildFunction(Function, Args)
    local builder = Function.."|"
    if type(Args) == "table" then
        for i,v in pairs(Args) do
            builder = builder..v.."/"
        end
        builder = string.sub( builder, 1, string.len( builder ) - 1 )
        builder = builder.."\n"
    else
        builder = builder..Args.."\n"
    end
    return builder
end

local Client = {}

    ServerBroadcastFinder = nil
    FindSock = nil
    FoundServers = {}
    Client.StartFind = function( port )
        FoundServers = {}
        if ServerBroadcastFinder == nil then
            local connectionMessage = "M1sT0xS3rv3r"

            FindSock = socket.udp()
            if system.getInfo( "environment" ) == "simulator" then -- if isEditor then
                assert(FindSock:setsockname( getIP(), port ))
            else
                assert(FindSock:setsockname( "239.1.1.234", port ))
                assert(FindSock:setoption( "ip-add-membership", { multiaddr="239.1.1.234", interface = getIP() } ))
            end

            FindSock:settimeout(0)

            local function look()
                repeat
                    local data, ip, port = FindSock:receivefrom()
                    if data then
                        local conMsg = string.sub(data, 1, 12)
                        local sName = string.sub(data, 13)
                        if conMsg == connectionMessage then
                            if not FoundServers[ip] then
                                FoundServers[ip] = {ip, sName}
                                if Client.onFound ~= nil then Client.onFound( ip, sName ) end
                            end
                        end
                    end
                until not data
             end
         
             ServerBroadcastFinder = timer.performWithDelay( 100, look, 0 )
         end
    end

    Client.StopFind = function()
        timer.cancel( ServerBroadcastFinder )
        ServerBroadcastFinder = nil
        FindSock:close()
        FindSock = nil
        return FoundServers
    end

    Client.StartClient = function( ip, port )

        local Ctrl = {}
        Ctrl.UID = ""
        Ctrl.IsHost = false
        Ctrl.ClientSock =  connectToServer( ip, port )
        Ctrl.SendBuffer = {}

        Ctrl.SendTo = function(UIDorUserName, Function, Args)
            table.insert( Ctrl.SendBuffer, UID.."|"..BuildFunction(Function, Args) )
        end

        Ctrl.Send = function(Function, Args)
            table.insert( Ctrl.SendBuffer, ".|"..BuildFunction(Function, Args) )
        end

        Ctrl.StopClient = function()
            timer.cancel( Ctrl.clientPulse )
            Ctrl.clientPulse = nil
            if type(Ctrl.ClientSock) ~= "boolean" then
                Ctrl.ClientSock:close()
            end
            Ctrl.ClientSock = nil
        end

        local function cPulse()

            local allData = {}
            local data, err
     
            -- Receive
            repeat
                data, err = Ctrl.ClientSock:receive()
                if data then
                    table.insert( allData, data )
                end
                if ( err == "closed" and Ctrl.clientPulse ) then
                    Ctrl.ClientSock = connectToServer( ip, port )
                    if type(Ctrl.ClientSock) ~= "boolean" then
                        data, err = Ctrl.ClientSock:receive()
                        if data then
                            table.insert( allData, data )
                        end
                    else
                        if Ctrl.onDisconnect ~= nil then Ctrl.onDisconnect(err) end
                        Ctrl.StopClient()
                    end
                end
            until not data
     
            if ( #allData > 0 ) then
                for i, thisData in ipairs( allData ) do
                    local FunctionSeperator = Split(thisData, "|")
                    local funct = FunctionSeperator[1]
                    -- Check to see if args is a string or table or nil
                    local args
                    if FunctionSeperator[2] ~= nil then
                        args = Split( FunctionSeperator[2], "/")
                    end
                    if funct == "SetUID" then
                        Ctrl.UID = args[1]
                    else
                        if Ctrl.onReceive ~= nil then Ctrl.onReceive( funct, args ) end
                    end
                end
            end
            
            for i, msg in pairs( Ctrl.SendBuffer ) do
                local data, err = Ctrl.ClientSock:send(msg)
                if ( err == "closed" and clientPulse ) then
                    Ctrl.ClientSock = connectToServer( ip, port )
                    data, err = Ctrl.ClientSock:send( msg )
                end
                table.remove( Ctrl.SendBuffer, i )
            end
        end

        Ctrl.clientPulse = timer.performWithDelay( 100, cPulse, 0 )

        return Ctrl
    end

return Client