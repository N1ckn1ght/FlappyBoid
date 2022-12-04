require "vector"
require "game/game"

function love.load()
    math.randomseed(os.time())
    Width = love.graphics.getWidth()
    Height = love.graphics.getHeight()
    initSounds()

    DifficultyPresets = {
     -- Advanced description lies in the Field.create method
     -- {G, VelocityOnClick and VelocityOnClick2, {Velocity, InitialDistance, pipeDistance, pipeGap, pipeWidth, pipeEndWidth, pipeEndHeight, acceleration, velocityLimit, accelerationType, gapSubtract, gapLimit, maxRandomGap (experimental)}}
        {1520, 520, {250, Width / 2, 550, 180, 65, 72,  30, 0.003, 1000, 2}},     -- Easy
        {1520, 520, {250, Width / 2, 500, 150, 60, 80,  30, 0.003, 1000, 2}},     -- Normal
        {2000, 666, {250, Width / 2, 450, 140, 60, 80,  30, 0.006, 1000, 2}},     -- Hard
        {1240, 400, {800, Width / 2, 950, 100, 60, 66,  30, 0.003, 2000, 2}},     -- Fast
        {1520, 520, {250, Width / 2, 550, 150, 60, 300, 30, 0.003, 1500, 2}},     -- Flat
        {1100, 250, {450, Width    , 60,  180, 60, 60,  30, 0.003, 1500, 2, 60}}, -- Dense
        {1100, 250, {450, Width    , 1,   300, 1,  1,   0,  0.003, 1500, 2, 15}}  -- Debug
    }

    Game:create(DifficultyPresets[2], true)
end

function love.update(dt)
    Game:update(dt)
end

function love.draw()
    Game:draw()
end

function love.mousepressed(x, y, button)
    if button == 1 then
        Game:onLMB()
    end
    if button == 2 then
        Game:onRMB()
    end
end

function initSounds()
    SoundDie    = love.audio.newSource("sound/die.wav", "static")
    SoundHit    = love.audio.newSource("sound/hit.wav", "static")
    SoundPoint  = love.audio.newSource("sound/point.wav", "static")
    SoundSwoosh = love.audio.newSource("sound/swoosh.wav", "static")
    SoundWing   = love.audio.newSource("sound/wing.wav", "static")
end
