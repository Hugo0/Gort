--[[
    Data-driven management of in game entities (players, enemies etc...)
]]

ENTITY_DEFS = {
    ['player'] = {
        walkSpeed = 50,
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
    },
    ['skeleton'] = {
        texture = 'entities',
        animations = {
            ['walk-left'] = {
                frames = {22, 23, 24, 23},
                interval = 0.2
            },
            ['walk-right'] = {
                frames = {34, 35, 36, 35},
                interval = 0.2
            },
            ['walk-down'] = {
                frames = {10, 11, 12, 11},
                interval = 0.2
            },
            ['walk-up'] = {
                frames = {46, 47, 48, 47},
                interval = 0.2
            },
            ['idle-left'] = {
                frames = {23}
            },
            ['idle-right'] = {
                frames = {35}
            },
            ['idle-down'] = {
                frames = {11}
            },
            ['idle-up'] = {
                frames = {47}
            }
        }
    },
    ['slime'] = {
        walkSpeed = 20,
        texture = 'entities',
        animations = {
            ['walk-left'] = {
                frames = {61, 62, 63, 62},
                interval = 0.2
            },
            ['walk-right'] = {
                frames = {73, 74, 75, 74},
                interval = 0.2
            },
            ['walk-down'] = {
                frames = {49, 50, 51, 50},
                interval = 0.2
            },
            ['walk-up'] = {
                frames = {86, 86, 87, 86},
                interval = 0.2
            },
            ['idle-left'] = {
                frames = {62}
            },
            ['idle-right'] = {
                frames = {74}
            },
            ['idle-down'] = {
                frames = {50}
            },
            ['idle-up'] = {
                frames = {86}
            }
        }
    },
    ['bat'] = {
        texture = 'entities',
        animations = {
            ['walk-left'] = {
                frames = {64, 65, 66, 65},
                interval = 0.2
            },
            ['walk-right'] = {
                frames = {76, 77, 78, 77},
                interval = 0.2
            },
            ['walk-down'] = {
                frames = {52, 53, 54, 53},
                interval = 0.2
            },
            ['walk-up'] = {
                frames = {88, 89, 90, 89},
                interval = 0.2
            },
            ['idle-left'] = {
                frames = {64, 65, 66, 65},
                interval = 0.2
            },
            ['idle-right'] = {
                frames = {76, 77, 78, 77},
                interval = 0.2
            },
            ['idle-down'] = {
                frames = {52, 53, 54, 53},
                interval = 0.2
            },
            ['idle-up'] = {
                frames = {88, 89, 90, 89},
                interval = 0.2
            }
        }
    },
    ['ghost'] = {
        texture = 'entities',
        animations = {
            ['walk-left'] = {
                frames = {67, 68, 69, 68},
                interval = 0.2
            },
            ['walk-right'] = {
                frames = {79, 80, 81, 80},
                interval = 0.2
            },
            ['walk-down'] = {
                frames = {55, 56, 57, 56},
                interval = 0.2
            },
            ['walk-up'] = {
                frames = {91, 92, 93, 92},
                interval = 0.2
            },
            ['idle-left'] = {
                frames = {68}
            },
            ['idle-right'] = {
                frames = {80}
            },
            ['idle-down'] = {
                frames = {56}
            },
            ['idle-up'] = {
                frames = {92}
            }
        }
    },
    ['spider'] = {
        texture = 'entities',
        animations = {
            ['walk-left'] = {
                frames = {70, 71, 72, 71},
                interval = 0.2
            },
            ['walk-right'] = {
                frames = {82, 83, 84, 83},
                interval = 0.2
            },
            ['walk-down'] = {
                frames = {58, 59, 60, 59},
                interval = 0.2
            },
            ['walk-up'] = {
                frames = {94, 95, 96, 95},
                interval = 0.2
            },
            ['idle-left'] = {
                frames = {71}
            },
            ['idle-right'] = {
                frames = {83}
            },
            ['idle-down'] = {
                frames = {59}
            },
            ['idle-up'] = {
                frames = {95}
            }
        }
    }
}