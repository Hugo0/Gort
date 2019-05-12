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

    self.hitboxX = def.hitboxX or self.x + 2
    self.hitboxY = def.hitboxY or self.y + 2
    self.hitboxWidth = def.hitboxWidth or  self.width - 4
    self.hitboxHeight = def.hitboxHeight or self.height - 4

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

    self.likesCaves = def.likesCaves or true

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
        self.x = self.x - self.walkSpeed * dt

    elseif self.direction == 'right' then        
        -- adjust position
        self.x = self.x + self.walkSpeed * dt

    elseif self.direction == 'up' then
        -- adjust position
        self.y = self.y - self.walkSpeed * dt 
    else        
        -- temporarily adjust position
        self.y = self.y + self.walkSpeed * dt
    end
    
    for y = 1, #self.dungeon.tiles do
        for x = 1, #self.dungeon.tiles[y] do
            local tile = self.dungeon.tiles[y][x]
            if tile.solid == 1  then -- if the tile is not solid we ignore it
                if self:collides(tile) then -- if we collide with the tile
                    if self.direction == 'left' and self:targetRelativePosition(tile) == 'left' then
                        -- tp the player so that he doesn't collide anymore
                        self.x = tile.x + self.hitboxWidth
                    elseif self.direction == 'right' and self:targetRelativePosition(tile) == 'right' then
                        -- tp left of tile
                        self.x = tile.x - self.hitboxWidth
                    elseif self.direction == 'up' and self:targetRelativePosition(tile) == 'up' then
                        -- tp down of tile
                        self.y = tile.y + self.hitboxHeight
                    elseif self.direction == 'down' and self:targetRelativePosition(tile) == 'down' then 
                        self.y = tile.y - self.hitboxHeight
                    end
                end
            end
            if tile.solid == 0  then 
                if self:collides(tile) then
                    if self.likesCaves == true then
                        local counter = 0
                        if self.dungeon.tiles[y+1][x].solid == 1 then
                            counter = counter + 1
                        end
                        if self.dungeon.tiles[y-1][x].solid == 1 then
                            counter = counter + 1
                        end
                        if self.dungeon.tiles[y][x+1].solid == 1 then
                            counter = counter + 1
                        end
                        if self.dungeon.tiles[y][x-1].solid == 1 then
                            counter = counter + 1
                        end
                        
                        if counter == 2 then


                            if self.direction == 'left' and self:targetRelativePosition(tile) == 'left' then
                                -- tp the player so that he doesn't collide anymore
                                self.x = tile.x + self.hitboxWidth
                            elseif self.direction == 'right' and self:targetRelativePosition(tile) == 'right' then
                                -- tp left of tile
                                self.x = tile.x - self.hitboxWidth
                            elseif self.direction == 'up' and self:targetRelativePosition(tile) == 'up' then
                                -- tp down of tile
                                self.y = tile.y + self.hitboxHeight
                            elseif self.direction == 'down' and self:targetRelativePosition(tile) == 'down' then 
                                self.y = tile.y - self.hitboxHeight
                            end
                        end
                    end
                end
            end
        end        
    end
end

-- if tile.solid == 0  then 
--     if self.likesCaves == true then
--         if self.dungeon.tiles[y+1][x].solid == 0 then
--             if self.direction == 'up'  then
--                 -- tp down of tile
--                 self.y = tile.y + self.hitboxHeight
--             end
--         end
--         if self.dungeon.tiles[y-1][x].solid == 0 then
--             if self.direction == 'down'  then
--                 -- tp down of tile
--                 self.y = tile.y - self.hitboxHeight
--             end
--         end
--         if self.dungeon.tiles[y][x+1].solid == 0 then
--             if self.direction == 'right'  then
--                 -- tp down of tile
--                 self.x = tile.x + self.hitboxWidth
--             end
--         end
--         if self.dungeon.tiles[y][x-1].solid == 0 then
--             if self.direction == 'left'  then
--                 -- tp down of tile
--                 self.x = tile.x - self.hitboxWidth
--             end
--         end
--     end
-- end

-- AABB collision
function Entity:collides(target)    
    return not (self.hitboxX + self.hitboxWidth < target.x or self.hitboxX > target.x + target.width or
                self.hitboxY + self.hitboxHeight < target.y or self.hitboxY > target.y + target.height)
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

    -- update the hitbox
    self.hitboxX = self.x + 2
    self.hitboxY = self.y + 2

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