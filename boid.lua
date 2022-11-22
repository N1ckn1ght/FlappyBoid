Boid = {}
Boid.__index = Boid

function Boid:create(radius)
    local boid = {}
    setmetatable(boid, Boid)

    boid.acceleration = Vector:create(0, 0)
    boid.velocity = Vector:create(0, 0)
    boid.angle = 0
    boid.r = radius
    
    boid.location = Vector:create(50 + radius / 2, Height / 2)
    boid.vertices = {0, -boid.r * 2, -boid.r, boid.r * 2, 0, boid.r, boid.r, boid.r * 2}

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

    -- save and load coordinate system
    love.graphics.push()
    love.graphics.translate(self.location.x, self.location.y)
    love.graphics.rotate(angle)

    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(0, 1, 1, 1)
    love.graphics.polygon("fill", self.vertices)
    love.graphics.setColor(r, g, b, a)

    love.graphics.pop()
end

function Boid:applyForce(force)
    self.acceleration:add(force)
end