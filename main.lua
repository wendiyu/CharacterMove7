-----------------------------------------------------------------------------------------
--
-- main.lua
-- Created by: Wendi Yu
-- Created on: May 2018
--
-- character move use the button , have gravity, add jump button, add shoot button, add sound and enemy 
-- add explosion 
-----------------------------------------------------------------------------------------

-- Gravity
local physics = require("physics")

physics.start()
physics.setGravity(0, 20)
--physics.setDrawMode("hybrid")

local playerBullets = {} -- Table that holds the players Bullets

local leftWall = display.newRect( 0, display.contentHeight / 2, 1, display.contentHeight )
-- myRectangle.strokeWidth = 3
-- myRectangle:setFillColor( 0.5 )
-- myRectangle:setStrokeColor( 1, 0, 0 )
leftWall.alpha = 1.0
physics.addBody( leftWall, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local theGround = display.newImageRect( "./assets/sprites/land.png", 1750, 150 )
theGround.x = display.contentCenterX - 190
theGround.y = display.contentCenterY + 690
theGround.id = "the ground"
physics.addBody(theGround, "static", {
	friction = 0.5,
	bounce = 0.3
	})

local theLand = display.newImageRect( "./assets/sprites/land.png", 600, 150 )
theLand.x = display.contentCenterX - 700
theLand.y = display.contentCenterY 
theLand.id = "the land"
physics.addBody(theLand, "static", {
	friction = 0.3,
	bounce = 0.2
	})

local enemy = display.newImageRect( "./assets/sprites/enemy.png", 500, 500 )
enemy.x = display.contentCenterX + 500
enemy.y = display.contentCenterY 
enemy.id = "the bad character"
physics.addBody(enemy, "dynamic", {
	friction = 0.3,
	bounce = 0.2
	})

-- Character move
local theCharacter = display.newImageRect( "./assets/sprites/ldle.png", 300, 400 )
theCharacter.x = display.contentCenterX - 400
theCharacter.y = display.contentCenterY
theCharacter.id = "the character"
physics.addBody(theCharacter, "dynamic", {
	density = 2.5,
	friction = 0.1,
	bounce = 0.2
	})
theCharacter.isFixedRotation = true -- If you apply this property before the physics.addBody() command for the object, it will merely be treated as a property of the object like any other custom property and, in that case, it will not cause any physical change in terms of locking rotation.

local dPad = display.newImageRect( "./assets/sprites/d-pad.png", 300, 300 )
dPad.x = 150
dPad.y = display.contentHeight - 160
dPad.id = "d-pad"
dPad.alpha = 0.5

local upArrow = display.newImage( "./assets/sprites/upArrow.png" )
upArrow.x = 150
upArrow.y = display.contentHeight - 270
upArrow.id = "up arrow"
upArrow.alpha = 1

local downArrow = display.newImage( "./assets/sprites/downArrow.png" )
downArrow.x = 150
downArrow.y = display.contentHeight - 50
downArrow.id = "down arrow"
downArrow.alpha = 1

local leftArrow = display.newImage( "./assets/sprites/leftArrow.png" )
leftArrow.x = 40
leftArrow.y = display.contentHeight - 160
leftArrow.id = "left arrow"
leftArrow.alpha = 1

local rightArrow = display.newImage( "./assets/sprites/rightArrow.png" )
rightArrow.x = 260
rightArrow.y = display.contentHeight - 160
rightArrow.id = "right arrow"
rightArrow.alpha = 1

local jumpButton = display.newImage( "./assets/sprites/jumpButton.png" )
jumpButton.x = display.contentWidth -80
jumpButton.y = display.contentHeight - 80
jumpButton.id = "jump button"
jumpButton.alpha = 0.5

local shootButton = display.newImage( "./assets/sprites/jumpButton.png" )
shootButton.x = display.contentWidth - 250
shootButton.y = display.contentHeight - 80
shootButton.id = "shoot button"
shootButton.alpha = 0.5

local function characterCollision( self, event )
 
    if ( event.phase == "began" ) then
        print( self.id .. ": collision began with " .. event.other.id )
 
    elseif ( event.phase == "ended" ) then
        print( self.id .. ": collision ended with " .. event.other.id )
    end
end

function checkPlayerBulletsOutOfBounds()
	-- check if any bullets have gone off the screen
	local bulletCounter

    if #playerBullets > 0 then
        for bulletCounter = #playerBullets, 1 ,-1 do
            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then
                playerBullets[bulletCounter]:removeSelf()
                playerBullets[bulletCounter] = nil
                table.remove(playerBullets, bulletCounter)
                print("remove bullet")
            end
        end
    end
end

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
        local whereCollisonOccurredX = obj1.x
        local whereCollisonOccurredY = obj1.y

        if ( ( obj1.id == "the bad character" and obj2.id == "bullet" ) or
             ( obj1.id == "bullet" and obj2.id == "bad character" ) ) then
            -- Remove both the laser and asteroid
            --display.remove( obj1 )
            --display.remove( obj2 )
 			
 			-- remove the bullet
 			local bulletCounter = nil
 			
            for bulletCounter = #playerBullets, 1, -1 do
                if ( playerBullets[bulletCounter] == obj1 or playerBullets[bulletCounter] == obj2 ) then
                    playerBullets[bulletCounter]:removeSelf()
                    playerBullets[bulletCounter] = nil
                    table.remove( playerBullets, bulletCounter )
                    break
                end
            end

            --remove character
            enemy:removeSelf()
            enemy = nil

            -- Increase score
            print ("you could increase a score here.")

            -- make an explosion sound effect
            local expolsionSound = audio.loadStream( "./assets/sounds/8bit_bomb_explosion.wav" )
            local explosionChannel = audio.play( expolsionSound )

            -- make an explosion happen
            -- Table of emitter parameters
			local emitterParams = {
			    startColorAlpha = 1,
			    startParticleSizeVariance = 250,
			    startColorGreen = 0.3031555,
			    yCoordFlipped = -1,
			    blendFuncSource = 770,
			    rotatePerSecondVariance = 153.95,
			    particleLifespan = 0.7237,
			    tangentialAcceleration = -1440.74,
			    finishColorBlue = 0.3699196,
			    finishColorGreen = 0.5443883,
			    blendFuncDestination = 1,
			    startParticleSize = 400.95,
			    startColorRed = 0.8373094,
			    textureFileName = "./assets/sprites/fire.png",
			    startColorVarianceAlpha = 0.5,
			    maxParticles = 256,
			    finishParticleSize = 320,
			    duration = 0.25,
			    finishColorRed = 1,
			    maxRadiusVariance = 72.63,
			    finishParticleSizeVariance = 250,
			    gravityy = -671.05,
			    speedVariance = 90.79,
			    tangentialAccelVariance = -420.11,
			    angleVariance = -142.62,
			    angle = -240.11
			}
			local emitter = display.newEmitter( emitterParams )
			emitter.x = whereCollisonOccurredX
			emitter.y = whereCollisonOccurredY

        end
    end
end

function upArrow:touch( event )
	-- add funtion to arrow 
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( theCharacter, { 
        	x = 0, -- move 0 in the x direction 
        	y = -50, -- move up 50 pixels
        	time = 1000 -- move in a 1/10 of a second
        	} )
    end

    return true
end

function downArrow:touch( event )
	-- add funtion to arrow 
	if ( event.phase == "ended" ) then
        -- move the character down
        transition.moveBy( theCharacter, { 
        	x = 0, -- move 0 in the x direction 
        	y = 50, -- move up 50 pixels
        	time = 1000 -- move in a 1/10 of a second
        	} )
    end 
    
    return true    
end

function leftArrow:touch( event )
	-- add funtion to arrow 
	if ( event.phase == "ended" ) then
        -- move the character left
        transition.moveBy( theCharacter, { 
        	x = -50, -- move 0 in the x direction 
        	y = 0, -- move up 50 pixels
        	time = 100 -- move in a 1/10 of a second
        	} )
    end 
    
    return true    
end

function rightArrow:touch( event )
	-- add funtion to arrow 
	if ( event.phase == "ended" ) then
        -- move the character right
        transition.moveBy( theCharacter, { 
        	x = 100, -- move 0 in the x direction 
        	y = 0, -- move up 50 pixels
        	time = 1000 -- move in a 1/10 of a second
        	} )
    end 
    
    return true    
end

function jumpButton:touch( event )
	-- add funtion to button
	if ( event.phase == "ended" ) then
        -- move the character jump
       theCharacter:setLinearVelocity( 0, -750 )
    end 
    
    return true    
end

function shootButton:touch( event )
    if ( event.phase == "began" ) then
        -- make a bullet appear
        local aSingleBullet = display.newImage( "./assets/sprites/Kunai.png" )
        aSingleBullet.x = theCharacter.x + 200
        aSingleBullet.y = theCharacter.y 
        physics.addBody( aSingleBullet, 'dynamic' )
        -- Make the object a "bullet" type object
        aSingleBullet.isBullet = true
        aSingleBullet.isFixedRotation = true
        aSingleBullet.gravityScale = 0
        aSingleBullet.id = "bullet"
        aSingleBullet:setLinearVelocity( 1500, 0 )

        table.insert(playerBullets,aSingleBullet)
        print("# of bullet: " .. tostring(#playerBullets))
    end

    return true
end


function checkCharacterPosition( event )
	-- check every frame to see if 0character has fallen
	if theCharacter.y > display.contentHeight + 400 then
		theCharacter.x = display.contentCenterX + 190
        theCharacter.y = display.contentCenterY
    end

end


upArrow:addEventListener( "touch", upArrow )
downArrow:addEventListener( "touch", downArrow )
leftArrow:addEventListener( "touch", leftArrow )
rightArrow:addEventListener( "touch", rightArrow )

jumpButton:addEventListener( "touch", jumpButton )
shootButton:addEventListener( "touch", shootButton)

Runtime:addEventListener("enterFrame", checkCharacterPosition )
Runtime:addEventListener( "enterFrame", checkPlayerBulletsOutOfBounds )
Runtime:addEventListener( "collision", onCollision )

theCharacter.collision = characterCollision
theCharacter:addEventListener( "collision" )