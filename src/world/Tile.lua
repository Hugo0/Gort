--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Tile = Class{}

function Tile:init(def)
    self.x = def.x or nil
    self.y = def.y or nil
    self.id = def.id or nil
    self.texture = def.texture or 'dungeon'

    self.solid = def.solid or 1


end

function Tile:update(dt)

end

function Tile:render()
    love.graphics.draw(
        gTextures[self.texture],
        gFrames[self.texture][self.id],
        (self.x - 1) * TILE_SIZE,
        (self.y - 1) * TILE_SIZE
    )
end