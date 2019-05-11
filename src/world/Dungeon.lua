--[[
    Dungeon class, holds all the info for current dungeon
]]

Dungeon = Class{}

function Dungeon:init(player)

    -- number of horizontal and vertical tiles
    self.width = 40
    self.height = 40

    -- player table
    self.player = player

    -- camera to follow the player
    self.camera = Camera {
        x = 0,
        y = 0,
        scaleX = 1,
        scaleY = 1,
        rotation = 0
    }

    --[[ tiles is a 2D matrix where we store all our individual
         tiles, and their attributes: if they are collidable,
         effects they may spawn, etc... ]]
    self.tiles = {}
    self:generateTiles()

    -- set position of player, looping through tiles and finding the first floor tile
    for y=1, self.height do
        for x=1, self.width do
            if self.tiles[y][x].solid == 0 then
                -- set player position to this floor tile
                self.player.x = self.tiles[y][x].x
                self.player.y = self.tiles[y][x].y

                goto continue
            end
        end
    end
    ::continue::

    -- -- entities in the Dungeon
    -- self.entities = {}
    -- self:generateEntities()

    -- game objects in the Dungeon
    self.objects = {}
    self:generateObjects()    
end

--[[
    Generates the walls and floors of the Dungeon, randomizing the various varieties
    of said tiles for visual variety.
]]
function Dungeon:generateTiles()

    -- Maze generator to generate uneven maps
    -- Astray:new(width/2-1, height/2-1, changeDirectionModifier 
    local generator = astray.Astray:new(
        self.width/2, self.height/2,
        30, 70, 50, -- (1-30), sparsenessModifier (25-70), deadEndRemovalModifier (70-99) )
        astray.RoomGenerator:new(--rooms, minWidth, maxWidth, minHeight, maxHeight
        math.floor(self.width /10),-- number of rooms
        math.floor(self.width /20), -- minWidth of rooms
        math.floor(self.width /10), -- maxWidth of rooms
        math.floor(self.height /20), -- minHeight of rooms
        math.floor(self.height /10) -- maxHeight of rooms
    ))
    local astray_dungeon = generator:Generate()
    local astray_tiles = generator:CellToTiles(astray_dungeon)
    print_astray_tiles(astray_tiles)

    -- convert our newly generated dungeon into a spritesheet table
    for gridY = 1, self.height + 1 do       
        table.insert(self.tiles, {}) -- 1D Vector 
        
        for gridX = 1, self.width + 1 do
            local astray_tile = astray_tiles[gridY-1][gridX-1]

            -- values that the tile will take
            local id = 1
            local texture = 'dungeon'
            local solid = 1

            if astray_tile == '#' then
                id = rand_id(TILE_IDS['dungeon-wall-dirt'])
                local texture = 'dungeon'
                solid = 1
                
            elseif astray_tile == ' ' then                
                id = rand_id(TILE_IDS['dungeon-floor-dirt'])
                local texture = 'dungeon'
                solid = 0
            else
                id = rand_id(TILE_IDS['dungeon-floor-dirt-checkered'])
                local texture = 'dungeon'
                solid = 0
            end

            -- insert the tile
            table.insert(self.tiles[gridY], 
                Tile {
                    gridX = gridX,                    
                    gridY = gridY,
                    x = (gridX - 1) * TILE_SIZE,
                    y = (gridY - 1) * TILE_SIZE,
                    ids = {{texture = texture, id = id}},
                    solid = solid
                }
            )
        end
    end

    -- insert pretty decoration
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[y] do
            local tile = self.tiles[y][x]
            if tile.solid == 0  then -- if the tile is not solid we ignore it
                if math.random(10) == 1 then
                    table.insert(tile.ids, {texture = 'dungeon', id = rand_id(TILE_IDS['champignons'])} )
                elseif math.random(10) == 1 then
                    table.insert(tile.ids, {texture = 'dungeon', id = rand_id(TILE_IDS['bones'])} )
                end
            end
        end
    end
end

--[[
    Randomly creates an assortment of enemies for the player to fight.
]]
function Dungeon:generateEntities()
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
function Dungeon:generateObjects()
    
    -- insert exit    
    local exitSpawned = false
    while not exitSpawned do
        for gridY = #self.tiles, 1, -1 do
            for gridX = #self.tiles[gridY], 1, -1  do
                local tile = self.tiles[gridY][gridX]
                if tile.solid == 0  then -- if the tile is not solid we ignore it
                    if math.random(self.width) == 1 then
                        if not exitSpawned then                  
                            -- add the exit
                            table.insert(self.objects, GameObject(GAME_OBJECT_DEFS['exit'], {
                                x = (gridX - 1) * TILE_SIZE,
                                y = (gridY - 1) * TILE_SIZE,
                                onCollide = function()
                                    gSounds['heal']:play()
                                    gStateStack:pop()
                                    gStateStack:push(VictoryState( ))
                                end
                            }))
                            table.insert(self.tiles[gridY-1][gridX].ids, {texture = 'indoors', id = 292, opacity=150} )
                            table.insert(self.tiles[gridY-2][gridX].ids, {texture = 'indoors', id = 238, opacity=100} )
                            exitSpawned = true
                        end
                    end
                end
            end
        end
    end
end


function Dungeon:update(dt)
    
    self.player:update(dt)
    self.camera:follow(self.player)

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

function Dungeon:render()
    -- set camera
    self.camera:set()

    -- render all the tiles
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            local tile = self.tiles[y][x]
            tile:render()
        end
    end

    -- render objects
    for i, object in ipairs(self.objects) do
        object:render()
    end

    -- -- render entities
    -- for k, entity in pairs(self.entities) do
    --     if not entity.dead then entity:render(self.adjacentOffsetX, self.adjacentOffsetY) end
    -- end
    
    -- render player
    self.player:render()

    -- lighting system
    -- Each pixel touched by the circle will have its stencil value set to 1. The rest will be 0.
    love.graphics.stencil(function () 
        
        love.graphics.setColor(0,0,0,50)
        love.graphics.circle("fill", self.player.x + self.player.width/2 , self.player.y, TILE_SIZE*2)
    end, "replace", 1)

    -- Configure the stencil test to only allow rendering on pixels whose stencil value is equal to 0.
    -- This will end up being every pixel *except* ones that were touched by the circle drawn as a stencil.
    love.graphics.setStencilTest("equal", 0)
    love.graphics.setColor(0,0,0,200)
    love.graphics.circle("fill", self.player.x, self.player.y, TILE_SIZE*50)
    love.graphics.setStencilTest()

    -- -- reset camera
    self.camera:unset()
end