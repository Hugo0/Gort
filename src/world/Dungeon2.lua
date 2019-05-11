--[[
    Dungeon class, holds all the information about the current level
]]

Dungeon2 = Class{}

function Dungeon2:init(player)
    self.player = player

    -- love.graphics.translate values, only when shifting screens
    self.cameraX = 0
    self.cameraY = 0
    self.shifting = false

end

function Dungeon2:update(dt)
    -- pause updating if we're in the middle of shifting
    if not self.shifting then    
        self.currentRoom:update(dt)
    else
        -- still update the player animation if we're shifting rooms
        self.player.currentAnimation:update(dt)
    end
end

function Dungeon2:render()
    -- translate the camera to follow the player
        -- -- translate the entire view of the scene to emulate a camera
        -- love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
        -- function PlayState:updateCamera()
        --     -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
        --     -- setting it half the screen to the left of the player so they are in the center
        --     self.camX = math.max(0,
        --         math.min(TILE_SIZE * self.tileMap.width - VIRTUAL_WIDTH,
        --         self.player.x - (VIRTUAL_WIDTH / 2 - 8)))
        
        --     -- adjust background X to move a third the rate of the camera for parallax
        --     self.backgroundX = (self.camX / 3) % 256
        -- end

    self.currentRoom:render()
end