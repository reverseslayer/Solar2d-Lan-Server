local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
    local sceneGroup = self.view

    function onHostClick(event)
        if (event.phase == "ended") then
            GotoScene( "scenes.HostMenu", "fade", 0, { nil } ) -- Goto the Host setup screen
        end
    end
    local host = Button("Host a game", onHostClick, UDim2.new(0.5, 0, 0.2, 0), UDim2.new(0.25, 0, 0.1, 0))
    table.insert( sceneGroup, host )

    function onSearchClick(event)
    	if (event.phase == "ended") then
    		GotoScene( "scenes.JoinMenu", "fade", 0, { nil } ) -- Goto the Client setup screen
    	end
    end
    local search = Button("Join a game", onSearchClick, UDim2.new(0.5, 0, 0.2, 0), UDim2.new(0.25, 0, 0.4, 0))
    table.insert( sceneGroup, search )

end

function scene:destroy( event ) -- Use to reset everything back to default values
    local sceneGroup = self.view

    for i,v in pairs(sceneGroup) do
        if (type(v) == "table") then
            display.remove(v)
        end
    end
 	
end


scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )
 
return scene