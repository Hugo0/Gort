StartState = Class{__includes = BaseState}

function StartState:init()
    gSounds['intro-music']:play()

    -- glow effect    
    self.effect = moonshine(moonshine.effects.glow)
    self.effect.glow.strength = 8

    self.background_timer = 0
end

function StartState:update(dt)    
    self.background_timer = self.background_timer + dt

    -- wait for user input
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:push(MenuState()) -- go to Menu
    end

    
end

function StartState:render()
    -- set background image and update every 0.2 seconds
    local img = gTextures['background_sprites']
    local sx = VIRTUAL_WIDTH / (img:getWidth()/5)
    local sy = VIRTUAL_HEIGHT / (img:getHeight()/3)
    local index = math.floor(self.background_timer*5) % 12 + 1    
    love.graphics.setColor(255, 150, 255, 255)
    love.graphics.draw( img, gFrames['background_sprites'][index], 0, 0, 0, sx, sy )

    -- display large game Title on screen
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['x-large'])
    self.effect(function()
        love.graphics.printf('GORT', 0, VIRTUAL_HEIGHT / 2 - 72, VIRTUAL_WIDTH, 'center')
    end)

    -- glowing text
    love.graphics.setColor(255, 255, 255, 255)    
    love.graphics.setFont(gFonts['medium'])
    self.effect(function()
        -- display bottom text
        love.graphics.printf('Press Enter to start a new game', 0, VIRTUAL_HEIGHT*0.75, VIRTUAL_WIDTH, 'center')
    end)

    -- reset graphic settings
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(255, 255, 255, 255)
end