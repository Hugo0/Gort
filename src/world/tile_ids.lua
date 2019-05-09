--[[
    mapping of tiles so we can later index them in a humane way
]]

TILE_IDS = {
    ['grass'] = {46, 47},
    ['empty'] = 101,
    ['tall-grass'] = 42,
    ['half-tall-grass'] = 50,
    ['dungeon-floor-dirt'] = {365,366,367,368,369},
    ['dungeon-floor-dirt-checkered'] = {394,395,396,397,398},
    ['dungeon-wall-dirt'] = {185}
}

TILE_EMPTY = 3
TILE_TOP_LEFT_CORNER, TILE_BOTTOM_LEFT_CORNER, TILE_TOP_RIGHT_CORNER, 
TILE_BOTTOM_RIGHT_CORNER, TILE_LEFT_WALLS, TILE_RIGHT_WALLS, TILE_TOP_WALLS, 
TILE_BOTTOM_WALLS = 1, 1, 1, 1, 1, 1, 1, 1

TILE_FLOORS = 2