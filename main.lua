require "vector"
require "boid"
require "field"
require "collisionDetector"

function love.load()
    math.randomseed(os.time())
    Width = love.graphics.getWidth()
    Height = love.graphics.getHeight()

    G = 1500
    VelocityOnClick = 520

    InitialDistance = Width / 2
    InitialX = 150

    Player = Boid:create(InitialX, Height / 5, 13, 1.6)
    Pipes = Field:create(250, InitialDistance, 550, 150, 60, 80, 30, 0.003, 1000, 2)
    Detector = CollisionDetector:create(onCollision)
    
    Pipes:init()
    Detector:trackPlayer(Player)
    Detector:trackField(Pipes)
    Detector:trackBorder({Vector:create(0, 0), Vector:create(Width, 0)})
    Detector:trackBorder({Vector:create(0, Height), Vector:create(Width, Height)})

    Score = 0
    Flag = true
end

function love.update(dt)
    if (Flag) then
        Player:applyForce(Vector:create(0, G) * dt)
        Player:update(dt)
        Pipes:update(dt)
        Detector:update()

        local newScore = math.floor((Pipes.distance - InitialDistance + InitialX) / Pipes.pipeDistance)
        if (newScore > Score) then
            Score = newScore
            print("New score:", Score)
        end
    end
end

function love.draw()
    Player:draw()
    Pipes:draw()
end

function love.mousepressed(x, y, button)
    if Flag and button == 1 then
		Player.velocity.y = -VelocityOnClick
    end
end

function onCollision(player, field, index, rect)
    Flag = false
    player.color = {1, 0, 0, 1}
end