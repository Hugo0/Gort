MenuState = Class{__includes = BaseState}

function MenuState:init()
    
    self.background_timer = 0

    -- main menu
    self.menu = Menu {
        x = 0, 
        y = 0,
        width = VIRTUAL_WIDTH,
        height = VIRTUAL_HEIGHT,
        -- each item needs a text to display and a callback function
        items = {
            {
                text = 'Play',
                onSelect = function()
                    gSounds['run']:play()  
                    gStateStack:push(FadeInState({
                        r = 0, g = 0, b = 0
                    }, 1,
                    function() -- callback for after FadeIn
                        gSounds['intro-music']:stop()
                        gStateStack:push(PlayState())
                    end))
                end
            },
            {
                text = 'Instructions',
                onSelect = function()
                    gSounds['run']:play()  
                    gStateStack:push(FadeInState({
                        r = 0, g = 0, b = 0
                    }, 1,
                    function() -- callback for after FadeIn
                        gStateStack:push(InstructionsState())
                    end))
                end
            },
            {
                text = 'About',
                onSelect = function()
                    gSounds['run']:play()  
                    gStateStack:push(FadeInState({
                        r = 0, g = 0, b = 0
                    }, 1,
                    function() -- callback for after FadeIn
                        gStateStack:push(AboutState())
                    end))
                end
            }, 
            {
                text = 'Return to Menu',
                onSelect = function()
                    gSounds['run']:play()                    
                    -- pop battle menu
                    gStateStack:pop()
                end
            }
        }
    }
end

function MenuState:update(dt)
    self.background_timer = self.background_timer + dt

    self.menu:update(dt)
end

function MenuState:render()
    
    -- set background image and update every 0.2 seconds
    local img = gTextures['background_sprites']
    local sx = VIRTUAL_WIDTH / (img:getWidth()/5)
    local sy = VIRTUAL_HEIGHT / (img:getHeight()/3)
    local index = math.floor(self.background_timer*5) % 12 + 1    
    love.graphics.setColor(
        128 * (math.sin(self.background_timer*0.5) + 1) -1,
        128 * (math.sin(self.background_timer*0.3 + math.pi) + 1) -1,
        128 * (math.sin(self.background_timer*0.7 + math.pi/2) + 1) -1,
        255)
    love.graphics.draw( img, gFrames['background_sprites'][index], 0, 0, 0, sx, sy )

    -- render menu    
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(255, 255, 255, 255)
    self.menu:render()
    
    
    -- reset graphic settings
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(255, 255, 255, 255)
end