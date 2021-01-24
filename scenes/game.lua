local composer = require( "composer" )
local physics = require("physics")
local scene = composer.newScene()

local displayObjs = {}
local Throwables = {}

local throwVelocity = 1000

local cubeSize = UDim2.new(0, 0, 0.1, 0)
function Data.Connection.onReceive(funct, args) -- This is for the game, this onReceive overrides the one in both host menu and lobby
    if funct == "NewObj" then

        local focus = nil
        local function globalTouch( event )
            if event.phase == "ended" then
                local offset = Vector2.new( (event.x - event.xStart), (event.y - event.yStart) )
                if offset.Magnitude() > 10 then
                    local unit = offset.Unit()
                    event.target:setLinearVelocity( unit.x * throwVelocity, unit.y * throwVelocity )
                    Data.Connection.Send("UpdateObj", {
                        event.target.ID,
                        event.target.x,
                        event.target.y,
                        unit.x * throwVelocity,
                        unit.y * throwVelocity,
                        event.target.rotation
                    })         -- Send the points to everyone else
                end
            end
        end

        local id = tonumber(args[1])

        Throwables[id] = display.newRect( args[2], args[3], cubeSize.y, cubeSize.y )
        Throwables[id].Throwable = true
        Throwables[id].ID = id
        Throwables[id].LpX = 0
        Throwables[id].LpY = 0
        Throwables[id].Lr = 0
        Throwables[id]:addEventListener( "touch", globalTouch )
        physics.addBody( Throwables[id], "dynamic" )
    elseif funct == "UpdateObj" then
        local obj = Throwables[tonumber(args[1])]
        if obj then
            obj.x = args[2]
            obj.y = args[3]
            obj.rotation = args[6]
            obj:setLinearVelocity( args[4], args[5] )
            obj.angularVelocity = args[7]
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

    local size = UDim2.new(0, 50, 1, 0)
    local pos = UDim2.new(0, -50, 0, 0)
    displayObjs["LeftWall"] = display.newRect( pos.x , pos.y, size.x, size.y )
    physics.addBody( displayObjs["LeftWall"], "static")

    local size = UDim2.new(0, 50, 1, 0)
    local pos = UDim2.new(1, 0, 0, 0)
    displayObjs["RightWall"] = display.newRect( pos.x , pos.y, size.x, size.y )
    physics.addBody( displayObjs["RightWall"], "static")

    local size = UDim2.new(1, 0, 0, 50)
    local pos = UDim2.new(0, 0, 1, 0)
    displayObjs["Floor"] = display.newRect( pos.x , pos.y, size.x, size.y )
    physics.addBody( displayObjs["Floor"], "static")
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 		
        if Data.Connection.IsHost then
            for i=1, 30 do
                pos = UDim2.new(math.random( 10, 90 )/100, 0, math.random( 10, 90 )/100, 0) -- Create random spawn points
                Data.Connection.Send("NewObj", { i, pos.x, pos.y })         -- Send the points to everyone else
                Data.Connection.onReceive("NewObj", { i, pos.x, pos.y })    -- Perform the task locally
            end

            function gameLoop()
            
                for i,v in pairs(Throwables) do
                    local vx, vy = v:getLinearVelocity()
                    if v.LpX ~= v.x or v.LpY ~= v.y or v.Lr ~= v.rotation then
                        Data.Connection.Send("UpdateObj", { i, v.x, v.y, vx, vy, v.rotation, v.angularVelocity })         -- Send the points to everyone else
                        v.LpX = v.x
                        v.LpY = v.y
                        v.Lr = v.rotation
                    end
                end

            end

            timer.performWithDelay( 100, gameLoop, 0 ) -- perform network update once every second and perform local math inbetween
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

    for i,v in pairs(Throwables) do
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