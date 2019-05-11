GameOverState = Class{__includes = BaseState}

function GameOverState:init()
    -- Instructions
end

function GameOverState:update(dt)

    -- wait for user input
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:pop() -- return to Menu
    end
end

function GameOverState:render()

    love.graphics.clear(0,0,0,0)

    -- display large game Title on screen
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['x-large'])
    self.effect(function()
        love.graphics.printf('YOU HAVE DIED', 0, VIRTUAL_HEIGHT / 2 - 72, VIRTUAL_WIDTH, 'center')
    end)
end