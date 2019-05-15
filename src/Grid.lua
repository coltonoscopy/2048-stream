--[[
    Tile Grid
]]

Grid = Class{}

function Grid:init()
    self.grid = {}
    self.tiles = {}

    self:initializeGrid()

    for i = 1, 5 do
        self:spawnTile()
    end
end

function Grid:removeDeletedTiles()
    for index, tile in ipairs(self.tiles) do
        if tile.remove then
            table.remove(self.tiles, index)
        end
    end
end

function Grid:initializeGrid()
    for y = 1, 4 do
        
        table.insert(self.grid, {})
        
        for x = 1, 4 do
            table.insert(self.grid[y], {
                x = PADDING + WINDOW_WIDTH / 4 + (x - 1) * GRID_TILE_SIZE + (x - 1) * PADDING,
                y = PADDING + WINDOW_HEIGHT / 8 + (y - 1) * GRID_TILE_SIZE + (y - 1) * PADDING,
                occupied = false, tile = nil
            })
        end
    end
end

function Grid:clearTile(x, y)
    self.grid[y][x].tile = nil
    self.grid[y][x].occupied = false
end

function Grid:createTile(x, y)
    local tile = Tile(x, y, self.grid[y][x].x, self.grid[y][x].y)
    table.insert(self.tiles, tile)
    self:setTile(x, y, tile)
end

function Grid:setTile(x, y, tile)
    self.grid[y][x].tile = tile
    self.grid[y][x].occupied = true
end

function Grid:getTile(x, y)
    return self.grid[y][x].tile
end

function Grid:spawnTile()
    if #self.tiles < 16 then
        local x, y = math.random(4), math.random(4)

        while self.grid[y][x].tile do
            x, y = math.random(4), math.random(4)
        end

        self:createTile(x, y)
    end
end

function Grid:getRightmostOpenX(startX, startY, finish)
    for x = startX + 1, finish do
        if self.grid[startY][x].occupied then
            return x - 1
        end
    end

    return finish
end

function Grid:getLeftmostOpenX(startX, startY, finish)
    for x = startX - 1, finish, -1 do
        if self.grid[startY][x].occupied then
            return x + 1
        end
    end

    return finish
end

function Grid:getTopmostOpenY(startX, startY, finish)
    for y = startY - 1, finish, -1 do
        if self.grid[y][startX].occupied then
            return y + 1
        end
    end

    return finish
end

function Grid:getBottommostOpenY(startX, startY, finish)
    for y = startY + 1, finish do
        if self.grid[y][startX].occupied then
            return y - 1
        end
    end

    return finish
end

function Grid:update(dt)

end

function Grid:render()
    love.graphics.setColor(186/255, 173/255, 160/255, 1)
    love.graphics.rectangle('fill', 
        WINDOW_WIDTH / 4, 
        WINDOW_HEIGHT / 8, 
        GRID_BACKGROUND_WIDTH, GRID_BACKGROUND_HEIGHT, 10, 10, 3)

    for y = 1, 4 do
        for x = 1, 4 do
            love.graphics.setColor(205/255, 192/255, 181/255, 1)
            love.graphics.rectangle('fill', self.grid[y][x].x, self.grid[y][x].y, 
                GRID_TILE_SIZE, GRID_TILE_SIZE, 5, 5, 3)
        end
    end

    -- draw tiles
    for k, tile in pairs(self.tiles) do
        tile:render()
    end
end