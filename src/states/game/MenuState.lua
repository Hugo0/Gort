MenuState = Class{__includes = BaseState}

function MenuState:init()
    
end

function MenuState:update(dt)

    -- wait for user input
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        print('pressed')
    end
end

function MenuState:render()

    -- set background image
    local img = gTextures['background']
    local sx = VIRTUAL_WIDTH / img:getWidth()
    local sy = VIRTUAL_HEIGHT / img:getHeight()
    love.graphics.draw(gTextures['background'], 0, 0, 0, sx, sy)

    -- -- display large game Title on screen
    -- love.graphics.setColor(255, 0, 0, 255)
    -- love.graphics.setFont(gFonts['x-large'])
    -- love.graphics.printf('GORT', 0, VIRTUAL_HEIGHT / 2 - 72, VIRTUAL_WIDTH, 'center')

    -- -- display bottom text
    -- love.graphics.setFont(gFonts['medium'])
    -- love.graphics.printf('Press Enter to start a new game', 0, VIRTUAL_HEIGHT*0.75, VIRTUAL_WIDTH, 'center')

    -- -- reset graphic settings
    -- love.graphics.setFont(gFonts['small'])
    -- love.graphics.setColor(255, 255, 255, 255)
end