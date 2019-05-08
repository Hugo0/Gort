--[[
    A Menu is composed of multiple selectables, optionally layered onto a Panel.
    More complicated Menus may be collections of Panels and Selections that
    form a greater whole.
]]

Menu = Class{}

function Menu:init(def)
    -- contents of menu
    self.selection = Selection {
        items = def.items,
        x = def.x,
        y = def.y,
        width = def.width,
        height = def.height
    }
    
    -- only include panel if so defined
    if def.hasPanel then
        self.panel = Panel(def.x, def.y, def.width, def.height)
    end
end

function Menu:update(dt)
    self.selection:update(dt)
end

function Menu:render()
    if self.panel then
        self.panel:render()
    end
    self.selection:render()
end