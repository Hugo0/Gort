--[[
    Entity class, manages the direction, movement, ai, etc...
]]

Entity = Class{}

function Entity:init(def)
    -- true x and y position
    self.x = def.x    
    self.y = def.y

    -- proportions
    self.width = def.width
    self.height = def.height

    -- display x and y positions
    self.displayX = self.x
    self.displayY = self.y - (self.height / 2)

    -- tile the entity is in, can only be integer
    self.mapX = def.mapX or 0
    self.mapY = def.mapY or 0

    self.direction = 'down'
    self.animations = self:createAnimations(def.animations)  

    -- references
    self.dungeon = def.dungeon

    -- attributes
    self.walkSpeed = def.walkSpeed or 50

    return self
end

--[[
    Function that is called when an Entity attempts to move. 
    Checks the tiles the entity is currently colliding with and 
    blocks movement in some axis if a solid tile is detected
]]
function Entity:move(dt)
    -- move first and then check for collision
    if self.direction == 'left' then        
        -- adjust position
        self.x = self.x - PLAYER_WALK_SPEED * dt

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
    
    for y = 1, #self.dungeon.tiles do
        for x = 1, #self.dungeon.tiles[y] do
            local tile = self.dungeon.tiles[y][x]
            if tile.solid == 1  then -- if the tile is not solid we ignore it
                if self:collides(tile) then -- if we collide with the tile
                    if self.direction == 'left' and self:targetRelativePosition(tile) == 'left' then
                        -- tp the player so that he doesn't collide anymore
                        self.x = tile.x + tile.width
                    elseif self.direction == 'right' and self:targetRelativePosition(tile) == 'right' then
                        -- tp left of tile
                        self.x = tile.x - self.width
                    elseif self.direction == 'up' and self:targetRelativePosition(tile) == 'up' then
                        -- tp down of tile
                        self.y = tile.y + self.height
                    elseif self.direction == 'down' and self:targetRelativePosition(tile) == 'down' then 
                        self.y = tile.y - self.height
                    end
                end
            end
        end
    end
end

-- AABB collision
function Entity:collides(target)    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

-- returns the relative position of target
function Entity:targetRelativePosition(target)
    local dY = target.y - self.y
    local dX = target.x - self.x

    if math.abs(dY) > math.abs(dX) then
        if dY < 0 then
            return 'up'
        else
            return 'down'
        end
    else
        if dX < 0 then
            return 'left'
        else
            return 'right'
        end
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
    Future use: NPCs
]]
function Entity:onInteract()

end

function Entity:processAI(params, dt)
    self.stateMachine:processAI(params, dt)
end

function Entity:update(dt)
    -- set display Y
    self.displayX = self.x
    self.displayY = self.y - (self.height / 3)
    -- update animation
    self.currentAnimation:update(dt)
    -- update own statemachine
    self.stateMachine:update(dt)
end

function Entity:render()
    self.stateMachine:render()
    
    -- debug
    if gDebug then
        love.graphics.rectangle( 'line', self.x, self.y, self.width, self.height )
    end
end