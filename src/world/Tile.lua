--[[
    Tile class, stores information about each tile
    as well as :render() and :update() functions
]]

Tile = Class{}

function Tile:init(def)
    self.x = def.x or nil
    self.y = def.y or nil
    self.gridX = def.gridX or nil
    self.gridY = def.gridY or nil

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
        self.x,
        self.y
    )
end