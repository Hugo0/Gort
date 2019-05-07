--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A Menu is simply a Selection layered onto a Panel, at least for use in this
    game. More complicated Menus may be collections of Panels and Selections that
    form a greater whole.
]]

Menu = Class{}

function Menu:init(def)
    print(' I am a menu and my x and y and width and hasSelection are:' 
    .. tostring(def.x).. ' ' .. tostring(def.y) .. ' ' .. tostring(def.width) .. ' ' .. tostring(def.hasSelection))
    self.panel = Panel(def.x, def.y, def.width, def.height)
    
    self.hasSelection = def.hasSelection or 1

    self.selection = Selection {
        items = def.items,
        x = def.x,
        y = def.y,
        width = def.width,
        height = def.height,
        selectable = self.hasSelection
    }
end

function Menu:update(dt)
    self.selection:update(dt)
end

function Menu:render()
    self.panel:render()
    self.selection:render()
end