--[[
    WalkState for entities
]]

PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(entity)
    self.entity = entity
end

function PlayerWalkState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-left')
    elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-right')
    elseif love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('walk-up')
    elseif love.keyboard.isDown('down')  or love.keyboard.isDown('s')then
        self.entity.direction = 'down'
        self.entity:changeAnimation('walk-down')
    else
        self.entity:changeState('idle')
    end

    -- move around
    self.entity:move(dt, self.entity.dungeon)
    
    -- check for collisions with objects
    for i, obj in ipairs(self.entity.dungeon.objects) do
        if self.entity:collides(obj) then
            obj.onCollide()
        end
    end

    -- self.entity:changeState('swing-sword')
end