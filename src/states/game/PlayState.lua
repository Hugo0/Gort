--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.room = Room()

    gSounds['field-music']:setLooping(true)
    gSounds['field-music']:play()
end

function PlayState:update(dt)
    self.room:update(dt)
end

function PlayState:render()
    self.room:render()
end