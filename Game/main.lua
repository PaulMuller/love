local WaterBackground = require 'Game/WaterBackground/main'
local Player = require 'Game/Player/main'
local Torpedo = require 'Game/Torpedo/main' 

local zoom = 1
local camera = {
    x = 0,
    y = 0,
    folow = 'player',
    isDragging = false,
    dragStartX = 0, 
    dragStartY = 0,
    cameraStartX = 0, 
    cameraStartY = 0,
}

local Game = {}
local WorldObjects = {}

local coordX, coordY

function Game.load()
    WaterBackground.load()
    Player.load()
end


function Game.keypressed( key, scancode, isrepeat )
    if key == 'escape' then  
        return "pause"
    end

    if key == 'up'      then Player.control.increaseSpeed() end
    if key == 'down'    then Player.control.decreaseSpeed() end
    if key == 'left'    then Player.control.increaseRotationSpeed() end
    if key == 'right'   then Player.control.decreaseRotationSpeed() end
    if key == 'space'   then Player.control.launchTorpedo() end

    if key == 'w'       then Player.control.diveUp() end
    if key == 's'       then Player.control.diveDown() end
    if key == 't'       then 
        if camera.folow ~= 'player' then camera.folow = 'player' else camera.folow = '' end
    end
end

function Game.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if (presses%2 == 0) then 
            Game.moveCameraToScreenPoint(x, y)
            zoom = 1
        else
            camera.isDragging = true
            camera.dragStartX, camera.dragStartY = x, y
            camera.cameraStartX, camera.cameraStartY = camera.x, camera.y
        end
  
    end
end

function Game.mousereleased(x, y, button)
    if button == 1 then
        camera.isDragging = false
    end
end


function Game.mousemoved(x, y, dx, dy)
    if camera.isDragging then
        local screenWidth, screenHeight = love.graphics.getDimensions()

        local mouseMovedX = (x - camera.dragStartX)
        local mouseMovedY = (y - camera.dragStartY)

        if mouseMovedX > 10 or mouseMovedY > 10 then
            camera.folow = ''
        end
        camera.folow = ''
        camera.x = camera.cameraStartX - mouseMovedX / zoom
        camera.y = camera.cameraStartY - mouseMovedY / zoom


    end
end

function Game.moveCameraToScreenPoint(x, y)
    local screenWidth, screenHeight = love.graphics.getDimensions()
    local worldX = camera.x + (x - screenWidth/2) / zoom
    local worldY = camera.y + (y - screenHeight/2) / zoom
    camera.folow = ''
    camera.x = worldX
    camera.y = worldY
end


function Game.wheelmoved(x, y)
    if y > 0 then
        zoom = math.min(30, zoom * 1.1)
    elseif y < 0 then
        zoom = math.max(0.1, zoom * 0.9)
    end
end

function Game.update(dt)
    coordX, coordY = Player.update(dt)

    -- if love.mouse.isDown(3) then 
    --     Game.moveCameraToScreenPoint(love.mouse.getPosition())
    -- end

    if camera.folow == 'player' then
        camera.x = coordX 
        camera.y = coordY 
    end
    
    WaterBackground.setCoords(camera.x, camera.y)
    WaterBackground.update(dt)
    Torpedo.update(dt, coordX, coordY)
end

function Game.draw()
    local screenWidth, screenHeight = love.graphics.getDimensions()


    love.graphics.push() 
    WaterBackground.draw(zoom, screenWidth, screenHeight)
    love.graphics.pop()

    love.graphics.push()
    love.graphics.origin()


    love.graphics.translate(screenWidth/2, screenHeight/2)
    love.graphics.scale(zoom) 
    love.graphics.translate(-camera.x, -camera.y)

    Torpedo.draw()
    Player.draw()
    love.graphics.setColor( 0, 1, 0)
    love.graphics.circle( 'line', coordX, coordY, 100)
    love.graphics.setColor( 1, 1, 1)

    
    
    love.graphics.pop()
end

return Game