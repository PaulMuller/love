seed = 257
local canvas = love.graphics.newCanvas()

function Interpolate(a, b, x)
    ft = x * 3.1415927
    f = (1 - math.cos(ft)) * 0.5

    return  a*(1-f) + b*f
end

function Noise(x, y)
    n = x + y * seed
    n = bit.bxor((bit.lshift(n,13)),n)

    return ( 1.0 - ( bit.band((n * (n * n * 15731 + 789221) + 1376312589), 0x7fffffff) / 1073741824.0))  
end

function SmoothedNoise1(x, y)
    corners = ( Noise(x-1, y-1)+Noise(x+1, y-1)+Noise(x-1, y+1)+Noise(x+1, y+1) ) / 16
    sides   = ( Noise(x-1, y)  +Noise(x+1, y)  +Noise(x, y-1)  +Noise(x,  y+1) ) /  8
    center  =  Noise(x, y) / 4
    return corners + sides + center
end

function InterpolatedNoise_1(x, y)
    integer_X, fractional_X = math.modf(x)
    integer_Y, fractional_Y = math.modf(y)

    v1 = SmoothedNoise1(integer_X,     integer_Y)
    v2 = SmoothedNoise1(integer_X + 1, integer_Y)
    v3 = SmoothedNoise1(integer_X,     integer_Y + 1)
    v4 = SmoothedNoise1(integer_X + 1, integer_Y + 1)

    i1 = Interpolate(v1 , v2 , fractional_X)
    i2 = Interpolate(v3 , v4 , fractional_X)

    return Interpolate(i1 , i2 , fractional_Y)
end

function getExampleMap2()
    mapWidth = 400
    mapHeight = 400
    mapMin = InterpolatedNoise_1(0, 0)
    mapMax = mapMin
    map2 = {}
    amp = 128
    freq =32
    octaves = 6
    for x = 0, (mapWidth) do
        map2[x] = {}
        for y = 0, mapHeight - 1 do
            map2[x][y] = 0
            for i = 1, octaves do
                map2[x][y] = map2[x][y] + getNoiseValue(x, y, freq / i, 
                  amp / i)

            end
            mapMin = math.min(mapMin, map2[x][y])
            mapMax = math.max(mapMax, map2[x][y])
        end
    end

    mapMultiplier = 255 / (mapMax - mapMin)
    for x = 0, (mapWidth) do
        for y = 0, mapHeight - 1 do
            map2[x][y] = map2[x][y] * mapMultiplier
        end
    end
end

function getNoiseValue(x, y, freq, amp)
    return InterpolatedNoise_1(x / freq, y / freq) * amp
end

function love.load()
    love.window.setMode( 800, 600, {fullscreen=false})
    getExampleMap2()
end

function love.draw()
    for x = 0, (mapWidth) do
        for y = 0, mapHeight - 1 do
            love.graphics.setColor(map2[x][y]/255, map2[x][y]/255, map2[x][y]/255, 1)
            love.graphics.points({x,y})
        end
    end

end

function love.update()

end

function love.keyreleased(key)
    if key == "escape" then
        love.event.quit()
    end
end
