require "vector"
require "boid"
require "field"
require "collisionDetector"

function love.load()
    math.randomseed(os.time())
    Width = love.graphics.getWidth()
    Height = love.graphics.getHeight()
    initSounds()

    DifficultyPresets = {
        -- {G, VelocityOnClick and VelocityOnClick2, {Velocity, InitialDistance, pipeDistance, pipeGap, pipeWidth, pipeEndWidth, 
        -- pipeEndHeight, acceleration, velocityLimit, accelerationType, gapSubtract, gapLimit, maxRandomGap (experimental)}}
        {1520, 520, {250, Width / 2, 550, 180, 65, 72,  30, 0.003, 1000, 2}},     -- Easy
        {1520, 520, {250, Width / 2, 500, 150, 60, 80,  30, 0.003, 1000, 2}},     -- Normal
        {2000, 666, {250, Width / 2, 450, 140, 60, 80,  30, 0.006, 1000, 2}},     -- Hard
        {1240, 400, {800, Width / 2, 950, 100, 60, 66,  30, 0.003, 2000, 2}},     -- Fast
        {1520, 520, {250, Width / 2, 550, 150, 60, 300, 30, 0.003, 1500, 2}},     -- Flat
        {1100, 250, {450, Width    , 60,  180, 60, 60,  30, 0.003, 1500, 2, 60}}, -- Dense
        {1100, 250, {450, Width    , 1,   300, 1,  1,   0,  0.003, 1500, 2, 15}}  -- Debug
    }

    InitialX = 150
    Difficulty = DifficultyPresets[2]

    Score = 0
    ActiveGame = true
    DrawGame = true

    G = Difficulty[1]
    VelocityOnClick = Difficulty[2]
    VelocityOnClick2 = Difficulty[2]
    Player = Boid:create(InitialX, Height / 5, 13, 1.6)
    Pipes = Field:create(Difficulty[3][1], Difficulty[3][2], Difficulty[3][3], Difficulty[3][4], Difficulty[3][5], Difficulty[3][6], Difficulty[3][7], Difficulty[3][8], Difficulty[3][9], Difficulty[3][10], Difficulty[3][11])
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
        -- Score = math.floor((Pipes.distance - Difficulty[3][2] + InitialX) / Pipes.pipeDistance)
        -- local newScore = math.floor((Pipes.distance - Difficulty[3][2] + InitialX) / Pipes.pipeDistance)
        -- if (newScore > Score) then
        --     Score = newScore
        --     print(Score)
        --     SoundPoint:stop()
        --     SoundPoint:play()
        -- end
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
        SoundWing:stop()
        SoundWing:play()
    end
    if ActiveGame and button == 2 then
		Player.velocity.y = -VelocityOnClick2
        SoundWing:stop()
        SoundWing:play()
    end
end

function onCollision(player, cause)
    ActiveGame = false
    player.color = {1, 0, 0, 1}
    SoundHit:play()
end

function initSounds()
    SoundDie    = love.audio.newSource("sound/die.wav", "static")
    SoundHit    = love.audio.newSource("sound/hit.wav", "static")
    SoundPoint  = love.audio.newSource("sound/point.wav", "static")
    SoundSwoosh = love.audio.newSource("sound/swoosh.wav", "static")
    SoundWing   = love.audio.newSource("sound/wing.wav", "static")
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