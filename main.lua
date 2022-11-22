require "vector"
require "boid"
require "field"

function love.load()
    math.randomseed(os.time())
    Width = love.graphics.getWidth()
    Height = love.graphics.getHeight()

    G = 1500
    VelocityOnClick = 550

    Player = Boid:create(15)
    Pipes = Field:create(-10, -1, 300, 100, 30, 40, 20)
    Pipes:init()
end

function love.update(dt)
    Player:applyForce(Vector:create(0, G) * dt)
    Player:update(dt)
end

function love.draw()
    Player:draw()
end

function love.mousepressed(x, y, button)
    if button == 1 then
        print('ok!')
		Player.velocity.y = -VelocityOnClick
    end
end
