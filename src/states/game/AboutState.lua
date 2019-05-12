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

    -- display text
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['small'])

    local instructions_text = [==[This game is my submission as Final Project for Harvard's CSCI E-23 course. 

    Many thanks to Colton Ogden (cogden@cs50.harvard.edu) and James Barnett (jbarnett@barnettech.com) for the
    great semester and learning experience.

    The codebase is public, you can find the repo at github.com/Hugo0/Gort

    Enjoy!
    ]==]


    love.graphics.printf(instructions_text, 0, VIRTUAL_HEIGHT/4, VIRTUAL_WIDTH, 'center')
end