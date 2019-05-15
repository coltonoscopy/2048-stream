--[[
    Tile Class
]]

Tile = Class{}

TILE_COLORS = {
    [2] = {
        ['fill'] = {r = 238, g = 228, b = 218},
        ['font'] = {r = 119, g = 110, b = 101}
    },
    [4] = {
        ['fill'] = {r = 238, g = 224, b = 200},
        ['font'] = {r = 119, g = 110, b = 101}
    },
    [8] = {
        ['fill'] = {r = 242, g = 177, b = 121},
        ['font'] = {r = 249, g = 246, b = 242}
    },
    [16] = {
        ['fill'] = {r = 245, g = 149, b = 100},
        ['font'] = {r = 249, g = 246, b = 242}
    },
    [32] = {
        ['fill'] = {r = 246, g = 124, b = 95},
        ['font'] = {r = 249, g = 246, b = 242}
    },
    [64] = {
        ['fill'] = {r = 246, g = 94, b = 59},
        ['font'] = {r = 249, g = 246, b = 242}
    },
    [128] = {
        ['fill'] = {r = 242, g = 216, b = 106},
        ['font'] = {r = 249, g = 246, b = 242}
    },
    [256] = {
        ['fill'] = {r = 237, g = 204, b = 98},
        ['font'] = {r = 249, g = 246, b = 242}
    },
    [512] = {
        ['fill'] = {r = 229, g = 192, b = 42},
        ['font'] = {r = 249, g = 246, b = 242}
    },
    [1024] = {
        ['fill'] = {r = 226, g = 185, b = 19},
        ['font'] = {r = 249, g = 246, b = 242}
    },
    [2048] = {
        ['fill'] = {r = 236, g = 196, b = 2},
        ['font'] = {r = 249, g = 246, b = 242}
    }
}

function Tile:init(tileX, tileY, x, y)
    self.tileX = tileX
    self.tileY = tileY
    self.x = x
    self.y = y
    self.num = math.random(2) == 1 and 2 or 4
    self.displayNum = self.num
end

function Tile:update(dt)

end

function Tile:render()
    local fillColor = TILE_COLORS[self.num]['fill']
    love.graphics.setColor(fillColor.r/255, fillColor.g/255, fillColor.b/255, 1)
    love.graphics.rectangle('fill', self.x, self.y, GRID_TILE_SIZE, GRID_TILE_SIZE, 10, 10, 3)

    local fontColor = TILE_COLORS[self.num]['font']
    love.graphics.setColor(fontColor.r/255, fontColor.g/255, fontColor.b/255, 1)
    love.graphics.printf(self.displayNum, self.x, 
        self.y + GRID_TILE_SIZE / 2 - font:getHeight() / 2, GRID_TILE_SIZE, 'center')
end