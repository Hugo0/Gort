--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()

    -- init player
    self.player = Player {
        animations = ENTITY_DEFS['player'].animations,
        walkSpeed = ENTITY_DEFS['player'].walkSpeed,
        
        -- center the player position
        x = (VIRTUAL_WIDTH / 2) - 8,
        y = (VIRTUAL_HEIGHT / 2) - 8,
        
        width = 16,
        height = 16,

        health = 6,

        -- rendering and collision offset for spaced sprites
        offsetY = 5
    }
    
    --init room and pass player table
    self.room = Room(self.player)

    gSounds['field-music']:setLooping(true)
    gSounds['field-music']:play()
end

function PlayState:update(dt)
    self.room:update(dt)
end

function PlayState:render()
    -- black background
    love.graphics.clear()
    -- render current room and all its stuff (players, entities etc..)
    self.room:render()
end