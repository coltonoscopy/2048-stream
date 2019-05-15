--[[
    Tile Grid
]]

Grid = Class{}

function Grid:init()
    self.grid = {}
    self.tiles = {}

    self:initializeGrid()

    for i = 1, 4 do
        self:spawnTile()
    end
end

--[[
    Prints the grid to the console.
]]
function Grid:print()
    for y = 1, 4 do
        for x = 1, 4 do
            io.write('[')
            
            if self.grid[y][x].tile then
                io.write(tostring(self.grid[y][x].tile.num))
            else
                io.write(' ')
            end

            io.write(']')
        end
        io.write('\n')
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

function Grid:calculateWin()
    for y = 1, 4 do
        for x = 1, 4 do
            if self.grid[y][x].tile and self.grid[y][x].tile.num == 2048 then
                return true
            end
        end
    end

    return false
end

function Grid:calculateLoss()
    for y = 1, 4 do
        for x = 1, 4 do
            local tile = self.grid[y][x].tile

            if not tile then
                return false 
            end

            -- check top
            if y > 1 then
                local tileTop = self.grid[y-1][x].tile

                -- if no tile above, we can move
                if not tileTop then
                    return false
                
                -- if tile identical in num, we can merge
                elseif tileTop.num == tile.num then
                    return false
                end
            end

            -- check bottom
            if y < 4 then
                local tileBottom = self.grid[y+1][x].tile

                -- if no tile above, we can move
                if not tileBottom then
                    return false
                
                -- if tile identical in num, we can merge
                elseif tileBottom.num == tile.num then
                    return false
                end
            end

            -- check left
            if x > 1 then
                local tileLeft = self.grid[y][x-1].tile

                -- if no tile above, we can move
                if not tileLeft then
                    return false
                
                -- if tile identical in num, we can merge
                elseif tileLeft.num == tile.num then
                    return false
                end
            end

            -- check right
            if x < 4 then
                local tileRight = self.grid[y][x+1].tile

                -- if no tile above, we can move
                if not tileRight then
                    return false
                
                -- if tile identical in num, we can merge
                elseif tileRight.num == tile.num then
                    return false
                end
            end
        end
    end

    print('Game Over!')
    return true
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