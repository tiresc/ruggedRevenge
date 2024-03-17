-- Example of a 20x20 game grid initialization with unmovable blocks on the perimeter
local gameGrid = {}
for y = 1, 20 do
    gameGrid[y] = {}
    for x = 1, 20 do
        if x == 1 or x == 20 or y == 1 or y == 20 then
            gameGrid[y][x] = 3  -- 3 represents an unmovable block
        else
            gameGrid[y][x] = 0  -- 0 represents an empty cell
        end
    end
end


-- Define the player character
local player = {
    x = 5,  -- Starting x position
    y = 5,  -- Starting y position
    type = 1  -- Identifier for the player, 1 in this case
}

gameGrid[player.y][player.x] = player.type


-- Define blocks in the grid
local blocks = {
    {x = 3, y = 3, type = 2},  -- Block 1
    {x = 4, y = 3, type = 2},  -- Block 2
    {x = 3, y = 4, type = 2},  -- Block 3
    {x = 4, y = 4, type = 2}   -- Block 4
}
function love.draw()
    for y = 1, #gameGrid do
        for x = 1, #gameGrid[y] do
            if gameGrid[y][x] == 1 then  -- Player
                love.graphics.setColor(1, 0, 0)  -- Red color for the player
                love.graphics.rectangle('fill', (x-1) * 32, (y-1) * 32, 32, 32)
            elseif gameGrid[y][x] == 2 then  -- Movable Block
                love.graphics.setColor(0, 0, 1)  -- Blue color for the block
                love.graphics.rectangle('fill', (x-1) * 32, (y-1) * 32, 32, 32)
            elseif gameGrid[y][x] == 3 then  -- Unmovable Block
                love.graphics.setColor(0.5, 0.5, 0.5)  -- Gray color for unmovable block
                love.graphics.rectangle('fill', (x-1) * 32, (y-1) * 32, 32, 32)
            end
        end
    end
end



function moveTo(object, newX, newY)
    -- Check bounds for the 20x20 grid
    if newX < 1 or newX > 20 or newY < 1 or newY > 20 then
        return false
    end

    local nextCell = gameGrid[newY][newX]

    -- Check if the next cell contains a block and try to push it
    if nextCell == 2 then
        local pushX = newX + (newX - object.x)
        local pushY = newY + (newY - object.y)

        -- Check if the position beyond the block is empty and within bounds
        if pushX < 1 or pushX > 20 or pushY < 1 or pushY > 20 or gameGrid[pushY][pushX] ~= 0 then
            return false  -- Can't push the block, so don't move
        else
            -- Move the block
            gameGrid[pushY][pushX] = 2
            gameGrid[newY][newX] = 0
        end
    end

    -- Check if the next cell is empty or has been cleared by pushing a block
    if gameGrid[newY][newX] == 0 then
        -- Move the object
        gameGrid[object.y][object.x] = 0
        object.x = newX
        object.y = newY
        gameGrid[newY][newX] = object.type
        return true
    end

    return false
end


-- Place the blocks on the grid
for _, block in ipairs(blocks) do
    gameGrid[block.y][block.x] = block.type
end

function canMoveTo(x, y)
    -- Check bounds for the 20x20 grid
    if x < 1 or x > 20 or y < 1 or y > 20 then
        return false
    end

    return gameGrid[y][x] == 0
end

function moveTo(object, newX, newY)
    if canMoveTo(newX, newY) then
        -- Update the grid: Mark the old position as empty
        gameGrid[object.y][object.x] = 0
        -- Move the object
        object.x = newX
        object.y = newY
        -- Update the grid with the object's new position
        gameGrid[newY][newX] = object.type -- object.type could be an identifier for what the object is
    end
end

function love.keypressed(key, scancode, isrepeat)
    local dx, dy = 0, 0
    if scancode == "d" then
        dx = 1
    elseif scancode == "a" then
        dx = -1
    elseif scancode == "s" then
        dy = 1
    elseif scancode == "w" then
        dy = -1
    end

    local newX = player.x + dx
    local newY = player.y + dy

    -- Only move the player if the new position is within bounds
    if canMoveTo(newX, newY) then
        moveTo(player, newX, newY)
    end
end
