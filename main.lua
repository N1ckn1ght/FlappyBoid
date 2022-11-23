require "vector"
require "boid"
require "field"

function love.load()
    math.randomseed(os.time())
    Width = love.graphics.getWidth()
    Height = love.graphics.getHeight()

    G = 1500
    VelocityOnClick = 520

    Player = Boid:create(13)
    Pipes = Field:create(250, 550, 150, 60, 80, 30, 0.003, 1000, 2)
    Pipes:init()
end

function love.update(dt)
    Player:applyForce(Vector:create(0, G) * dt)
    Player:update(dt)
    Pipes:update(dt)
end

function love.draw()
    Player:draw()
    Pipes:draw()
end

function love.mousepressed(x, y, button)
    if button == 1 then
		Player.velocity.y = -VelocityOnClick
    end
end
