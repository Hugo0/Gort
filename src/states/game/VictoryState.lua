VictoryState = Class{__includes = BaseState}

function VictoryState:init()
    -- Instructions
    gSounds['field-music']:stop()

    gSounds['parakeets']:play()    
    gSounds['parakeets']:setLooping(true)
end

function VictoryState:update(dt)

    -- -- wait for user input
    -- if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    --     gSounds['parakeets']:stop(true)
    --     gStateStack:pop() -- return to Menu
    -- end
end

function VictoryState:render()

    love.graphics.clear(0,0,0,0)
    
    
    love.graphics.setColor(100, 100, 100, 255)
    -- set background image and update every 0.2 seconds
    local img = gTextures['forest']
    local sx = VIRTUAL_WIDTH / (img:getWidth())
    local sy = VIRTUAL_HEIGHT / (img:getHeight())
    love.graphics.draw( img, 0, 0, 0, sx, sy )

    -- display dialogue on screen
    love.graphics.setColor( 210, 105, 30, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Congratulations!', 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('You have found your way out of the cave', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')

    
    love.graphics.setColor(255, 0, 0, 255)
    
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Will you now find your way out of the forest? ....', 0, (VIRTUAL_HEIGHT / 4 )* 3, VIRTUAL_WIDTH, 'center')

    
    love.graphics.setColor(255, 255, 255, 255)    
end