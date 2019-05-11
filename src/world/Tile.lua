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

    -- collection of ids to draw
    self.ids = def.ids or nil
    self.texture = def.texture or 'dungeon'

    self.solid = def.solid or 1

    self.width = 16
    self.height = 16

end

function Tile:update(dt)

end

function Tile:render()
    -- draw every texture in ids sequentially
    for i, value in ipairs(self.ids) do
        -- set opacity
        love.graphics.setColor( 255, 255, 255, value.opacity or 255 ) 
        -- draw texture
        love.graphics.draw(
            gTextures[value.texture],
            gFrames[value.texture][value.id],
            self.x,
            self.y
        )
        -- reset color
        love.graphics.setColor( 255, 255, 255, 255 ) 
    end
end