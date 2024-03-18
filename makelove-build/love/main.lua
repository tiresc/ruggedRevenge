-- Example of a 23x23 game grid initialization with unmovable blocks on the perimeter
local xMax = 23;
local yMax = 23;
local gameGrid = {}
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
    {x = 4, y = 3, type = 2},  -- Block 2
    {x = 3, y = 4, type = 2},  -- Block 3
    {x = 4, y = 4, type = 2}   -- Block 4
}
local cat = {
    x = 2,
    y = 2,
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
    for y = 1, #gameGrid do
        for x = 1, #gameGrid[y] do
            local cell = gameGrid[y][x]
            if cell == 1 then
                love.graphics.setColor(1, 0, 0)  -- Red for the player
                love.graphics.rectangle('fill', (x-1) * 32, (y-1) * 32, 32, 32)
            elseif cell == 2 then
                love.graphics.setColor(0, 0, 1)  -- Blue for movable blocks
                love.graphics.rectangle('fill', (x-1) * 32, (y-1) * 32, 32, 32)
            elseif cell == 3 then
                love.graphics.setColor(0.5, 0.5, 0.5)  -- Gray for unmovable blocks
                love.graphics.rectangle('fill', (x-1) * 32, (y-1) * 32, 32, 32)
            elseif cell == 4 then
                love.graphics.setColor(1, 0, 1)  -- Magenta for the cat
                love.graphics.rectangle('fill', (x-1) * 32, (y-1) * 32, 32, 32)
            end
        end
    end
end




function moveTo(object, newX, newY)
    if newX < 1 or newX > 20 or newY < 1 or newY > 20 then
        return false
    end

    local nextCell = gameGrid[newY][newX]

    if nextCell == 3 then  -- Check for unmovable blocks
        return false  -- Can't move into unmovable blocks
    elseif nextCell == 2 then  -- Check for movable blocks
        local pushX = newX + (newX - object.x)
        local pushY = newY + (newY - object.y)
        if pushX < 1 or pushX > 20 or pushY < 1 or pushY > 20 or gameGrid[pushY][pushX] ~= 0 then
            return false  -- Can't push the block, so don't move
        else
            -- Move the block
            gameGrid[pushY][pushX] = 2
            gameGrid[newY][newX] = 0
        end
    end

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
        dx = 32
    elseif scancode == "a" then
        dx = -32
    elseif scancode == "s" then
        dy = 32
    elseif scancode == "w" then
        dy = -32
    end

    local newX = player.x + dx
    local newY = player.y + dy

    -- Only move the player if the new position is within bounds
    if canMoveTo(newX, newY) then
        moveTo(player, newX, newY)
    end
end
