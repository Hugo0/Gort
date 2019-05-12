--[[
    State for when the player is idle
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:update(dt)


    if love.keyboard.wasPressed('left') or love.keyboard.wasPressed('a') then
        self.entity.direction = 'left'
        self.entity:changeState('walk')
    elseif love.keyboard.wasPressed('right') or love.keyboard.wasPressed('d') then
        self.entity.direction = 'right'
        self.entity:changeState('walk')
    elseif love.keyboard.wasPressed('up') or love.keyboard.wasPressed('w') then
        self.entity.direction = 'up'
        self.entity:changeState('walk')
    elseif love.keyboard.wasPressed('down') or love.keyboard.wasPressed('s') then
        self.entity.direction = 'down'
        self.entity:changeState('walk')
    end
end