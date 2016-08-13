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
local current_state = 13
local gridSize = 5
function stateGenerator(grip)
	local states = {}
	local width = display.contentWidth/grip
	local height = display.contentHeight/grip
	local x = {}
	local y = {}
	x[0] = width/2
	y[0] = height/2
	local i = 1
	while i < grip do
		x[i] = x[i-1] + width
		y[i] = y[i-1] + height
		i = i+1
	end
	local i = 0
	while i < grip^2 do
		local temp = {}
		temp[0] = x[(i%grip)]
		temp[1] = y[math.floor(i/grip)]
		-- print(math.floor(i/grip))
		states[i+1] = temp
		-- print(i, temp[0], temp[1])
		i = i + 1
	end
	return states
end
-- print(display.contentWidth, display.contentHeight)
local generatedStates = stateGenerator(gridSize)
-- local i = 0
-- while i < 9 do
-- 	print(generatedStates[i+1][0], generatedStates[i+1][1])
-- 	i = i+1
-- end

local flickedThreshold = 20
local parentGroupObject = display.newGroup()
local background = display.newImage( parentGroupObject, "world.jpg", display.contentCenterX, display.contentCenterY )
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

function getTheSectionToTransitionTo(direction)
 	if ( (direction == "U") and (current_state > gridSize )) then
 		current_state = current_state - gridSize
 	elseif (direction == "D" and current_state <= gridSize * (gridSize - 1)) then
 		current_state = (current_state + gridSize)
 	elseif (direction == "R" and current_state%gridSize ~= 0) then
 		current_state = current_state + 1
 	elseif (direction == "L" and current_state%gridSize ~= 1) then
 		current_state = current_state -1
 	end
	temp = {}
	temp["x"] = generatedStates[current_state][0]
	temp["y"] = generatedStates[current_state][1]
	return temp
end

function transitionBox(posX, posY)
	transition.moveTo( ball, {x = posX, y = posY, time = 100} )
end

local function onFlicked( event )

    if ( event.phase == "began" ) then
    elseif ( event.phase == "moved" ) then
    elseif ( event.phase == "ended" ) then
        local flickedDirection = getFlickedDirection(event.xStart, event.yStart, event.x, event.y)
        print( flickedDirection )

        if (flickedDirection ~= "NOTHING") then
        	print( flickedDirection )
        	local coord = getTheSectionToTransitionTo(flickedDirection)
        	print( coord["x"], coord["y"] )
        	transitionBox(coord["x"], coord["y"])
        end
    end
    return true  -- Prevents tap/touch propagation to underlying objects
end

parentGroupObject:addEventListener( "touch", onFlicked )