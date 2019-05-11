--[[
    Global Table with Standard definitions of gameObjects
]]

GAME_OBJECT_DEFS = {
    ['exit'] = {
        type = 'exit',
        texture = 'indoors',
        id = 319,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'default',

        states = {
            ['default'] = {
                id = 319
            }
        },

        onCollide = function ()
            gStateStack:pop() -- go to Menu
            gStateStack:push(VictoryState())
        end
    }
}