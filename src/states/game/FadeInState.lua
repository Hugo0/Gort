--[[
    State that fades the screen to a certain color over certain duration
    and then pops itself from stack. Calls function after ending
]]--

FadeInState = Class{__includes = BaseState}

function FadeInState:init(color, time, onFadeComplete)
    self.r = color.r
    self.g = color.g
    self.b = color.b
    self.opacity = 0
    self.time = time

    -- tween the opacity gradually
    Timer.tween(self.time, {
        [self] = {opacity = 255}
    })
    :finish(function()
        gStateStack:pop() -- pop self from stack
        onFadeComplete() -- callback function
    end)
end

function FadeInState:render()
    love.graphics.setColor(self.r, self.g, self.b, self.opacity)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    -- reset color
    love.graphics.setColor(255, 255, 255, 255)
end