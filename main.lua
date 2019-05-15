--[[
    2048

    Author: Colton Ogden
]]

require 'src/dependencies'

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.window.setTitle('2048')
    font = love.graphics.newFont(32)
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
            grid:print()
            grid:spawnTile()
        elseif key == 'down' then
            moveDown()
            grid:print()
            grid:spawnTile()
        elseif key == 'right' then
            moveRight()
            grid:print()
            grid:spawnTile()
        elseif key == 'left' then
            moveLeft()
            grid:print()
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

                -- check the tile beyond for same num and merge if so
                if farthestY - 1 >= 1 then
                    local farthestTile = grid:getTile(x, farthestY - 1)

                    -- if tile num is equivalent, merge tiles
                    if farthestTile.num == tile.num then
                        makeMerge(tile, x, tile.tileY, x, farthestY - 1)
                    elseif farthestY ~= y then
                        makeMove(tile, x, tile.tileY, x, farthestY)
                    end

                -- otherwise, just make an ordinary move
                else
                    makeMove(tile, x, tile.tileY, x, farthestY)
                end

                ::continue::
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

                -- check the tile beyond for same num and merge if so
                if farthestY + 1 <= 4 then
                    local farthestTile = grid:getTile(x, farthestY + 1)

                    if farthestTile.num == tile.num then
                        makeMerge(tile, x, tile.tileY, x, farthestY + 1)
                    elseif farthestY ~= y then
                        makeMove(tile, x, tile.tileY, x, farthestY)
                    end

                -- otherwise, just make an ordinary move
                else
                    makeMove(tile, x, tile.tileY, x, farthestY)
                end

                ::continue::
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

                -- check the tile beyond for same num and merge if so
                if farthestX - 1 >= 1 then
                    local farthestTile = grid:getTile(farthestX - 1, y)

                    -- if tile num is equivalent, merge tiles
                    if farthestTile.num == tile.num then
                        makeMerge(tile, tile.tileX, y, farthestX - 1, y)
                    elseif farthestX ~= x then
                        makeMove(tile, tile.tileX, y, farthestX, y)
                    end
                
                -- otherwise, just make an ordinary move
                else
                    makeMove(tile, tile.tileX, y, farthestX, y)
                end

                ::continue::
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

                -- check the tile beyond for same num and merge if so
                if farthestX + 1 <= 4 then
                    local farthestTile = grid:getTile(farthestX + 1, y)

                    if farthestTile.num == tile.num then
                        makeMerge(tile, tile.tileX, y, farthestX + 1, y)
                    elseif farthestX ~= x then
                        makeMove(tile, tile.tileX, y, farthestX, y)
                    end

                -- otherwise, just make an ordinary move
                else
                    makeMove(tile, tile.tileX, y, farthestX, y)
                end

                ::continue::
            end
        end
    end
end

function mergeTween(tile)
    grid:getTile(tile.tileX, tile.tileY).num = tile.num * 2

    Timer.tween(0.1, {
        [tile] = {x = grid.grid[tile.tileY][tile.tileX].x, 
                    y = grid.grid[tile.tileY][tile.tileX].y}
    }):finish(function()
        canMove = true
        grid:getTile(tile.tileX, tile.tileY).displayNum = grid:getTile(tile.tileX, tile.tileY).num
        tile.remove = true
        grid:removeDeletedTiles()
    end)
end

function moveTween(tile)
    Timer.tween(0.1, {
        [tile] = {x = grid.grid[tile.tileY][tile.tileX].x, y = grid.grid[tile.tileY][tile.tileX].y}
    }):finish(function()
        canMove = true
    end)
end

function makeMerge(tile, oldX, oldY, newX, newY)
    canMove = false

    tile.tileX = newX
    tile.tileY = newY
    grid:clearTile(oldX, oldY)

    mergeTween(tile)
end

function makeMove(tile, oldX, oldY, newX, newY)
    -- just move over as normal if not combining terms
    canMove = false
    
    tile.tileX = newX
    tile.tileY = newY
    grid:setTile(newX, newY, tile)
    grid:clearTile(oldX, oldY)

    moveTween(tile)
end

function love.draw()
    love.graphics.clear(250/255, 250/255, 238/255, 1)

    grid:render()
end