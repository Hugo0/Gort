--[[
    GameObject class, all items and interactables
]]

GameObject = Class{}

function GameObject:init(staticDef, def)
    -- string identifying this object type
    self.type = staticDef.type

    -- texture to use
    self.texture = staticDef.texture
    self.id = def.id or staticDef.id 

    -- whether it solid or not
    self.solid = def.solid or staticDef.solid or false

    -- dimensions
    self.x = def.x
    self.y = def.y
    self.width = def.width or staticDef.width
    self.height = def.height or staticDef.height
    self.displayX = def.displayX or def.x or staticDef.x
    self.displayY = def.displayY or def.y - self.height/3 or staticDef.y


    -- whether it is consumable or collidable
    self.collidable = def.collidable or false
    self.consumable = def.consumable or false

    -- state management for objects
    self.defaultState = staticDef.defaultState or {'default'}
    self.state = self.defaultState 
    self.states = staticDef.states or {default = { id = self.id}}

    -- wheter it is projectile or not
    self.projectile = false or def.projectile
    self.dx = nil or def.dx
    self.dy = nil or def.dy
    self.travelDistance = 0 or def.travelDistance
    self.travelledDistance = 0 or def.travelledDistance
    self.initialX = def.x
    self.initialY = def.y

    -- default empty collision callback
    self.onCollide = def.onCollide or function() end
    -- default empty consume callback
    self.onConsume = def.onConsume or function() end
end

function GameObject:update(dt)
    -- movement if projectile
    if self.projectile then
        if self.dx then
            self.x = self.x + self.dx*dt
            self.travelledDistance = self.travelledDistance + math.abs(self.dx*dt)
        end

        if self.dy then
            self.y = self.y + self.dy*dt
            self.travelledDistance = self.travelledDistance + math.abs(self.dy*dt)
        end
        
        if self.travelledDistance > self.travelDistance then
            self.despawn = true
        end
    end
end 

function GameObject:render()
    
    -- draw the object to screen
    love.graphics.draw(
        gTextures[self.texture],
        gFrames[self.texture][self.states[self.state].id or self.id],
        self.displayX,
        self.displayY)
end
