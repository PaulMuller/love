local utility = require 'utility'
local Torpedo = require 'Game/Torpedo/main' 

local Player = {
    control = {}
}
local submarineImg

local offsetX, offsetY

local spriteRotation = math.pi / 2
local rotation = 0
local scale = 1

local altitude = 0

local positionX = 0
local positionY = 0

local speed = 0
local maxSpeed = 30
local minSpeed = -10

local rotationSpeed = 0
local maxRotationSpeed = 0.01
local minRotationSpeed = -0.01


function Player.load()
    submarineImg = love.graphics.newImage('assets/player/submarine.png', {mipmaps = true})

    offsetX = submarineImg:getWidth()  / 2
    offsetY = submarineImg:getHeight() / 3
end


function Player.control.diveUp()
    altitude = math.min(altitude + 1, 0)
    print(altitude)
end

function Player.control.diveDown()
    altitude = math.max(altitude - 1, -100)
    print(altitude)
end

function Player.control.launchTorpedo()
    Torpedo.create(positionX, positionY, rotation, math.max(10, speed), 10)  -- Create torpedo at player's position, moving in player's direction
end

function Player.control.increaseSpeed()
    if speed < maxSpeed then
        speed = speed + 10
    end
end

function Player.control.decreaseSpeed()
    if speed > minSpeed then
        speed = speed - 10
    end
end

function Player.control.increaseRotationSpeed()
    if rotationSpeed > minRotationSpeed then
        rotationSpeed = rotationSpeed - 0.01
    end
end

function Player.control.decreaseRotationSpeed()
    if rotationSpeed < maxRotationSpeed then
        rotationSpeed = rotationSpeed + 0.01
    end
end

function Player.update(dt)
    local distance = dt * speed

    positionX = positionX + distance * math.cos(rotation)
    positionY = positionY + distance * math.sin(rotation)
    rotation  = rotation  + distance * rotationSpeed

    return positionX, positionY
end

function Player.draw()
    love.graphics.push()
    if altitude ~= 0 then love.graphics.setColor(1,1,1,0.25) end
    
    love.graphics.draw(submarineImg, positionX , positionY , rotation + spriteRotation, scale, scale, offsetX, offsetY)

    love.graphics.pop()

    return positionX , positionY
end

return Player