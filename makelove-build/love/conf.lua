function love.conf(t)
    local cellSize = 32  -- The size of each cell in the grid
    local gridWidth = 23  -- The width of the grid in cells
    local gridHeight = 23  -- The height of the grid in cells

    t.window.width = gridWidth * cellSize  -- Calculate the total window width
    t.window.height = gridHeight * cellSize  -- Calculate the total window height
end