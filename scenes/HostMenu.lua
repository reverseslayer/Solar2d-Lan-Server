local composer = require( "composer" )
local Server = require( "bin.Networking.Server" )
local scene = composer.newScene()

local mServer = nil

function scene:create( event )
    local sceneGroup = self.view
    sceneGroup.Buttons = {}

    Server.StartAdvertise( Data.ServerName, Data.BroadcastPort ) -- Give server a name and make avalible
    Data.Connection = Server.StartServer(Data.UserName, Data.GamePort) -- Start the game server
    
    local users = {Data.UserName} -- Place to store user names of connected users, with hosts username defined 

    local x = Button(users[1], nil, UDim2.new(0.9, 0, 0, 70), UDim2.new(0.05, 0, 0, 80 ))
    x:setFillColor( 0, 1, 0) 
    table.insert( sceneGroup.Buttons, x )

    function Data.Connection.onReceive(funct, args, from) -- When the server receives data this event fires
        if funct == "UserJoined" then -- when the SetUserName function is fired
            table.insert( users, args[1] )
            for i,v in pairs(sceneGroup.Buttons) do
                display.remove(v)
            end
            for i, v in pairs(users) do
                local x = Button(v, nil, UDim2.new(0.9, 0, 0, 70), UDim2.new(0.05, 0, 0, (i*80) ))
                table.insert( sceneGroup.Buttons, x )
            end
            Data.Connection.Send("UserJoined", users) -- Send the full list of all connected users back to each user
        end
    end

    -----------------------------------------------------
    --                Start Button                     --
    -----------------------------------------------------

    function onStartClick(event)
        if (event.phase == "ended") then
            Server.StopAdvertise()
            Data.Connection.Send("Start", {"1"}) -- Send the clients the game start command
            GotoScene( "scenes.game", "fade", 0, { nil } ) -- Goto the game scene
        end
    end

    local Start = Button("Start Game", onStartClick, UDim2.new(0.4, 0, 0.2, 0), UDim2.new(0.066, 0, 0.7, 0))
    table.insert( sceneGroup, Start )

    -----------------------------------------------------
    --                 Back Button                     --
    -----------------------------------------------------

    function onBackClick(event)
        if (event.phase == "ended") then
            Server.StopAdvertise()
            GotoScene( "scenes.MainMenu", "fade", 0, { nil } ) -- Goto the game scene
        end
    end

    local Back = Button("Back", onBackClick, UDim2.new(0.4, 0, 0.2, 0), UDim2.new(0.533, 0, 0.7, 0))
    table.insert( sceneGroup, Back )

end

function scene:destroy( event ) -- Use to reset everything back to default values
    local sceneGroup = self.view

    for i,v in pairs(sceneGroup) do
        if (type(v) == "table") then
            display.remove(v)
        end
    end

    for i,v in pairs(sceneGroup.Buttons) do
        print("fired on", v)
        display.remove(v)
    end
 	
end

scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )
 
return scene