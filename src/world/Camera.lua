--[[
    Camera to follow the player around
]]
Camera = Class{}

function Camera:init(def)
    self.x = def.x or 0
    self.y = def.y or 0
    self.scaleX = def.scaleX or 1
    self.scaleY = def.scaleY or 1
    self.rotation = def.rotation or 1
end

-- set camera to follow entity (probably player)
-- this took me SO LONG to get right
function Camera:follow(entity, marginX, marginY)
    -- margin we allow until we move the camera
    local marginX = margin or (VIRTUAL_WIDTH / 10)
    local marginY = margin or (VIRTUAL_HEIGHT / 10)

    -- calculate difference
    local offsetX = entity.x - (self.x + VIRTUAL_WIDTH/2)
    local offsetY = entity.y - (self.y + VIRTUAL_HEIGHT/2)

    -- follow player around
    if offsetX > marginX then -- player is to the right
        self.x = math.floor(entity.x - marginX - VIRTUAL_WIDTH / 2 )
    elseif offsetX < -marginX then -- player is to the left
        self.x = math.floor(entity.x + marginX - VIRTUAL_WIDTH / 2 )
    end
    if offsetY > marginY then -- player is topside
        self.y = math.floor(entity.y - marginY - VIRTUAL_HEIGHT / 2 )
    elseif offsetY < -marginY then -- player is bottomside
        self.y = math.floor(entity.y + marginY - VIRTUAL_HEIGHT / 2 )
    end
end

-- move camera by some amount
function Camera:move(dx, dy)
    self.x = self.x + (dx or 0)
    self.y = self.y + (dy or 0)
end

-- set camera rotation
function Camera:rotate(dr)
    self.rotation = self.rotation + dr
end

-- modify position
function Camera:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
end

-- modify scale
function Camera:setScale(sx, sy)
    self.scaleX = sx or self.scaleX
    self.scaleY = sy or self.scaleY
end

-- multiply scale by factor
function Camera:multiplyScale(sx, sy)
    sx = sx or 1
    self.scaleX = self.scaleX * sx
    self.scaleY = self.scaleY * (sy or sx)
end

-- setup camera
function Camera:set()
    love.graphics.push()
    love.graphics.rotate(-self.rotation)
    love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
    love.graphics.translate(-self.x, -self.y)
end

-- reset the camera (pop it from stack)
function Camera:unset()
    love.graphics.pop()
end