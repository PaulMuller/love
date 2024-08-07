local Slab = require 'Slab'

local Menu = require 'Menu/main'
local Game = require 'Game/main'


local menuActive = true
local gameActive = false
local fullscreen = false

function love.load(args)
    love.window.setFullscreen( fullscreen )

    Game.load()
    
    Menu.load()
end


function pause()
    Menu.breadcrumbs = {"pause_menu"}
    menuActive = true 
    gameActive = false
end

function unpause()
    menuActive = false 
    gameActive = true
end

function love.keypressed( key, scancode, isrepeat )
    if (menuActive) then
        local action = Menu.keypressed(key, scancode, isrepeat) 

        if action == "exit_game" then love.event.quit() end
        if action == "unpause"   then unpause() end
        
        
        if action == "toggle_fullscreen" then 
            print(toggle_fullscreen)
            fullscreen = not fullscreen 
            love.window.setFullscreen( fullscreen )
        end

        
    end

    if (gameActive) then 
        local action = Game.keypressed(key, scancode, isrepeat) 

        if action == "pause" then pause() end        
    end
end


function love.mousepressed(x, y, button, istouch, presses)
    if (gameActive) then 
        Game.mousepressed(x, y, button, istouch, presses) 
    end
 end

function love.mousereleased(x, y, button)
    if (gameActive) then 
        Game.mousereleased(x, y, button) 
    end
 end

function love.mousemoved(x, y, dx, dy)
    if (gameActive) then 
        Game.mousemoved(x, y, dx, dy) 
    end
end


function love.wheelmoved(x, y)
    if (gameActive) then 
        Game.wheelmoved(x, y)
    end
end

function love.update(dt)
    if (gameActive) then
        Game.update(dt)
    end
   
    if (menuActive) then 
        Menu.update(dt)
    end
    
end

function love.draw()
    if (gameActive) then
        Game.draw()
    end
   
    if (menuActive) then 
        Menu.draw()
    end
    
    love.graphics.print(love.timer.getFPS())
end