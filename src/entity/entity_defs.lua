--[[
    Data-driven management of in game entities (players, enemies etc...)
]]

ENTITY_DEFS = {
    ['player'] = {
        walkSpeed = 100,
        animations = {
            ['walk-left'] = {
                frames = {7},
                interval = 0.15,
                texture = 'player'
            },
            ['walk-right'] = {
                frames = {3},
                interval = 0.15,
                texture = 'player'
            },
            ['walk-down'] = {
                frames = {1},
                interval = 0.15,
                texture = 'player'
            },
            ['walk-up'] = {
                frames = {5},
                interval = 0.15,
                texture = 'player'
            },
            ['idle-left'] = {
                frames = {7},
                texture = 'player'
            },
            ['idle-right'] = {
                frames = {3},
                texture = 'player'
            },
            ['idle-down'] = {
                frames = {1},
                texture = 'player'
            },
            ['idle-up'] = {
                frames = {5},
                texture = 'player'
            },
        }
    },
    ['npc'] = {
        animations = {
            ['walk-left'] = {
                frames = {16, 17, 18, 17},
                interval = 0.15,
                texture = 'entities'
            },
            ['walk-right'] = {
                frames = {28, 29, 30, 29},
                interval = 0.15,
                texture = 'entities'
            },
            ['walk-down'] = {
                frames = {4, 5, 6, 5},
                interval = 0.15,
                texture = 'entities'
            },
            ['walk-up'] = {
                frames = {40, 41, 42, 41},
                interval = 0.15,
                texture = 'entities'
            },
            ['idle-left'] = {
                frames = {17},
                texture = 'entities'
            },
            ['idle-right'] = {
                frames = {29},
                texture = 'entities'
            },
            ['idle-down'] = {
                frames = {5},
                texture = 'entities'
            },
            ['idle-up'] = {
                frames = {41},
                texture = 'entities'
            },
        }
    }
}