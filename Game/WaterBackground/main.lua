local utility = require 'utility'


local WaterBackground = {}
local waterFrames = {}
local currentFrame = 1

local textureWidth = 256
local textureHeight = 256

local coordX = 0
local coordY = 0

local textureOffsetX = 0
local textureOffsetY = 0

local shader

local w, h = love.graphics.getDimensions()

function WaterBackground.load()
    for i = 1, 250 do
        local img = love.graphics.newImage('assets/water/water_058_c_' .. utility.padWithZeroes(i, 4) .. '.jpg', {mipmaps = true})
        img:setWrap("repeat", "repeat")
        table.insert(waterFrames, img)
    end

    shader = love.graphics.newShader('assets/shaders/test.glsl')
end

function WaterBackground.update(dt)
    currentFrame = math.floor(love.timer.getTime() * 30 % 250) + 1
    textureOffsetX = (1 + coordX % textureWidth) 
    textureOffsetY = (1 + coordY % textureHeight)
end

function WaterBackground.setCoords(x, y)
    coordX = x
    coordY = y
end


function WaterBackground.draw(zoom, screenWidth, screenHeight)
    love.graphics.push()
    love.graphics.origin()
    love.graphics.scale(zoom)   
   
    -- love.graphics.setShader(shader)
    -- shader:send("iMouse", {love.mouse.getX() , love.mouse.getY() })
    -- shader:send("iResolution",{ w/5, h/5})
    -- shader:send("waveOrigin", {screenWidth/2, screenHeight/2})
    -- shader:send("waveDirection", 1)
    -- shader:send("iTime", love.timer.getTime())

    local screenWidth = screenWidth / zoom
    local screenHeight = screenHeight/ zoom

    if (zoom > 0.3) then 
        local frame = waterFrames[currentFrame]

    
        local quad1 = love.graphics.newQuad(
            -screenWidth/2 + textureOffsetX, 
            -screenHeight/2 + textureOffsetY,  
            screenWidth, 
            screenHeight, 
            textureWidth/2, 
            textureHeight/2
        )

        love.graphics.draw(frame, quad1, 0, 0)
    else
        love.graphics.setColor(70/255, 125/255, 140/255)
        love.graphics.polygon('fill', 
            -screenWidth/2,-screenHeight/2, 
            screenWidth, -screenHeight/2, 
            screenWidth, screenHeight, 
            -screenWidth/2,screenHeight
        )
        love.graphics.setColor(1,1,1)
    end
        
    -- love.graphics.setShader()

    love.graphics.pop()
end

return WaterBackground