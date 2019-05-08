AboutState = Class{__includes = BaseState}

function AboutState:init()
    -- Instructions
end

function AboutState:update(dt)

    -- wait for user input
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:pop() -- return to Menu
    end
end

function AboutState:render()

    love.graphics.clear(0,0,0,0)
end