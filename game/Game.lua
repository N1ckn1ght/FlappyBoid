require "game.boid"
require "game.field"
require "game.collisionDetector"

Game = {}
Game.__index = Game

function Game:create(difficulty, start)
    local game = {}
    setmetatable(game, Game)
    self:init(difficulty, start)
    return game
end

function Game:init(difficulty, start)
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
    self.activeGame = false or start
    self.drawGame = false or start
end

function Game:update(dt)
    if self.activeGame then
        self.boid:applyForce(Vector:create(0, self.g) * dt)
        self.boid:update(dt)
        self.field:update(dt)
        self.collisionDetector:update()
    end
end

function Game:draw()
    if self.drawGame then
        self.boid:draw()
        self.field:draw()
    end
end

function Game:onLMB()
    if self.activeGame then
        self.boid.velocity.y = -self.velocityOnClick
        SoundWing:stop()
        SoundWing:play()
    end
end

function Game:onRMB()
    if self.activeGame then
        self.boid.velocity.y = -self.velocityOnClick2
        SoundWing:stop()
        SoundWing:play()
    end
end

function Game:onCollision(boid, cause)
    self.activeGame = false
    boid.color = {1, 0, 0, 1}
    SoundHit:play()
end
