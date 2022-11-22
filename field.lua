Field = {}
Field.__index = Field

function Field:create(velocity, acceleration, pipeDistance, pipeGap, pipeWidth, pipeEndWidth, pipeEndHeight)
    local field = {}
    setmetatable(field, Field)
    
    field.acceleration = acceleration
    field.velocity = velocity
    field.pipeDistance = pipeDistance
    field.pipeGap = pipeGap
    field.pipeWidth = pipeWidth
    field.pipeEndWidth = pipeEndWidth
    field.pipeEndHeight = pipeEndHeight

    field.pipes = {}
    field.curr = 1
    field.last = 0

    return field
end

function Field:init()
    self.last = (Width + self.pipeWidth) / self.pipeDistance + 1
    for i = self.curr, self.last do
        self.pipes[i] = {Width + i * self.pipeDistance, math.random() * (Height - self.pipeEndHeight * 2) + self.pipeEndHeight, {math.random(), math.random(), math.random()}}
    end
end

function Field:update(dt)

end

function Field:draw()

end