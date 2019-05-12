--[[
    World class, will be used to hold the world information (dungeons, towns, etc...)
]]

World = Class{}

function World:init(player)
    self.player = player
end

function World:update(dt)
    
end

function World:render()

    self.dungeon:render()
end