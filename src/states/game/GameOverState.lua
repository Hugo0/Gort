GameOverState = Class{__includes = BaseState}

function GameOverState:init()    
    gSounds['field-music']:stop()

    gSounds['tragic-music']:play()    
    gSounds['tragic-music']:setLooping(true)
end

function GameOverState:update(dt)

    -- wait for user input
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['tragic-music']:stop() 
        gStateStack:pop() -- return to Menu
    end
end

function GameOverState:render()

    love.graphics.clear(0,0,0,0)

    -- display large game Title on screen
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('YOU HAVE DIED', 0, VIRTUAL_HEIGHT / 2 - 72, VIRTUAL_WIDTH, 'center')

    
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Alone and forgotten...', 0, VIRTUAL_HEIGHT* 0.5, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press ENTER to try again', 0, math.floor(VIRTUAL_HEIGHT*0.9) , VIRTUAL_WIDTH, 'center')
end