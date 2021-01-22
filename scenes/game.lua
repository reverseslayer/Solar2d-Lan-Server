local composer = require( "composer" )
local physics = require("physics")
local scene = composer.newScene()

local displayObjs = {}
local Throwables = {}

local out

local cubeSize = UDim2.new(0, 0, 0.1, 0).out()
function Data.Connection.onReceive(funct, args) -- This is for the game, this onReceive overrides the one in both host menu and lobby
    if funct == "NewObj" then
        Throwables[args[1]] = display.newRect( args[2], args[3], cubeSize.y, cubeSize.y )
        Throwables[args[1]].Throwable = true
        physics.addBody( Throwables[args[1]], "dynamic" )
    elseif funct == "SetPos" then
        local obj = Throwables[args[1]]
        if obj then
            print("objFound")
            obj.x = args[2]
            obj.y = args[3]
        end
    end
end

function Data.Connection.onDisconnect(errorMsg)
    Data.Connection = nil
    GotoScene( "scenes.MainMenu", "fade", 0, { nil } )
end

function scene:create( event )
    local sceneGroup = self.view

    physics.start( )

    out = display.newText( "default", 50, 50, display.contentWidth, 50, native.systemFont, 12 )

    local size = UDim2.new(0, 50, 1, 0).out()
    local pos = UDim2.new(0, -50, 0, 0).out()
    displayObjs["LeftWall"] = display.newRect( pos.x , pos.y, size.x, size.y )
    physics.addBody( displayObjs["LeftWall"], "static")

    local size = UDim2.new(0, 50, 1, 0).out()
    local pos = UDim2.new(1, 0, 0, 0).out()
    displayObjs["RightWall"] = display.newRect( pos.x , pos.y, size.x, size.y )
    physics.addBody( displayObjs["RightWall"], "static")

    local size = UDim2.new(1, 0, 0, 50).out()
    local pos = UDim2.new(0, 0, 1, 0).out()
    displayObjs["Floor"] = display.newRect( pos.x , pos.y, size.x, size.y )
    physics.addBody( displayObjs["Floor"], "static")
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 		
        if Data.Connection.IsHost then
            for i=1, 30 do
                pos = UDim2.new(math.random( 10, 90 )/100, 0, math.random( 10, 90 )/100, 0).out() -- Create random spawn points
                Data.Connection.Send("NewObj", { i, pos.x, pos.y })         -- Send the points to everyone else
                Data.Connection.onReceive("NewObj", { i, pos.x, pos.y })    -- Perform the task locally
            end

            function gameLoop()
            
                for i,v in pairs(Throwables) do
                    Data.Connection.Send("SetPos", { i, v.x, v.y })         -- Send the points to everyone else
                end

            end

            timer.performWithDelay( 100, gameLoop, 0 )
        end

    elseif ( phase == "did" ) then

    end
end
 
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
 
    end
end

function scene:destroy( event ) -- Use to reset everything back to default values
    local sceneGroup = self.view

    for i,v in pairs(displayObjs) do
    	if (type(v) == "table") then
    		display.remove(v)
    	end
    end
 
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
return scene