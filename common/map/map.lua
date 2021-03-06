local Class = require "common.extra_libs.hump.class"
local MapTile = require "common.map.map_tile"

local Map = Class {}

function Map:init(rows, columns)
    self.rows = rows
    self.columns = columns
    self.grid = {}
    for i = 1, rows do
        self.grid[i] = {}
        for j = 1, columns do
            self.grid[i][j] = MapTile(i, j)
        end
    end
end

function Map:get(r, c)
    return self.grid[r] and self.grid[r][c]
end

return Map
