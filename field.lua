Field = {}
Field.__index = Field

function Field:create(velocity, initialDistance, pipeDistance, pipeGap, pipeWidth, pipeEndWidth, pipeEndHeight, acceleration, velocityLimit, accelerationType, maxRandomGap)
    local field = {}
    setmetatable(field, Field)

    field.velocity         = velocity
    field.initialDistance  = initialDistance
    field.pipeDistance     = pipeDistance
    field.pipeGap          = pipeGap
    field.pipeWidth        = pipeWidth
    field.pipeEndWidth     = pipeEndWidth
    field.pipeEndHeight    = pipeEndHeight
    field.acceleration     = acceleration      or 0
    field.velocityLimit    = velocityLimit     or velocity
    field.accelerationType = accelerationType  or 1
    field.maxRandomGap     = maxRandomGap      or false
    field.pipe             = {}
    field.pipes            = {}
    field.curr             = 1
    field.last             = 0
    field.count            = 0
    field.distance         = 0

    return field
end

function Field:init()
    -- lower pipe, 1 - base, 2 - end
    self.pipe[1] = {-self.pipeWidth / 2,     Height,                                -self.pipeWidth / 2,     self.pipeGap / 2 + self.pipeEndHeight, self.pipeWidth / 2,     self.pipeGap / 2 + self.pipeEndHeight, self.pipeWidth / 2,     Height}
    self.pipe[2] = {-self.pipeEndWidth / 2,  self.pipeGap / 2 + self.pipeEndHeight, -self.pipeEndWidth / 2,  self.pipeGap / 2,                      self.pipeEndWidth / 2,  self.pipeGap / 2,                      self.pipeEndWidth / 2,  self.pipeGap / 2 + self.pipeEndHeight}
    -- upper pipe, 3 - base, 4 - end
    self.pipe[3] = {-self.pipeWidth / 2,    -Height,                                -self.pipeWidth / 2,    -self.pipeGap / 2 - self.pipeEndHeight, self.pipeWidth / 2,    -self.pipeGap / 2 - self.pipeEndHeight, self.pipeWidth / 2,    -Height}
    self.pipe[4] = {-self.pipeEndWidth / 2, -self.pipeGap / 2 - self.pipeEndHeight, -self.pipeEndWidth / 2, -self.pipeGap / 2,                      self.pipeEndWidth / 2, -self.pipeGap / 2,                      self.pipeEndWidth / 2, -self.pipeGap / 2 - self.pipeEndHeight}
   
    self.count = math.ceil((Width + math.max(self.pipeWidth, self.pipeEndWidth)) / self.pipeDistance) + 1
    for i = self.curr, self.count do
        self.pipes[i] = self:randomPipe(self.initialDistance + i * self.pipeDistance, true)
        self.curr = i % self.count + 1
        self.last = i
    end
    self.last = self.count
end

function Field:update(dt)
    local dbf = dt * self.velocity
    -- general distance counter (e.g. for counting score, it'd be good to divide distance by pipeDistance)
    self.distance = self.distance + dbf

    local curr = self.curr
    local first = true

    for i = 1, self.count do
        local index = (i + curr - 2) + 1
        if (index > self.count) then
            index = index - self.count
        end

        -- always moving pipes backwards
        self.pipes[index][1] = self.pipes[index][1] - dbf
        if (self.pipes[index][1] < -math.max(self.pipeWidth, self.pipeEndWidth)) then
            -- respawn pipe with random y (if it's not on screen anymore)
            self.pipes[index] = self:randomPipe(self.pipes[self.last][1] + self.pipeDistance)
            if (first) then
                self.pipes[index][1] = self.pipes[index][1] - dbf
                first = false
            end
            self.curr = self.curr + 1
            self.last = self.last + 1
            if (self.last > self.count) then
                self.last = 1
            end
        end
    end
    if (self.curr > self.count) then
        self.curr = self.curr - self.count
    end

    -- 1 - linear, 2 - logarithmic
    if self.accelerationType == 1 then
        self.velocity = math.max(self.velocity + self.acceleration * dt, self.velocityLimit)
    elseif self.accelerationType == 2 then
        self.velocity = self.velocity + (self.velocityLimit - self.velocity) * math.min(self.acceleration * dt, 1)
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
    if (self.maxRandomGap and self.last > 0) then
        local low  = math.min(self.pipes[self.last][2] + self.maxRandomGap, Height - self.pipeEndHeight - self.pipeGap / 2)
        local high = math.max(self.pipes[self.last][2] - self.maxRandomGap, self.pipeEndHeight + self.pipeGap / 2)
        local rand = math.random() * (high - low)
        return {x, low + rand, {math.random(), math.random(), math.random()}}
    end
    return {x, math.random() * (Height - self.pipeEndHeight * 2 - self.pipeGap) + self.pipeEndHeight + self.pipeGap / 2, {math.random(), math.random(), math.random()}}
end

-- Collision detection stuff --

function Field:getNormals(index, rect)
    local normals = {}
    local current_dot = nil
    local previous_dot = nil
    for i = 1, #self.pipe[rect] / 2 do
        previous_dot = current_dot or self:getDot(index, rect, #self.pipe[rect] / 2)
        current_dot = self:getDot(index, rect, i)
        local px = current_dot.x - previous_dot.x
        local py = current_dot.y - previous_dot.y
        
        -- clockwise, else counter-clockwise
        if (rect < 3) then
            normals[i] = Vector:create(-py, px)
        else
            normals[i] = Vector:create(py, -px)
        end
    end
    return normals
end

function Field:getMinMaxProj(index, rect, axis)
    local dot = self:getDot(index, rect, 1)
    local min_proj = dotProduct(Vector:create(dot.x, dot.y), axis)
    local max_proj = min_proj
    for i = 2, #self.pipe[rect] / 2 do
        dot = self:getDot(index, rect, i)
        local curr_proj = dotProduct(Vector:create(dot.x, dot.y), axis)
        if (curr_proj < min_proj) then
            min_proj = curr_proj
        end
        if (curr_proj > max_proj) then
            max_proj = curr_proj
        end
    end
    return {min_proj, max_proj}
end

function Field:getDot(index, rect, point)
    local x = self.pipe[rect][point * 2 - 1] + self.pipes[index][1]
    local y = self.pipe[rect][point * 2]     + self.pipes[index][2]
    return Vector:create(x, y)
end