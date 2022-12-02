require "vector"
require "boid"
require "field"
require "collisionDetector"

function love.load()
    math.randomseed(os.time())
    Width = love.graphics.getWidth()
    Height = love.graphics.getHeight()

    InitialDistance = Width / 2
    InitialX = 150
    DifficultyPresets = {
        {1500, 520, {250, InitialDistance, 550, 180, 65, 72, 30, 0.003, 600, 2}},    -- Easy
        {1500, 520, {250, InitialDistance, 550, 150, 60, 80, 30, 0.003, 1000, 2}},   -- Normal
        {2000, 666, {250, InitialDistance, 450, 140, 60, 80, 30, 0.006, 1000, 2}},   -- Hard
        {1240, 430, {1000, InitialDistance, 750, 100, 60, 66, 30, 0.003, 2000, 2}},  -- Fast
        {1500, 520, {250, InitialDistance, 550, 150, 60, 300, 30, 0.003, 2000, 2}},  -- Funny
        {1500, 520, {250, InitialDistance, 60, 150, 60, 60, 30, 0.003, 1000, 2}}     -- Funny 2
    }
    
    local difficulty = DifficultyPresets[2]

    Score = 0
    ActiveGame = true
    DrawGame = true

    G = difficulty[1]
    VelocityOnClick = difficulty[2]
    print(G)
    Player = Boid:create(InitialX, Height / 5, 13, 1.6)
    Pipes = Field:create(difficulty[3][1], difficulty[3][2], difficulty[3][3], difficulty[3][4], difficulty[3][5], difficulty[3][6], difficulty[3][7], difficulty[3][8], difficulty[3][9],difficulty[3][10])
    Detector = CollisionDetector:create(onCollision)
    Pipes:init()
    Detector:trackPlayer(Player)
    Detector:trackField(Pipes)
    Detector:trackBorder({Vector:create(0, 0), Vector:create(Width, 0)})
    Detector:trackBorder({Vector:create(0, Height), Vector:create(Width, Height)})
end

function love.update(dt)
    if (ActiveGame) then
        Player:applyForce(Vector:create(0, G) * dt)
        Player:update(dt)
        Pipes:update(dt)
        Detector:update()
        Score = math.floor((Pipes.distance - InitialDistance + InitialX) / Pipes.pipeDistance)
    end
end

function love.draw()
    if (DrawGame) then
        Player:draw()
        Pipes:draw()
    end
end

function love.mousepressed(x, y, button)
    if ActiveGame and button == 1 then
		Player.velocity.y = -VelocityOnClick
    end
end

function onCollision(player, field, index, rect)
    ActiveGame = false
    player.color = {1, 0, 0, 1}
end

-- http://lua-users.org/wiki/CopyTable
function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end