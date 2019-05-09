--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Room = Class{}

function Room:init(player)

    -- number of horizontal and vertical tiles
    self.width = 16
    self.height = 16

    -- reference to player for collisions, etc.
    self.player = player
    --self.player:changeState('idle')

    --[[ tiles is a 2D matrix where we store all our individual
         tiles, and their attributes: if they are collidable,
         effects they may spawn, etc... ]]
    self.tiles = {}
    self:generateTiles()

    -- -- entities in the room
    -- self.entities = {}
    -- self:generateEntities()

    -- -- game objects in the room
    -- self.objects = {}
    -- self:generateObjects()    

    -- -- used for centering the dungeon rendering
    -- self.renderOffsetX = MAP_RENDER_OFFSET_X
    -- self.renderOffsetY = MAP_RENDER_OFFSET_Y
end

--[[
    Generates the walls and floors of the room, randomizing the various varieties
    of said tiles for visual variety.
]]
function Room:generateTiles()

    -- Maze generator to generate uneven maps
    -- Astray:new(width/2-1, height/2-1, changeDirectionModifier (1-30), sparsenessModifier (25-70), deadEndRemovalModifier (70-99) ) | RoomGenerator:new(rooms, minWidth, maxWidth, minHeight, maxHeight)
    local generator = astray.Astray:new(
        self.width/2, self.height/2,
        30, 70, 50,
        astray.RoomGenerator:new(4, 2, 4, 2, 4))
    local astray_dungeon = generator:Generate()
    local astray_tiles = generator:CellToTiles(astray_dungeon)
    print_astray_tiles(astray_tiles)

    -- convert our newly generated dungeon into a spritesheet table
    for y = 1, self.height do       
        table.insert(self.tiles, {}) -- 1D Vector 
        local id = 1     

        for x = 1, self.width do
            local astray_tile = astray_tiles[y][x]

            if astray_tile == '#' then
                id = rand_id(TILE_IDS['dungeon-wall-dirt'])
            elseif astray_tile == ' ' then                
                id = rand_id(TILE_IDS['dungeon-floor-dirt'])
            else
                id = rand_id(TILE_IDS['dungeon-floor-dirt-checkered'])
            end

            -- insert the tile
            table.insert(self.tiles[y], {
                id = id
            })
        end
    end
end

--[[
    Randomly creates an assortment of enemies for the player to fight.
]]
function Room:generateEntities()
    local types = {'skeleton', 'slime', 'bat', 'ghost', 'spider'}

    for i = 1, 10 do
        local type = types[math.random(#types)]

        table.insert(self.entities, Entity {
            animations = ENTITY_DEFS[type].animations,
            walkSpeed = ENTITY_DEFS[type].walkSpeed or 20,

            -- ensure X and Y are within bounds of the map
            x = math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
            y = math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16),
            
            width = 16,
            height = 16,

            health = 1
        })

        self.entities[i].stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(self.entities[i]) end,
            ['idle'] = function() return EntityIdleState(self.entities[i]) end
        }

        self.entities[i]:changeState('walk')
    end
end

--[[
    Randomly creates an assortment of obstacles for the player to navigate around.
]]
function Room:generateObjects()
    -- add the switch
    table.insert(self.objects, GameObject(
        GAME_OBJECT_DEFS['switch'],
        math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                    VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
        math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                    VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
    ))
    -- add the pot
    table.insert(self.objects, GameObject(GAME_OBJECT_DEFS['pot'],
        math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                    VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
        math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                    VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)))

    -- get a reference to the switch
    local switch = self.objects[1]

    -- define a function for the switch that will open all doors in the room
    switch.onCollide = function()
        if switch.state == 'unpressed' then
            switch.state = 'pressed'
            
            -- open every door in the room if we press the switch
            for k, doorway in pairs(self.doorways) do
                doorway.open = true
            end

            gSounds['door']:play()
        end
    end
end


function Room:update(dt)
    
    self.player:update(dt)

    -- for i = #self.entities, 1, -1 do
    --     local entity = self.entities[i]

    --     -- remove entity from the table if health is <= 0
    --     -- We never actually remove the entity from the table! Spent a lot of time figuring this one out :(
    --     -- I was spawning like 1500 hearts 
    --     if entity.health <= 0 then
    --         -- spawn a heart with a % chance
    --         if math.random(5) == 1 and not entity.dead then
    --             print('-------')
                
    --             table.insert(self.objects, GameObject(
    --                 GAME_OBJECT_DEFS['heart'], entity.x, entity.y))
    --         end
            
    --         entity.dead = true

    --     elseif not entity.dead then
    --         entity:processAI({room = self}, dt)
    --         entity:update(dt)
    --     end

    --     -- collision between the player and entities in the room
    --     if not entity.dead and self.player:collides(entity) and not self.player.invulnerable then
    --         gSounds['hit-player']:play()
    --         self.player:damage(1)
    --         self.player:goInvulnerable(1.5)

    --         if self.player.health == 0 then
    --             gStateMachine:change('game-over')
    --         end
    --     end
    -- end

    -- for k, object in pairs(self.objects) do
    --     object:update(dt)
    --     if object.despawn then
    --         table.remove(self.objects, k)
    --         self.pot =  false
    --     end

    --     -- check for collision between projectiles and entities
    --     if object.projectile == true then
    --         for i = #self.entities, 1, -1 do
    --             local entity = self.entities[i]

    --             if entity:collides(object) then
    --                 if entity ~= self.player then
    --                     entity:damage(1)
    --                     gSounds['hit-enemy']:play()
    --                     -- despawn object
    --                     table.remove(self.objects, k)
    --                     self.pot =  false
    --                 end
    --             end

    --             object:bumpedWall()
    --             if object.bumped then                    
    --                 table.remove(self.objects, k)
    --             end
    --         end
    --     end

    --     -- trigger collision callback on object
    --     if self.player:collides(object) then
    --         object:onCollide()
    --         -- if object is solid then the player can't walk into it
    --         -- determine the direction from which the player is coming from
    --         if object.solid then
    --             -- get the highest diff and not let them move on that axis
    --             -- is there a better way to do this?
    --             index, max = getMaxAbsIndexValue({
    --                 self.player.x - object.x,
    --                 self.player.y - object.y
    --                 })
    --             -- x axis
    --             if index == 1 then
    --                 if self.player.x < object.x then
    --                     self.player.x = object.x - 16
    --                 else
    --                     self.player.x = object.x + 16
    --                 end
    --             -- y axis
    --             elseif index == 2 then
    --                 if self.player.y < object.y then
    --                     print('player < objecty, moving player down to objecty-16')
    --                     print(self.player.y, object.y)
    --                     self.player.y = object.y - 22
    --                 else
    --                     self.player.y = object.y + 6
    --                 end                   
    --             end
    --         end

    --         -- check if it's the pot and pick it up
    --         if object.type == 'pot' then                
    --             if love.keyboard.wasPressed('return') then
    --                 self.pot = object
    --                 self.player:changeState('carry-pot') -- carry the pot
    --             end
    --         end

    --         -- if object is consumable then consume it
    --         if object.consumable then
    --             -- add health to player object
    --             self.player.health = object:onConsume(self.player)
    --             -- despawn object
    --             table.remove(self.objects, k)
                
    --             print(#self.objects)
    --         end
    --     end
    -- end
end

function Room:render()
    
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            love.graphics.draw(
                gTextures['dungeon'], -- Texture
                gFrames['dungeon'][tile.id], -- Quad
                (x - 1) * TILE_SIZE,-- + self.renderOffsetX + self.adjacentOffsetX, -- x
                (y - 1) * TILE_SIZE --+ self.renderOffsetY + self.adjacentOffsetY -- y
            )
        end
    end

    -- -- render objects
    -- for k, object in pairs(self.objects) do
    --     object:render(self.adjacentOffsetX, self.adjacentOffsetY)
    -- end

    -- -- render entities
    -- for k, entity in pairs(self.entities) do
    --     if not entity.dead then entity:render(self.adjacentOffsetX, self.adjacentOffsetY) end
    -- end
    
    -- render player
    self.player:render()
end