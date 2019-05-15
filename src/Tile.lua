--[[
    Tile Class
]]

Tile = Class{}

function Tile:init(tileX, tileY, x, y)
    self.tileX = tileX
    self.tileY = tileY
    self.x = x
    self.y = y
    self.num = math.pow(2, math.random(10))
    self.displayNum = self.num
end

function Tile:update(dt)

end

function Tile:render()
    love.graphics.setColor(238/255, 228/255, 218/255, 1)
    love.graphics.rectangle('fill', self.x, self.y, GRID_TILE_SIZE, GRID_TILE_SIZE, 10, 10, 3)

    love.graphics.setColor(119/255, 110/255, 101/255, 1)
    love.graphics.printf(self.displayNum, self.x, 
        self.y + GRID_TILE_SIZE / 2 - font:getHeight() / 2, GRID_TILE_SIZE, 'center')
end