--[[
    Utility functions
]]

--[[
    Splits a texture atlas into quads. Takes as input the 
    the tilesize as well as the margin between tiles 
    (1px is good as margin to avoid bleeding)
]]

function GenerateQuads(atlas, tilewidth, tileheight, margin)
    -- calculate how many tiles horizontally
    local sheetWidth = (atlas:getWidth() + margin) / (tilewidth + margin)
    -- calculate how many tiles vertically
    local sheetHeight = (atlas:getHeight() + margin) / (tileheight + margin)
    
    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            -- add new quad at x,y to our table
            spritesheet[sheetCounter] =
                love.graphics.newQuad(
                    x * tilewidth + x*margin, -- x-coordinate of quad
                    y * tileheight + y*margin, -- y-coordinate of quad
                    tilewidth,
                    tileheight,
                    atlas:getDimensions()
                    )
            sheetCounter = sheetCounter + 1
        end
    end
    return spritesheet
end

--[[
    Divides quads we've generated via slicing our tile sheet into separate tile sets.
]]
function GenerateTileSets(quads, setsX, setsY, sizeX, sizeY)
    local tilesets = {}
    local tableCounter = 0
    local sheetWidth = setsX * sizeX
    local sheetHeight = setsY * sizeY

    -- for each tile set on the X and Y
    for tilesetY = 1, setsY do
        for tilesetX = 1, setsX do
            
            -- tileset table
            table.insert(tilesets, {})
            tableCounter = tableCounter + 1

            for y = sizeY * (tilesetY - 1) + 1, sizeY * (tilesetY - 1) + 1 + sizeY do
                for x = sizeX * (tilesetX - 1) + 1, sizeX * (tilesetX - 1) + 1 + sizeX do
                    table.insert(tilesets[tableCounter], quads[sheetWidth * (y - 1) + x])
                end
            end
        end
    end

    return tilesets
end

function rand_id(table)
    return table[math.random(#table)]
end

function print_dim(t)
    y_length = #t
    x_length = #t[1]

    for i in pairs(t) do
        if #t[1] ~= x_length then
            print('this table has inconsistent dimension length')
        else
            print('y_length: ' .. tostring(y_length) .. '  x_length: ' .. tostring(x_length) )
        end        
    end
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

function print_astray_tiles(tiles)
    for y = 0, #tiles[1] do
        local line = ''
        for x = 0, #tiles do
            line = line .. tiles[y][x]
        end
        print(line)
    end
end