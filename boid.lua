Boid = {}
Boid.__index = Boid

function Boid:create(size)
    local boid = {}
    setmetatable(boid, Boid)

    boid.acceleration = Vector:create(0, 0)
    boid.velocity = Vector:create(0, 0)
    boid.angle = 0
    boid.size = size
    
    boid.location = Vector:create(50 + size / 2, Height / 3)
    boid.vertices = {0, -size * 1.6, -size, size * 1.6, 0, size, size, size * 1.6}

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
    local angle = fakeVelocity:heading() + math.pi / 2
    -- save coordinate system
    love.graphics.push()
    love.graphics.translate(self.location.x, self.location.y)
    love.graphics.rotate(angle)

    -- save love graphics color
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(0, 1, 1, 1)
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