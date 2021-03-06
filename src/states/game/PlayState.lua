--[[
    Playstate - initializes a player and creates a world
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

        likesCaves = false
    }    
    
    self.player.likesCaves = false
    --init dungeon and pass player table
    self.dungeon = Dungeon(self.player)
    self.player.entity.dungeon = self.dungeon

    gSounds['field-music']:setLooping(true)
    gSounds['field-music']:play()
end

function PlayState:update(dt)
    self.dungeon:update(dt)
end

function PlayState:render()
    -- black background
    love.graphics.clear()
    
    -- render current dungeon and all its stuff (players, entities etc..)
    self.dungeon:render()
end