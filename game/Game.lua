require "game.boid"
require "game.field"
require "game.collisionDetector"

Game = {}
Game.__index = Game

function Game:create(difficulty)
    local game = {}
    setmetatable(game, Game)
    game:init(difficulty)
    return game
end

function Game:init(difficulty)
    self.difficulty = difficulty or self.difficulty
    self.initialX = 150
    self.score = 0
    self.g = difficulty[1]
    self.velocityOnClick = difficulty[2]
    self.velocityOnClick2 = difficulty[2]
    self.boid = Boid:create(self.initialX, Height / 5, 13, 1.6)
    self.field = Field:create(difficulty[3][1], difficulty[3][2], difficulty[3][3], difficulty[3][4], difficulty[3][5], difficulty[3][6], difficulty[3][7], difficulty[3][8], difficulty[3][9], difficulty[3][10], difficulty[3][11])
    self.collisionDetector = CollisionDetector:create(self)
    self.field:init()
    self.collisionDetector:trackPlayer(self.boid)
    self.collisionDetector:trackField(self.field)
    self.collisionDetector:trackBorder({Vector:create(0, 0), Vector:create(Width, 0)})
    self.collisionDetector:trackBorder({Vector:create(0, Height), Vector:create(Width, Height)})
    self.time = 0
end

function Game:update(dt)
    self.boid:applyForce(Vector:create(0, self.g) * dt)
    self.boid:update(dt, self.field.velocity)
    self.field:update(dt)
    self.collisionDetector:update()
    self.time = self.time + dt
end

function Game:draw()
    self.boid:draw()
    self.field:draw()
end

function Game:onLMB()
    self.boid.velocity.y = -self.velocityOnClick
    SoundWing:stop()
    SoundWing:play()
end

function Game:onRMB()
    self.boid.velocity.y = -self.velocityOnClick2
    SoundWing:stop()
    SoundWing:play()
end

function Game:onCollision(boid, cause)
    boid.color = {1, 0, 0, 1}
    SoundHit:play()
    -- This refers to main.lua; state of Game = 2, state of Pause Screen = 3, state of End Screen = 4.
    State = 4
    -- Debug print
    print("Collision had happened!\nCause:")
    for _, v in pairs(cause) do
        print(v)
    end
end