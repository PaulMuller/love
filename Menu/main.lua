local MAIN_MENU = {
    "Start New Game", 
    "Load Game", 
    "Settings", 
    "Exit Game"
}

local PAUSE_MENU = {
    "Continue", 
    "Load Game", 
    "Settings", 
    "Main Menu", 
    "Exit Game"
}

local SETTINGS_MENU = {
    "Graphics", 
    "Sound", 
    "Gameplay", 
    "Game Info"
}

local GRAPHICS_MENU = {
    "Fullscreen"
}

local Menu = {
    breadcrumbs = {},
    items = MAIN_MENU,
    selectedItem = 1,  -- Initially selected item
    subMenu = nil,     -- Submenu for settings
    status = "main_menu" -- "pause_menu"
}

function Menu.load()
    table.insert(Menu.breadcrumbs, "main_menu")
end

function processSelectedMenuItem(menuItem)
    if Menu.breadcrumbs[#Menu.breadcrumbs] == menuItem then 
       return
    end

    Menu.selectedItem = 1

    if menuItem == "Main Menu" then 
        Menu.breadcrumbs = {"main_menu"}
    end

    if menuItem == "Continue" then 
        return "unpause"
    end

    if menuItem == "Start New Game" then 
        return "unpause"
    end

    if menuItem == "Load Game" then 
        -- load game state
        return "unpause"
    end

    if menuItem == "Settings" then 
        table.insert(Menu.breadcrumbs, "settings_menu")
    end

    if menuItem == "Graphics" then 
        table.insert(Menu.breadcrumbs, "graphics_menu")
    end
    if menuItem == "Fullscreen" then 
        return "toggle_fullscreen"
    end

    if menuItem == "Exit Game" then 
        return "exit_game"
    end

    if menuItem == "go_back" then
        local removed = table.remove(Menu.breadcrumbs)

        if removed == "main_menu" then 
            return "exit_game"
        end

        if removed == "pause_menu" then 
            return "unpause"
        end
    end
end

function Menu.keypressed( key, scancode, isrepeat )
    if scancode == 'up'       then Menu.selectedItem = math.max(1,           Menu.selectedItem - 1) end
    if scancode == 'down'     then Menu.selectedItem = math.min(#Menu.items, Menu.selectedItem + 1) end
    if scancode == 'return'   then return processSelectedMenuItem(Menu.items[Menu.selectedItem])    end
    if scancode == 'escape'   then return processSelectedMenuItem("go_back")                        end
end

function Menu.update(dt)
    if Menu.breadcrumbs[#Menu.breadcrumbs] == "main_menu"       then Menu.items = MAIN_MENU     end
    if Menu.breadcrumbs[#Menu.breadcrumbs] == "pause_menu"      then Menu.items = PAUSE_MENU    end
    if Menu.breadcrumbs[#Menu.breadcrumbs] == "settings_menu"   then Menu.items = SETTINGS_MENU end
    if Menu.breadcrumbs[#Menu.breadcrumbs] == "graphics_menu"   then Menu.items = GRAPHICS_MENU end
end

function Menu.draw()
    love.graphics.push()
    love.graphics.origin()

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(28, "mono"))

    for i, item in ipairs(Menu.breadcrumbs) do
        love.graphics.print(item, i*200, 10)
    end

    for i, item in ipairs(Menu.items) do
        local y = 100 + i * 50
        if i == Menu.selectedItem then
            love.graphics.setColor(1, 0, 0)  -- Highlight selected item
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.print(item, 100, y)
    end


    love.graphics.setColor(1, 1, 1)
    love.graphics.pop()
end

return Menu