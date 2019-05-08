InstructionsState = Class{__includes = BaseState}

function InstructionsState:init()
    -- Instructions
end

function InstructionsState:update(dt)

    -- wait for user input
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:pop() -- return to Menu
    end
end

function InstructionsState:render()

    love.graphics.clear(0,0,0,0)
end