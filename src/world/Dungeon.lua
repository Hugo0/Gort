--[[
    Dungeon class, holds all the info for current dungeon
]]

Dungeon = Class{}

function Dungeon:init(player)

    -- number of horizontal and vertical tiles
    self.width = 60
    self.height = 60

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

    -- entities in the Dungeon
    self.entities = {}
    self:generateEntities()

    -- game objects in the Dungeon
    self.objects = {}
    self:generateObjects()    

    -- glow effect    
    self.effect = moonshine(moonshine.effects.glow)
    self.effect.glow.strength = 8
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
        math.floor(self.width /5),-- number of rooms
        math.floor(3), -- minWidth of rooms
        math.floor(4), -- maxWidth of rooms
        math.floor(3), -- minHeight of rooms
        math.floor(4) -- maxHeight of rooms
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

    -- -- go through tiles and replace the walls adjacent to floor with better texture
    -- for y = 2, #self.tiles-1 do
    --     for x = 2, #self.tiles[y]-1 do
    --         local tile = self.tiles[y][x]
    --         if tile.solid == 1  then -- if the tile is not solid we ignore it
    --             if self.tiles[y+1][x].solid == 0 or self.tiles[y-1][x].solid == 0  then
    --                 tile.ids = {{texture = 'dungeon', id = 156}}
    --             end
    --             if self.tiles[y][x+1].solid == 0 and self.tiles[y+1][x].solid == 0 then
    --                 tile.ids = {{texture = 'dungeon', id = 159}}
    --             end
    --             if self.tiles[y][x-1].solid == 0 and self.tiles[y+1][x].solid == 0 then
    --                 tile.ids = {{texture = 'dungeon', id = 158}}
    --             end
    --             if self.tiles[y][x-1].solid == 0 and self.tiles[y-1][x].solid == 0 then
    --                 tile.ids = {{texture = 'dungeon', id = 187}}
    --             end
    --             if self.tiles[y][x+1].solid == 0 and self.tiles[y-1][x].solid == 0 then
    --                 tile.ids = {{texture = 'dungeon', id = 188}}
    --             end
    --         end
    --     end
    -- end

    -- insert pretty decoration
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[y] do
            local tile = self.tiles[y][x]
            if tile.solid == 0  then -- if the tile is solid we ignore it
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

    -- spawn entities
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[y] do
            local tile = self.tiles[y][x]
            if tile.solid == 0  then -- if the tile is solid we ignore it
                if math.random(7) == 1 then

                    if self.tiles[y+1][x].solid == 0 and self.tiles[y-1][x].solid == 0
                     and self.tiles[y][x+1].solid == 0 and self.tiles[y][x-1].solid == 0 and
                     self.tiles[y+1][x+1].solid == 0 and self.tiles[y-1][x-1].solid == 0
                     and self.tiles[y-1][x+1].solid == 0 and self.tiles[y+1][x-1].solid == 0 then

                        local type = types[math.random(#types)] -- choose type of entity to spawn
                        
                        table.insert(self.entities, Entity {
                            animations = ENTITY_DEFS[type].animations,
                            walkSpeed = ENTITY_DEFS[type].walkSpeed or 20,

                            -- set x and y
                            x = (x - 1) * TILE_SIZE,
                            y = (y - 1)  * TILE_SIZE,
                            
                            width = 16,
                            height = 16,

                            dungeon = self
                        })

                        local i = #self.entities
                        self.entities[i].stateMachine = StateMachine {
                            ['walk'] = function() return EntityWalkState(self.entities[i]) end,
                            ['idle'] = function() return EntityIdleState(self.entities[i]) end
                        }

                        self.entities[i]:changeState('walk')
                    end
                end
            end
        end
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
                            if gridY ~= 2 then
                                table.insert(self.tiles[gridY-2][gridX].ids, {texture = 'indoors', id = 238, opacity=100} )
                            end
                            exitSpawned = true
                        end
                    end
                end
            end
        end
    end
end


function Dungeon:update(dt)

    -- update entities
    for k, entity in pairs(self.entities) do
        
        entity:processAI(dt)
        entity:update(dt)
        
        -- check for player death
        if self.player:collides(entity) then
            gStateStack:pop()
            gStateStack:push(GameOverState())
        end
    end

    -- update objects
    for k, obj in pairs(self.objects) do
        obj:update(dt)
    end
    
    self.player:update(dt)
    self.camera:follow(self.player)


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

    -- render entities
    for i, entity in ipairs(self.entities) do
        entity:render()
    end
    
    -- render player
    self.player:render()
    

    --[[
        Use Stencils to make progressively larger circles and then paint them black to simulate light
        This is super inelegant, will have to turn this into a function soon
    ]]
    love.graphics.stencil(function ()
        love.graphics.circle("fill", self.player.x + self.player.width/2 , self.player.y, TILE_SIZE*6)
    end, "replace", 6, true)

    love.graphics.stencil(function ()
        love.graphics.circle("fill", self.player.x + self.player.width/2 , self.player.y, TILE_SIZE*5)
    end, "replace", 5, true)

    love.graphics.stencil(function ()
        love.graphics.circle("fill", self.player.x + self.player.width/2 , self.player.y, TILE_SIZE*4)
    end, "replace", 4, true)

    love.graphics.stencil(function ()
        love.graphics.circle("fill", self.player.x + self.player.width/2 , self.player.y, TILE_SIZE*3)
    end, "replace", 3, true)
    
    love.graphics.stencil(function ()
        love.graphics.circle("fill", self.player.x + self.player.width/2 , self.player.y, TILE_SIZE*2)
    end, "replace", 2, true)

    love.graphics.stencil(function ()
        love.graphics.circle("fill", self.player.x + self.player.width/2 , self.player.y, TILE_SIZE)
    end, "replace", 1, true)

    -- paint black all pixels with stencil 0
    love.graphics.setStencilTest("equal", 0)
    love.graphics.setColor(0,0,0,255)
    love.graphics.circle("fill", self.player.x, self.player.y, TILE_SIZE*50)

    
    -- paint a little black all pixels with stencil 1
    love.graphics.setStencilTest("equal", 1)
    love.graphics.setColor(0,0,0,50)
    love.graphics.circle("fill", self.player.x, self.player.y, TILE_SIZE*50)
    
    -- etc
    love.graphics.setStencilTest("equal", 2)
    love.graphics.setColor(0,0,0,100)
    love.graphics.circle("fill", self.player.x, self.player.y, TILE_SIZE*50)
   
    love.graphics.setStencilTest("equal", 3)
    love.graphics.setColor(0,0,0,150)
    love.graphics.circle("fill", self.player.x, self.player.y, TILE_SIZE*50)

    love.graphics.setStencilTest("equal", 4)
    love.graphics.setColor(0,0,0,200)
    love.graphics.circle("fill", self.player.x, self.player.y, TILE_SIZE*50)
    
    love.graphics.setStencilTest("equal", 5)
    love.graphics.setColor(0,0,0,225)
    love.graphics.circle("fill", self.player.x, self.player.y, TILE_SIZE*50)
    
    love.graphics.setStencilTest("equal", 6)
    love.graphics.setColor(0,0,0,240)
    love.graphics.circle("fill", self.player.x, self.player.y, TILE_SIZE*50)

    -- reset stencil test, allow for anything to be drawn
    love.graphics.setStencilTest()

    -- reset camera
    self.camera:unset()
end