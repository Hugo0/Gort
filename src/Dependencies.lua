
-- libraries
Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'
moonshine = require 'lib/moonshine'

-- Configuration & Utility
require 'src/constants'
require 'src/StateMachine'
require 'src/Util'

-- Entities
require 'src/entity/entity_defs'
require 'src/entity/Entity'
require 'src/entity/Player'

-- Graphical User Interface
require 'src/gui/Menu'
require 'src/gui/Panel'
require 'src/gui/ProgressBar'
require 'src/gui/Selection'
require 'src/gui/Textbox'

-- State Management
require 'src/states/BaseState'
require 'src/states/StateStack'

require 'src/states/entity/EntityBaseState'
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerWalkState'

require 'src/states/game/DialogueState'
require 'src/states/game/FadeInState'
require 'src/states/game/FadeOutState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'
require 'src/states/game/MenuState'
require 'src/states/game/AboutState'
require 'src/states/game/InstructionsState'

-- world management
require 'src/world/Level'
require 'src/world/tile_ids'
require 'src/world/Tile'
require 'src/world/TileMap'
require 'src/world/Dungeon'
require 'src/world/Room'

-- global textures table
gTextures = {
    -- spritesheets
    ['dungeon'] = love.graphics.newImage('assets/graphics/dungeon.png'),
    ['characters'] = love.graphics.newImage('assets/graphics/characters.png'),
    ['indoors'] = love.graphics.newImage('assets/graphics/indoors.png'),
    ['city'] = love.graphics.newImage('assets/graphics/city.png'),
    ['roguelike'] = love.graphics.newImage('assets/graphics/roguelike.png'),

    -- background images    
    ['background'] = love.graphics.newImage('assets/graphics/background.png'),    
    ['background_sprites'] = love.graphics.newImage('assets/graphics/background_sprites.png')

}

-- global Quads table
gFrames = {
    ['dungeon'] = GenerateQuads(gTextures['dungeon'], 16, 16, 1),
    ['characters'] = GenerateQuads(gTextures['characters'], 16, 16, 1),
    ['indoors'] = GenerateQuads(gTextures['indoors'], 16, 16, 1),
    ['city'] = GenerateQuads(gTextures['city'], 16, 16, 1),
    ['roguelike'] = GenerateQuads(gTextures['roguelike'], 16, 16, 1),

    -- backgrounds 4140 x 1074
    ['background_sprites'] = GenerateQuads(gTextures['background_sprites'], 4140/5, 1074/3, 0)
}

-- global Fonts table
gFonts = {
    ['x-small'] = love.graphics.newFont('assets/fonts/font.ttf', 4),    
    ['small'] = love.graphics.newFont('assets/fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('assets/fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('assets/fonts/font.ttf', 32),   
    ['x-large'] = love.graphics.newFont('assets/fonts/font.ttf', 64)
}

-- global sounds & music table
gSounds = {
    ['field-music'] = love.audio.newSource('assets/sounds/field_music.wav'),
    ['battle-music'] = love.audio.newSource('assets/sounds/battle_music.mp3'),
    ['blip'] = love.audio.newSource('assets/sounds/blip.wav'),
    ['powerup'] = love.audio.newSource('assets/sounds/powerup.wav'),
    ['hit'] = love.audio.newSource('assets/sounds/hit.wav'),
    ['run'] = love.audio.newSource('assets/sounds/run.wav'),
    ['heal'] = love.audio.newSource('assets/sounds/heal.wav'),
    ['exp'] = love.audio.newSource('assets/sounds/exp.wav'),
    ['levelup'] = love.audio.newSource('assets/sounds/levelup.wav'),
    ['victory-music'] = love.audio.newSource('assets/sounds/victory.wav'),
    ['intro-music'] = love.audio.newSource('assets/sounds/intro.mp3')
}