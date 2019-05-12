--[[
    TileMap, for collections of Tiles
    
]]

TileMap = Class{}

function TileMap:init(width, height)
    self.tiles = {}
    self.width = width
    self.height = height
end

function TileMap:render()
    for y = 1, self.height do
        for x = 1, self.width do
            self.tiles[y][x]:render()
        end
    end
end