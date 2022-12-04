Boid = {}
Boid.__index = Boid

function Boid:create(x, y, size, k)
    local boid = {}
    setmetatable(boid, Boid)

    boid.location     = Vector:create(x, y)
    boid.acceleration = Vector:create(0, 0)
    boid.velocity     = Vector:create(0, 0)
    boid.angle        = 0
    boid.size         = size
    boid.k            = k
    boid.vertices     = {0, -size * k, -size, size * k, 0, size, size, size * k}
    boid.hitboxes     = {{3, 1, 2}, {1, 4, 3}}
    boid.color        = {0, 1, 1, 1}

    return boid
end

function Boid:update(dt)
    self.velocity:add(self.acceleration)
    self.location:add(self.velocity * dt)
    self.acceleration:mul(0)
    
    if (self.location.y > Height) then
        self.location.y = Height
        self.velocity.y = math.min(self.velocity.y, 1)
    end
end

function Boid:draw()
    local fakeVelocity = Vector:create(300, self.velocity.y)
    self.angle = fakeVelocity:heading() + math.pi * 0.5
    -- save coordinate system
    love.graphics.push()
    love.graphics.translate(self.location.x, self.location.y)
    love.graphics.rotate(self.angle)

    -- save love graphics color
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self.color)
    love.graphics.polygon("fill", self.vertices)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.polygon("line", self.vertices)

    -- revert love changes
    love.graphics.setColor(r, g, b, a)
    love.graphics.pop()
end

function Boid:applyForce(force)
    self.acceleration:add(force)
end

-- Collision detection stuff --

function Boid:getNormals(part)
    local normals = {}
    local current_dot = nil
    local previous_dot = nil
    for i = 2, #self.hitboxes[part] do
        previous_dot = current_dot or self:getDot(self.hitboxes[part][1])
        current_dot = self:getDot(self.hitboxes[part][i])
        local px = current_dot.x - previous_dot.x
        local py = current_dot.y - previous_dot.y
        normals[i - 1] = Vector:create(-py, px)
    end
    return normals
end

function Boid:getMinMaxProj(part, axis)
    local dot = self:getDot(self.hitboxes[part][1])
    local min_proj = dotProduct(Vector:create(dot.x, dot.y), axis)
    local max_proj = min_proj
    for i = 2, #self.hitboxes[part] do
        dot = self:getDot(self.hitboxes[part][i])
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

function Boid:getDot(index)
    local x = self.vertices[index * 2 - 1]
    local y = self.vertices[index * 2]
    local xReal = x * math.cos(self.angle) - y * math.sin(self.angle) + self.location.x
    local yReal = x * math.sin(self.angle) + y * math.cos(self.angle) + self.location.y
    return Vector:create(xReal, yReal)
end