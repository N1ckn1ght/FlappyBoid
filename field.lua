Field = {}
Field.__index = Field

function Field:create(velocity, pipeDistance, pipeGap, pipeWidth, pipeEndWidth, pipeEndHeight, acceleration, velocityLimit, accelerationType)
    local field = {}
    setmetatable(field, Field)

    field.velocity         = velocity
    field.pipeDistance     = pipeDistance
    field.pipeGap          = pipeGap
    field.pipeWidth        = pipeWidth
    field.pipeEndWidth     = pipeEndWidth
    field.pipeEndHeight    = pipeEndHeight
    field.acceleration     = acceleration      or 0
    field.limit            = velocityLimit     or velocity
    field.accelerationType = accelerationType  or 1

    field.pipe  = {}
    field.pipes = {}
    field.curr  = 1
    field.last  = 0
    field.count = 0
    return field
end

function Field:init()
    -- lower pipe, 1 - base, 2 - end
    self.pipe[1] = {-self.pipeWidth / 2,     Height,                                -self.pipeWidth / 2,     self.pipeGap / 2 + self.pipeEndHeight, self.pipeWidth / 2,     self.pipeGap / 2 + self.pipeEndHeight, self.pipeWidth / 2,     Height}
    self.pipe[2] = {-self.pipeEndWidth / 2,  self.pipeGap / 2 + self.pipeEndHeight, -self.pipeEndWidth / 2,  self.pipeGap / 2,                      self.pipeEndWidth / 2,  self.pipeGap / 2,                      self.pipeEndWidth / 2,  self.pipeGap / 2 + self.pipeEndHeight}
    -- upper pipe, 3 - base, 4 - end
    self.pipe[3] = {-self.pipeWidth / 2,    -Height,                                -self.pipeWidth / 2,    -self.pipeGap / 2 - self.pipeEndHeight, self.pipeWidth / 2,    -self.pipeGap / 2 - self.pipeEndHeight, self.pipeWidth / 2,    -Height}
    self.pipe[4] = {-self.pipeEndWidth / 2, -self.pipeGap / 2 - self.pipeEndHeight, -self.pipeEndWidth / 2, -self.pipeGap / 2,                      self.pipeEndWidth / 2, -self.pipeGap / 2,                      self.pipeEndWidth / 2, -self.pipeGap / 2 - self.pipeEndHeight}
   
    self.count = math.ceil((Width + math.max(self.pipeWidth, self.pipeEndWidth)) / self.pipeDistance + 1)
    for i = self.curr, self.count do
        self.pipes[i] = self:randomPipe(Width / 2 + i * self.pipeDistance)
    end
    self.last = self.count
end

function Field:update(dt)
    for k, v in pairs(self.pipes) do
        -- always moving backwards
        v[1] = v[1] - dt * self.velocity
        if (v[1] < -math.max(self.pipeWidth, self.pipeEndWidth)) then
            self.pipes[k] = self:randomPipe(self.pipes[self.last][1] + self.pipeDistance)

            self.last = self.curr
            self.curr = self.curr + 1
            if (self.curr > self.count) then
                self.curr = 1
            end
        end
    end

    -- 1 - linear, 2 - logarithmic
    if self.accelerationType == 1 then
        self.velocity = math.max(self.velocity + self.acceleration * dt, self.limit)
    elseif self.accelerationType == 2 then
        self.velocity = self.velocity + (self.limit - self.velocity) * math.min(self.acceleration * dt, 1)
    end
end

function Field:draw()
    for k, v in pairs(self.pipes) do
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

function Field:randomPipe(x)
    -- {x, y, color{red, green, blue}}
    -- x center is the pipeWidth / 2
    -- y center is the center of pipeGap
    return {x, math.random() * (Height - self.pipeEndHeight * 2 - self.pipeGap * 2) + self.pipeEndHeight + self.pipeGap, {math.random(), math.random(), math.random()}}
end