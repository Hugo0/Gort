--[[
   Player class
   Holds all the information regarding the player
]]

-- inherit all functions from Entity class
Player = Class{__includes = Entity}

function Player:init(def)
    self.entity = Entity.init(self, def)

    -- setup states
    self.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.entity) end,
        ['idle'] = function() return PlayerIdleState(self.entity) end
    }

    -- init the default state
    self:changeState('idle')

end