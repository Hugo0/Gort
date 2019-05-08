--[[
    The Selection class gives us a list of textual items that link to callbacks;
    this particular implementation only has one dimension of items (vertically),
    but a more robust implementation might include columns as well for a more
    grid-like selection, as seen in many kinds of interfaces and games.
]]

Selection = Class{}

function Selection:init(def)
    -- contents
    self.items = def.items

    -- dimensions
    self.x = def.x
    self.y = def.y
    self.height = def.height
    self.width = def.width

    self.font = def.font or gFonts['small']
    self.gapHeight = self.height / #self.items

    self.currentSelection = 1
end

function Selection:update(dt)

    -- navigation
    if love.keyboard.wasPressed('up') then
        -- loop to the end if selecting the first
        if self.currentSelection == 1 then
            self.currentSelection = #self.items
        else
            self.currentSelection = self.currentSelection - 1
        end        
        gSounds['blip']:stop()
        gSounds['blip']:play()

    elseif love.keyboard.wasPressed('down') then
        -- loop to the beginning if last
        if self.currentSelection == #self.items then
            self.currentSelection = 1
        else
            self.currentSelection = self.currentSelection + 1
        end        
        gSounds['blip']:stop()
        gSounds['blip']:play()

    -- if an item is selected
    elseif love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        -- call its onSelect function
        self.items[self.currentSelection].onSelect()
        
        gSounds['blip']:stop()
        gSounds['blip']:play()
    end
end

function Selection:render()
    local currentY = self.y

    for i = 1, #self.items do -- loop through items
        local paddedY = 0
        -- add padding to text
        paddedY = currentY + (self.gapHeight / 2) - self.font:getHeight() / 2

        -- change item so that current selection is visible
        if i == self.currentSelection then
            love.graphics.setColor(255, 100, 100, 255)
            --love.graphics.draw(gTextures['cursor'], self.x - 8, paddedY)
        end
        -- draw the item
        love.graphics.printf(self.items[i].text, self.x, paddedY, self.width, 'center')        
        love.graphics.setColor(255, 255, 255, 255)

        currentY = currentY + self.gapHeight
    end
end