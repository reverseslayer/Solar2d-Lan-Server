local composer = require( "composer" )
local scene = composer.newScene()

local buttons = {}

function scene:create( event )
    local sceneGroup = self.view

    function buildUsers(userList)
        if type(userList) == "string" then
            local x = Button(userList, nil, UDim2.new(0.9, 0, 0, 70), UDim2.new(0.05, 0, 0, 10) )
            table.insert( buttons, x )
        else
            for i,v in pairs(buttons) do
                display.remove(v)
            end
            for i,v in pairs(userList) do
                local x = Button(v, nil, UDim2.new(0.9, 0, 0, 70), UDim2.new(0.05, 0, 0, (i*80)-70 ))
                if v == Data.UserName then
                    x:setFillColor( 0, 1, 0) 
                end
                table.insert( buttons, x )
            end
        end
    end

    function Data.Connection.onReceive(funct, args)
        if funct == "UserJoined" then -- Fires when HostMenu sends back a list of all the users, each time a new user is added
            buildUsers(args)
        elseif funct == "Start" then -- When HostMenu fires Start game send the user to the game
            GotoScene( "scenes.game", "fade", 0, { nil } )
        end
    end

    function onLeaveClick(event)
    	if (event.phase == "ended") then
    		GotoScene( "scenes.JoinMenu", "fade", 0, { nil } )
    	end
    end
    local LeaveButton = Button("Leave Lobby", onLeaveClick, UDim2.new(0.9, 0, 0.2, 0), UDim2.new(0.05, 0, 0.7, 0))
    table.insert( sceneGroup, LeaveButton )

    Data.Connection.Send("SetUserName", Data.UserName) -- Sets the username and tells the server you joined successfully server will fire back "UserJoined" with a list of all the other users in the server
end

function scene:destroy( event ) -- Use to reset everything back to default values
    local sceneGroup = self.view

    for i,v in pairs(sceneGroup) do
        if (type(v) == "table") then
            display.remove(v)
        end
    end

    for i,v in pairs(buttons) do
            display.remove(v)
        end
 	
end


scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )
 
return scene