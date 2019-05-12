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

    -- display text on screen
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['small'])

    local instructions_text = [==[Welcome to Gort! You have awoken in a dark cave, with nothing on but your clothes.
    
    Will you manage to navigate yourself through the perils and find a way out?
    
    
    You control your character either with WASD or the arrow keys.

    Explore the cave and find your way out!


    Press ENTER to return to Menu
    ]==]


    love.graphics.printf(instructions_text, 0, VIRTUAL_HEIGHT/4, VIRTUAL_WIDTH, 'center')
end