--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(entity, level)
    EntityWalkState.init(self, entity, level)
end

function PlayerWalkState:enter()
    self:checkForEncounter()

    if not self.encounterFound then
        self:attemptMove()
    end
end

function PlayerWalkState:checkForEncounter()
    local x, y = self.entity.mapX, self.entity.mapY

    -- chance to go to battle if we're walking into a grass tile, else move as normal
    if self.level.grassLayer.tiles[y][x].id == TILE_IDS['tall-grass'] and math.random(10) == 1 then
        self.entity:changeState('idle')

        -- trigger music changes
        gSounds['field-music']:pause()
        gSounds['battle-music']:play()
        
        -- first, push a fade in; when that's done, push a battle state and a fade
        -- out, which will fall back to the battle state once it pushes itself off
        gStateStack:push(
            FadeInState({
                r = 255, g = 255, b = 255,
            }, 1, 
            
            -- callback that will execute once the fade in is complete
            function()
                gStateStack:push(BattleState(self.entity))
                gStateStack:push(FadeOutState({
                    r = 255, g = 255, b = 255,
                }, 1,
            
                function()
                    -- nothing to do or push here once the fade out is done
                end))
            end)
        )

        self.encounterFound = true
    else
        self.encounterFound = false
    end
end

--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(entity, dungeon)
    self.entity = entity
end

function PlayerWalkState:update(dt)
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('walk-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('walk-down')
    else
        self.entity:changeState('idle')
    end

    -- if love.keyboard.wasPressed('space') then
    --     self.entity:changeState('swing-sword')
    -- end

    -- perform base collision detection against walls
    --EntityWalkState.update(self, dt)

    -- if we bumped something when checking collision, check any object collisions

    if self.entity.direction == 'left' then        
        -- adjust position
        self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt

    elseif self.entity.direction == 'right' then        
        -- adjust position
        self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt

    elseif self.entity.direction == 'up' then
        -- adjust position
        self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt 
    else        
        -- temporarily adjust position
        self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
    end
end