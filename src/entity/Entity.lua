--[[
    Entity class, manages the direction, movement, ai, etc...
]]

Entity = Class{}

function Entity:init(def)
    self.direction = 'down'

    self.animations = self:createAnimations(def.animations)

    self.mapX = def.mapX or 0
    self.mapY = def.mapY or 0

    self.width = def.width
    self.height = def.height

    self.x = def.x

    -- attributes
    self.walkSpeed = def.walkSpeed or 50

    -- partially raised on the tile just to simulate height/perspective
    self.y = def.y
    return self
end

function Entity:move(dt, tiles)
    if self.direction == 'left' then        
        -- adjust position
        selfx = self.x - PLAYER_WALK_SPEED * dt

    elseif self.direction == 'right' then        
        -- adjust position
        self.x = self.x + PLAYER_WALK_SPEED * dt

    elseif self.direction == 'up' then
        -- adjust position
        self.y = self.y - PLAYER_WALK_SPEED * dt 
    else        
        -- temporarily adjust position
        self.y = self.y + PLAYER_WALK_SPEED * dt
    end

end

function Entity:changeState(name)
    self.stateMachine:change(name)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Entity:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationsReturned
end

--[[
    Called when we interact with this entity, as by pressing enter.
]]
function Entity:onInteract()

end

function Entity:processAI(params, dt)
    self.stateMachine:processAI(params, dt)
end

function Entity:update(dt)
    self.currentAnimation:update(dt)
    self.stateMachine:update(dt)
end

function Entity:render()
    self.stateMachine:render()
end