local M = {}

function M.padWithZeroes(number, width)
    local strNumber = tostring(number)
    local zeroesToAdd = width - #strNumber
    local paddedNumber = string.rep("0", zeroesToAdd) .. strNumber
    return paddedNumber
end

function M.findRotation(x1,y1,x2,y2)
    local t = -math.deg(math.atan2(x2-x1,y2-y1))
    if t < 0 then t = t + 360 end;
    return t;   
end

return M