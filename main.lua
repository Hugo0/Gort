--[[
    Gort -- Final project for GD50

    Author: Hugo Fernandez-Montenegro
    Email:  gort@hmontenegro.com

    Gort is a game in the roguelike genre. Main objective is to get to the end of the dungeon
    and gain the magical artifact. On the way there, evil monsters have to be fought.
    Gort (the name of game and also of the playable character) can also sometimes get some good 
    items from the enemies he slays.
    

    Credit for art:
    Buch - https://opengameart.org/users/buch (tile sprites)
    Kenney - https://kenney.nl/assets/roguelike-caves-dungeons 

    Credit for music:
    Field: https://freesound.org/people/Mrthenoronha/sounds/371843/
    Battle: https://freesound.org/people/Sirkoto51/sounds/414214/
]]

-- import all the libraries and source code
require 'src/Dependencies'

function love.load()
    love.window.setTitle('Gort')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())

    -- setup the window
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = true,
        vsync = true,
        resizable = true
    })

    --[[
    To manage states in the game, we implement a global state stack. Only the 
    top state is updated at any time. We start with the aptly named StartState
    ]]--
    gStateStack = StateStack()
    gStateStack:push(StartState()) -- start with Startstate

    love.keyboard.keysPressed = {}
end

-- resizes current window
function love.resize(w, h)
    push:resize(w, h)
end


function love.keypressed(key)

    -- quit the game on ESC
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

-- function to check for user input
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

-- this function gets called every frame by Löve2D
function love.update(dt)
    Timer.update(dt)
    gStateStack:update(dt)

    -- reset the keysPressed table
    love.keyboard.keysPressed = {}
end

-- this function also gets called every frame by Löve2D
function love.draw()
    -- set resolution and screen width etc
    push:start()

    -- -- set camera
    -- if gCamera then
    --     gCamera:set()
    -- end
    -- render all the stacks
    gStateStack:render()

    -- -- reset camera
    -- if gCamera then
    --     gCamera:unset()
    -- end

    push:finish()
end