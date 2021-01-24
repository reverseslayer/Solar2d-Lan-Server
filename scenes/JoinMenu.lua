local composer = require( "composer" )
local Client = require( "bin.Networking.Client" )
local scene = composer.newScene()

function scene:create( event )
    local sceneGroup = self.view
    sceneGroup.Buttons = {}

    Client.onFound = function(ip, name) -- Fires on the client finding a server

        local function onclick(event)
            if (event.phase == "ended") then
                Client.StopFind()
                Data.Connection = assert(Client.StartClient(ip, Data.GamePort)) -- Connect the client to the server, add to the global data table
                GotoScene( "scenes.Lobby", "fade", 0, { nil } ) -- Goto the lobby screen (wait area)
            end
        end

        local but = Button(name, onclick, UDim2.new(0.8, 0, 0, 40), UDim2.new(0.1, 0, 0, (#sceneGroup.Buttons*50+50) ) )
        table.insert( sceneGroup.Buttons, but )
    end

    -----------------------------------------------------
    --                 Back Button                     --
    -----------------------------------------------------

    function onBackClick(event)
        if (event.phase == "ended") then
            Client.StopFind()
            GotoScene( "scenes.MainMenu", "fade", 0, { nil } ) -- Goto the game scene
        end
    end

    local Back = Button("Back", onBackClick, UDim2.new(0.9, 0, 0.2, 0), UDim2.new(0.05, 0, 0.7, 0))
    table.insert( sceneGroup, Back )

    Client.StartFind(Data.BroadcastPort) -- Start looking for avalible servers
end

function scene:destroy( event )
    local sceneGroup = self.view

    for i,v in pairs(sceneGroup.Buttons) do
        display.remove(v)
    end

    sceneGroup.Buttons = nil

    for i,v in pairs(sceneGroup) do
        if (type(v) == "table") then
            display.remove(v)
        end
    end
 	
end


scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )
 
return scene