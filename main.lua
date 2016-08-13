-- 
-- Abstract: Hello World sample app, using native iOS font 
-- To build for Android, choose an available font, or use native.systemFont
--
-- Version: 1.2
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
------------------------------------------------------------

-- local background = display.newImage( "world.jpg", display.contentCenterX, display.contentCenterY )

-- local myText = display.newText( "Hello, World!", display.contentCenterX, display.contentWidth / 4, native.systemFont, 40 )
-- myText:setFillColor( 1, 110/255, 110/255 )
local flickedThreshold = 20
local parentGroupObject = display.newGroup()
local background = display.newImage( parentGroupObject, "word.jpg", display.contentCenterX, display.contentCenterY )
local platform = display.newImage( parentGroupObject, "icon.png", display.contentCenterX, display.contentCenterY )

local ball = display.newImage(parentGroupObject, "Icon-76.png", display.contentCenterX, display.contentCenterY )

transition.scaleTo( platform, {xScale = 5, yScale = 5 , time = 4000} )


local ballCurrentX = display.contentCenterX
local ballCurrentY = display.contentCenterY
function setBallCurrent(x, y)
	ballCurrentX = x
	ballCurrentY = y
end

function getFlickedDirection(prevX, prevY, curX, curY)
	if (curX > prevX and math.abs(curY - prevY) <= flickedThreshold) then
			return "R"
	elseif(curX < prevX and math.abs( curY - prevY ) <= flickedThreshold) then
			return "L"
	elseif(curY > prevY and math.abs( curX - prevX ) <= flickedThreshold) then
			return "D"
	elseif(curY < prevY and math.abs( curX - prevX ) <= flickedThreshold) then
			return "U"
	else
		return "NOTHING"
 	end	
end

function getTheSectionToTransitionTo(posX, posY)
	-- body
end

function transitionBox(posX, posY)
	transition.moveTo( ball, {x = posX, y = posY, time = 100} )
end

local function onFlicked( event )

    if ( event.phase == "began" ) then
    elseif ( event.phase == "moved" ) then
    elseif ( event.phase == "ended" ) then
        local flickedDirection = getFlickedDirection(event.xStart, event.yStart, event.x, event.y)
        if (flickedDirection ~= "NOTHING") then
        	transitionBox(event.x, event.y)
        end
    end
    return true  -- Prevents tap/touch propagation to underlying objects
end

parentGroupObject:addEventListener( "touch", onFlicked )
