StateStack = Class{}

function StateStack:init()
    -- init the Statestack with an empty table
    self.states = {}
end

function StateStack:update(dt)
    -- only update the most top stack
    self.states[#self.states]:update(dt)
end

function StateStack:processAI(params, dt)
    -- update the AI of the topmost state
    self.states[#self.states]:processAI(params, dt)
end

function StateStack:render()
    -- render ALL the states onto the screen
    for i, state in ipairs(self.states) do
        state:render()
    end
end

-- delete all the states
function StateStack:clear()
    self.states = {}
end

-- insert a new state
function StateStack:push(state)
    table.insert(self.states, state)
    state:enter()
end

-- remove top state
function StateStack:pop()
    self.states[#self.states]:exit()
    table.remove(self.states)
end