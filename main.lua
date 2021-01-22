display.setStatusBar( display.HiddenStatusBar )
system.activate( "multitouch" )

-- Global Requires
composer = require("composer")
widget = require "widget"
UDim2 = require("bin.UDim2")

composer.recycleAutomatically = true
composer.recycleOnSceneChange = true

display.setDefault( "anchorX", 0 )
display.setDefault( "anchorY", 0 )

-- Global Cross Scene Data Table
Data = {
	UID = "",
    Connection = nil,
    BroadcastPort = 9125,
    GamePort = 9126,
    UserName = "MyUserName",
    ServerName = "MyServerName",
}

-- Global functions
function Button(Text, EventHandler, size, position)
    local size = size.out()
    local position = position.out()

    local Butn = widget.newButton({
        label = Text,
        onEvent = EventHandler,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = size.x,
        height = size.y,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    })
    Butn.x = position.x
 	Butn.y = position.y
 	return Butn
end

function GotoScene( SceneName, Effect, Time, DataPass )
    return composer.gotoScene( SceneName, { effect=Effect, time=Time, params=DataPass } )
end

-- load first scene
local titleScene = GotoScene( "scenes.MainMenu", "fade", 0, { nil } )