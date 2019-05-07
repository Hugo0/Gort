StartState = Class{__includes = BaseState}

function StartState:init()
    gSounds['intro-music']:play()
    
end

function StartState:update(dt)

    -- wait for user input
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:push(FadeInState({
            r = 0, g = 0, b = 0
        }, 1,
        function() -- callback for after FadeIn
            gSounds['intro-music']:stop()        
            gStateStack:push(MenuState()) -- go to Menu
        end))
    end
end

function StartState:render()
    love.graphics.clear(0, 0, 0, 0) -- black background color

    -- display large game Title on screen
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.setFont(gFonts['x-large'])
    love.graphics.printf('GORT', 0, VIRTUAL_HEIGHT / 2 - 72, VIRTUAL_WIDTH, 'center')

    -- display bottom text
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to start a new game', 0, VIRTUAL_HEIGHT*0.75, VIRTUAL_WIDTH, 'center')

    -- reset graphic settings
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(255, 255, 255, 255)
end