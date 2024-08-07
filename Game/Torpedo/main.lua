local Torpedo = {}
local torpedoes = {}
local torpedoImg = love.graphics.newImage('assets/missle/Torpedo.png', {mipmaps = true})
local topedoMaxSpeed = 200

-- Load explosion sprites
local explosionSprites = {}
for i = 1, 9 do
    local explosionSprite = love.graphics.newImage("assets/explosion/" .. i .. ".png", {mipmaps = true})
    table.insert(explosionSprites, explosionSprite)
end

local explosions = {}
local playerPosition = {x =0, y=0}


local spriteRotation = math.pi / 2

function Torpedo.create(x, y, angle, speed, lifetime)
    local torpedo = {
        x = x,
        y = y,
        angle = angle,
        speed = speed,
        lifetime = lifetime
    }
    table.insert(torpedoes, torpedo)
end

function Torpedo.update(dt, px, py)
    playerPosition.x = px
    playerPosition.y = py


    for i = #torpedoes, 1, -1 do
        local torpedo = torpedoes[i]
        if torpedo.speed > topedoMaxSpeed then torpedo.speed = torpedo.speed*0.99 end
        if torpedo.speed < topedoMaxSpeed then torpedo.speed = torpedo.speed*1.02 end

        torpedo.x = torpedo.x + math.cos(torpedo.angle) * torpedo.speed * dt
        torpedo.y = torpedo.y + math.sin(torpedo.angle) * torpedo.speed * dt
        torpedo.lifetime = torpedo.lifetime - dt
        if torpedo.lifetime <= 0 then
            -- Create an explosion when the torpedo's lifetime ends
            table.insert(explosions, {
                x = torpedo.x,
                y = torpedo.y,
                angle = torpedo.angle,
                frame = 1,
                timer = 0
            })
            table.remove(torpedoes, i)
        end
    end

    -- Update explosions
    for i = #explosions, 1, -1 do
        local explosion = explosions[i]
        explosion.timer = explosion.timer + dt
        if explosion.timer > 0.1 then
            explosion.frame = explosion.frame + 1
            explosion.timer = 0
            if explosion.frame > 8 then
                table.remove(explosions, i)
            end
        end
    end
end

function Torpedo.draw()
    -- love.graphics.origin()
    

    for _, torpedo in ipairs(torpedoes) do
        love.graphics.setColor(1,1,1,0.25)
        love.graphics.draw(torpedoImg, torpedo.x,  torpedo.y, spriteRotation + torpedo.angle, 0.3)
        love.graphics.setColor(1,1,1,1)
    end

     -- Draw explosions
     for _, explosion in ipairs(explosions) do
        local sprite = explosionSprites[explosion.frame]
        love.graphics.draw(sprite, explosion.x, explosion.y, -spriteRotation + explosion.angle, 2, 2, sprite:getWidth()/2, sprite:getHeight()/2)
    end

    -- love.graphics.pop()
end

return Torpedo