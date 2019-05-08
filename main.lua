--[[
    2048

    Author: Colton Ogden
]]

require 'src/dependencies'

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.window.setTitle('2048')
    font = love.graphics.newFont(64)
    love.graphics.setFont(font)

    grid = Grid()

    -- enable or disable movement depending on tile movement
    canMove = true
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    -- move the tiles
    if canMove then
        if key == 'up' then
            moveUp()
            grid:spawnTile()
        elseif key == 'down' then
            moveDown()
            grid:spawnTile()
        elseif key == 'right' then
            moveRight()
            grid:spawnTile()
        elseif key == 'left' then
            moveLeft()
            grid:spawnTile()
        end
    end
end

function love.update(dt)
    Timer.update(dt)
end

function moveUp()
    -- iterate row by row over the grid, right to left
    for x = 1, 4 do

        -- start 1 from the right because edge tile can't move
        for y = 2, 4 do
            local tile = grid:getTile(x, y)

            -- only move tile if it exists
            if tile then

                -- grab farthest open tile we can move to
                local farthestY = grid:getTopmostOpenY(x, y, 1)

                -- if the tile we're moving to is not the same
                if farthestY ~= y then

                    -- combine like numbers
                    -- only allow if we are not at right edge
                    if farthestY > 1 then
                        local farthestTile = grid:getTile(x, farthestY - 1)
                        if farthestTile.num == tile.num then
                            canMove = false
                            local oldY = tile.tileY
            
                            tile.tileY = farthestY - 1
                            grid:clearTile(x, oldY)

                            Timer.tween(0.1, {
                                [tile] = {x = grid.grid[tile.tileY][tile.tileX].x, 
                                          y = grid.grid[tile.tileY][tile.tileX].y}
                            }):finish(function()
                                canMove = true
                                print('X: ' .. tile.tileX, 'Y: ' .. tile.tileY)
                                grid:getTile(tile.tileX, tile.tileY).num = tile.num * 2
                                tile.remove = true
                                grid:removeDeletedTiles()
                            end)

                            -- skip non-combination movement below
                            goto continue
                        end
                    end

                    -- just move over as normal if not combining terms
                    canMove = false
                    local oldY = tile.tileY

                    print(x, oldY)
                    
                    tile.tileY = farthestY
                    grid:setTile(x, tile.tileY, tile)
                    grid:clearTile(x, oldY)

                    Timer.tween(0.1, {
                        [tile] = {x = grid.grid[tile.tileY][tile.tileX].x, y = grid.grid[tile.tileY][tile.tileX].y}
                    }):finish(function()
                        canMove = true
                    end)

                    ::continue::
                end
            end
        end
    end
end

function moveDown()
    -- iterate row by row over the grid, right to left
    for x = 1, 4 do

        -- start 1 from the right because edge tile can't move
        for y = 3, 1, -1 do
            local tile = grid:getTile(x, y)

            -- only move tile if it exists
            if tile then

                -- grab farthest open tile we can move to
                local farthestY = grid:getBottommostOpenY(x, y, 4)

                -- if the tile we're moving to is not the same
                if farthestY ~= y then

                    -- combine like numbers
                    -- only allow if we are not at right edge
                    if farthestY < 4 then
                        local farthestTile = grid:getTile(x, farthestY + 1)
                        if farthestTile.num == tile.num then
                            canMove = false
                            local oldY = tile.tileY
            
                            tile.tileY = farthestY + 1
                            grid:clearTile(x, oldY)

                            Timer.tween(0.1, {
                                [tile] = {x = grid.grid[tile.tileY][tile.tileX].x, 
                                          y = grid.grid[tile.tileY][tile.tileX].y}
                            }):finish(function()
                                canMove = true
                                print('X: ' .. tile.tileX, 'Y: ' .. tile.tileY)
                                grid:getTile(tile.tileX, tile.tileY).num = tile.num * 2
                                tile.remove = true
                                grid:removeDeletedTiles()
                            end)

                            -- skip non-combination movement below
                            goto continue
                        end
                    end

                    -- just move over as normal if not combining terms
                    canMove = false
                    local oldY = tile.tileY

                    print(x, oldY)
                    
                    tile.tileY = farthestY
                    grid:setTile(x, tile.tileY, tile)
                    grid:clearTile(x, oldY)

                    Timer.tween(0.1, {
                        [tile] = {x = grid.grid[tile.tileY][tile.tileX].x, y = grid.grid[tile.tileY][tile.tileX].y}
                    }):finish(function()
                        canMove = true
                    end)

                    ::continue::
                end
            end
        end
    end
end

function moveLeft()
    -- iterate row by row over the grid, right to left
    for y = 1, 4 do

        -- start 1 from the right because edge tile can't move
        for x = 2, 4 do
            local tile = grid:getTile(x, y)

            -- only move tile if it exists
            if tile then

                -- grab farthest open tile we can move to
                local farthestX = grid:getLeftmostOpenX(x, y, 1)

                -- if the tile we're moving to is not the same
                if farthestX ~= x then

                    -- combine like numbers
                    -- only allow if we are not at right edge
                    if farthestX > 1 then
                        local farthestTile = grid:getTile(farthestX - 1, y)
                        if farthestTile.num == tile.num then
                            canMove = false
                            local oldX = tile.tileX
            
                            tile.tileX = farthestX - 1
                            grid:clearTile(oldX, y)

                            Timer.tween(0.1, {
                                [tile] = {x = grid.grid[tile.tileY][tile.tileX].x, 
                                            y = grid.grid[tile.tileY][tile.tileX].y}
                            }):finish(function()
                                canMove = true
                                print('X: ' .. tile.tileX, 'Y: ' .. tile.tileY)
                                grid:getTile(tile.tileX, tile.tileY).num = tile.num * 2
                                tile.remove = true
                                grid:removeDeletedTiles()
                            end)

                            -- skip non-combination movement below
                            goto continue
                        end
                    end

                    -- just move over as normal if not combining terms
                    canMove = false
                    local oldX = tile.tileX

                    print(oldX, y)
                    
                    tile.tileX = farthestX
                    grid:setTile(tile.tileX, y, tile)
                    grid:clearTile(oldX, y)

                    Timer.tween(0.1, {
                        [tile] = {x = grid.grid[tile.tileY][tile.tileX].x, y = grid.grid[tile.tileY][tile.tileX].y}
                    }):finish(function()
                        canMove = true
                    end)

                    ::continue::
                end
            end
        end
    end
end

function moveRight()
    -- iterate row by row over the grid, right to left
    for y = 1, 4 do

        -- start 1 from the right because edge tile can't move
        for x = 3, 1, -1 do
            local tile = grid:getTile(x, y)

            -- only move tile if it exists
            if tile then

                -- grab farthest open tile we can move to
                local farthestX = grid:getRightmostOpenX(x, y, 4)

                -- if the tile we're moving to is not the same
                if farthestX ~= x then

                    -- combine like numbers
                    -- only allow if we are not at right edge
                    if farthestX < 4 then
                        local farthestTile = grid:getTile(farthestX + 1, y)
                        if farthestTile.num == tile.num then
                            canMove = false
                            local oldX = tile.tileX
            
                            tile.tileX = farthestX + 1
                            grid:clearTile(oldX, y)

                            Timer.tween(0.1, {
                                [tile] = {x = grid.grid[tile.tileY][tile.tileX].x, 
                                            y = grid.grid[tile.tileY][tile.tileX].y}
                            }):finish(function()
                                canMove = true
                                print('X: ' .. tile.tileX, 'Y: ' .. tile.tileY)
                                grid:getTile(tile.tileX, tile.tileY).num = tile.num * 2
                                tile.remove = true
                                grid:removeDeletedTiles()
                            end)

                            -- skip non-combination movement below
                            goto continue
                        end
                    end

                    -- just move over as normal if not combining terms
                    canMove = false
                    local oldX = tile.tileX

                    print(oldX, y)
                    
                    tile.tileX = farthestX
                    grid:setTile(tile.tileX, y, tile)
                    grid:clearTile(oldX, y)

                    Timer.tween(0.1, {
                        [tile] = {x = grid.grid[tile.tileY][tile.tileX].x, y = grid.grid[tile.tileY][tile.tileX].y}
                    }):finish(function()
                        canMove = true
                    end)

                    ::continue::
                end
            end
        end
    end
end

function love.draw()
    love.graphics.clear(250/255, 250/255, 238/255, 1)

    grid:render()
end