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

    field.pipe = {}
    field.pipes = {}
    field.curr = 1
    field.last = 0

    return field
end

function Field:init()
    -- lower pipe, 1 - base, 2 - end
    self.pipe[1] = {-self.pipeWidth / 2,     Height,                                -self.pipeWidth / 2,     self.pipeGap / 2 + self.pipeEndHeight, self.pipeWidth / 2,     self.pipeGap / 2 + self.pipeEndHeight, self.pipeWidth / 2,     Height}
    self.pipe[2] = {-self.pipeEndWidth / 2,  self.pipeGap / 2 + self.pipeEndHeight, -self.pipeEndWidth / 2,  self.pipeGap / 2,                      self.pipeEndWidth / 2,  self.pipeGap / 2,                      self.pipeEndWidth / 2,  self.pipeGap / 2 + self.pipeEndHeight}
    -- upper pipe, 3 - base, 4 - end
    self.pipe[3] = {-self.pipeWidth / 2,    -Height,                                -self.pipeWidth / 2,    -self.pipeGap / 2 - self.pipeEndHeight, self.pipeWidth / 2,    -self.pipeGap / 2 - self.pipeEndHeight, self.pipeWidth / 2,    -Height}
    self.pipe[4] = {-self.pipeEndWidth / 2, -self.pipeGap / 2 - self.pipeEndHeight, -self.pipeEndWidth / 2, -self.pipeGap / 2,                      self.pipeEndWidth / 2, -self.pipeGap / 2,                      self.pipeEndWidth / 2, -self.pipeGap / 2 - self.pipeEndHeight}
   
    self.last = (Width + self.pipeWidth) / self.pipeDistance + 1
    for i = self.curr, 50 do
        self.pipes[i] = {Width + i * self.pipeDistance, math.random() * (Height - self.pipeEndHeight * 2 - self.pipeGap * 2) + self.pipeEndHeight + self.pipeGap, {math.random(), math.random(), math.random()}}
    end
end

function Field:update(dt)
    for _, v in pairs(self.pipes) do
        v[1] = v[1] + dt * self.velocity 
    end
end

function Field:draw()
    for k, v in pairs(self.pipes) do
        -- print(k, ":", v[1], v[2], v[3][1], v[3][2], v[3][3])
        -- save coordinate system
        love.graphics.push()
        love.graphics.translate(v[1], v[2])

        -- save love graphics color
        local r, g, b, a = love.graphics.getColor()
        love.graphics.setColor(v[3][1], v[3][2], v[3][3], 1)
        for _, p in pairs(self.pipe) do
            love.graphics.polygon("fill", p)
        end
        love.graphics.setColor(1, 1, 1, 1)
        for _, p in pairs(self.pipe) do
            love.graphics.polygon("line", p)
        end

        -- revert love changes
        love.graphics.setColor(r, g, b, a)
        love.graphics.pop()
    end
end