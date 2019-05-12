--[[
    State for when the player is idle
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:update(dt)


    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        self.entity.direction = 'left'
        self.entity:changeState('walk')
    elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        self.entity.direction = 'right'
        self.entity:changeState('walk')
    elseif love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        self.entity.direction = 'up'
        self.entity:changeState('walk')
    elseif love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        self.entity.direction = 'down'
        self.entity:changeState('walk')
    end
end