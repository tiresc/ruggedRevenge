-- Example of a 23x23 game grid initialization with unmovable blocks on the perimeter
local xMax = 23
local yMax = 23
local gameGrid = {}  -- Initialize gameGrid as an empty table

for y = 1, yMax do
    gameGrid[y] = {}
    for x = 1, xMax do
        if x == 1 or x == xMax or y == 1 or y == yMax then
            gameGrid[y][x] = 3  -- 3 represents an unmovable block
        else
            gameGrid[y][x] = 0  -- 0 represents an empty cell
        end
    end
end




-- Define the player character
local player = {
    x = 12,  -- Starting x position
    y = 12,  -- Starting y position
    type = 1  -- Identifier for the player, 1 in this case
}
-- Define blocks in the grid
local blocks = {
    {x = 3, y = 3, type = 2},  -- Block 1
    --{x = 4, y = 3, type = 2},  -- Block 2
    --{x = 3, y = 4, type = 2},  -- Block 3
    --{x = 4, y = 4, type = 2}   -- Block 4
}
local cat = {
    x = 5,
    y = 5,
    type = 4  -- Identifier for the cat, 4 in this case
}

gameGrid[cat.y][cat.x] = cat.type
gameGrid[player.y][player.x] = player.type

function love.update(dt)
    -- This function is called once every frame, and 'dt' is the time in seconds since the last frame.

    -- Example: Update the player's or other objects' states
    -- You could handle continuous movement, animations, game logic, etc., here.

    -- For now, let's just print the player's position for debugging purposes
    -- In a real game, you would update positions, check for collisions, etc.
    print("Player position:", player.x, player.y)

    -- If you have moving objects or animations, you would update their states here.
    -- For example, if you want a block to move continuously or an enemy to follow a path,
    -- you would calculate their new position based on 'dt' to ensure smooth movement.

    -- If your game has time-based mechanics (like a timer, countdown, etc.), you would
    -- update those here as well, decrementing the timer by 'dt' or similar logic.
end

function love.draw()
    local cellSize = 32  -- Assuming each cell in the grid is 32x32 pixels
    for y = 1, yMax do  -- Ensure we go to the edge of the grid
        for x = 1, xMax do  -- Ensure we go to the edge of the grid
            local cell = gameGrid[y][x]
            if cell == 1 then
                love.graphics.setColor(1, 0, 0)  -- Red for the player
                love.graphics.rectangle('fill', (x-1) * cellSize, (y-1) * cellSize, cellSize, cellSize)
            elseif cell == 2 then
                love.graphics.setColor(0, 0, 1)  -- Blue for movable blocks
                love.graphics.rectangle('fill', (x-1) * cellSize, (y-1) * cellSize, cellSize, cellSize)
            elseif cell == 3 then
                love.graphics.setColor(0.5, 0.5, 0.5)  -- Gray for unmovable blocks
                love.graphics.rectangle('fill', (x-1) * cellSize, (y-1) * cellSize, cellSize, cellSize)
            elseif cell == 4 then
                love.graphics.setColor(1, 0, 1)  -- Magenta for the cat
                love.graphics.rectangle('fill', (x-1) * cellSize, (y-1) * cellSize, cellSize, cellSize)
            end
            -- Empty cells are automatically skipped as there is no drawing command for them
        end
    end
end







-- Place the blocks on the grid
for _, block in ipairs(blocks) do
    gameGrid[block.y][block.x] = block.type
end

function canMoveTo(x, y)
    -- Check bounds for the game grid
    if x < 1 or x > xMax or y < 1 or y > yMax then
        return false
    end

    local cell = gameGrid[y][x]
    return cell == 0 or cell == 2  -- Can move to an empty cell or push a block
end


function moveTo(object, newX, newY)
    -- Check bounds for the game grid
    if newX < 1 or newX > xMax or newY < 1 or newY > yMax then
        return false
    end

    local nextCell = gameGrid[newY][newX]

    -- Handling unmovable blocks
    if nextCell == 3 then
        return false  -- Can't move into unmovable blocks
    end

    -- Handling movable blocks
    if nextCell == 2 then
        local pushX = newX + (newX - object.x)
        local pushY = newY + (newY - object.y)

        -- Check if the block can be pushed and if the next position is empty
        if pushX >= 1 and pushX <= xMax and pushY >= 1 and pushY <= yMax and gameGrid[pushY][pushX] == 0 then
            -- Push the block
            gameGrid[pushY][pushX] = 2  -- Move the block to the new position
            gameGrid[newY][newX] = object.type  -- Move the player to the block's old position
            gameGrid[object.y][object.x] = 0  -- Set the player's old position to empty
            object.x = newX
            object.y = newY
            return true
        else
            return false  -- Can't push the block, so don't move
        end
    end

    -- Move the object if the next cell is empty
    if nextCell == 0 then
        gameGrid[object.y][object.x] = 0  -- Set the old position to empty
        object.x = newX
        object.y = newY
        gameGrid[newY][newX] = object.type  -- Set the new position to the object's type
        return true
    end

    return false
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
    elseif scancode == "up" then
        dy = -1
    elseif scancode == "left" then
        dx = -1
    elseif scancode == "right" then
        dx = 1
    elseif scancode == "down" then
        dy = 1
    end

    local newX = player.x + dx
    local newY = player.y + dy

    moveTo(player, newX, newY)  -- Attempt to move the player
end
