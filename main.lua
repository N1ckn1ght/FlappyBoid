require "vector"
require "game.game"
require "interface.menu"

function love.load()
    math.randomseed(os.time())
    Width = love.graphics.getWidth()
    Height = love.graphics.getHeight()
    initSounds()

    -- let states be: { Main Menu , Game , Pause Screen , End Screen , Records , Help }
    State = 1

    DifficultyPresets = {
     -- Advanced description lies in the Field.create method
     -- {G, VelocityOnClick, VelocityOnClick2, {Velocity, InitialDistance, pipeDistance, pipeGap, pipeWidth, pipeEndWidth, pipeEndHeight, acceleration, velocityLimit, accelerationType, gapSubtract, gapLimit, maxRandomGap (experimental)}}
        {1520, 520, {250, Width / 2, 550, 180, 65, 72,  30, 0.003, 1000, 2}},     -- Easy
        {1520, 520, {250, Width / 2, 500, 150, 60, 80,  30, 0.003, 1000, 2}},     -- Normal
        {2000, 666, {250, Width / 2, 450, 140, 60, 80,  30, 0.006, 1000, 2}},     -- Hard
        {1240, 400, {800, Width / 2, 950, 100, 60, 66,  30, 0.003, 2000, 2}},     -- Fast
        {1520, 520, {250, Width / 2, 550, 150, 60, 300, 30, 0.003, 1500, 2}},     -- Flat
        {1100, 250, {450, Width    , 60,  180, 60, 60,  30, 0.003, 1500, 2, 60}}, -- Dense
        {1100, 250, {450, Width    , 1,   300, 1,  1,   0,  0.003, 1500, 2, 15}}  -- Debug
    }

    MainMenu = Menu:create({{{"Easy", 1}, {"Normal", 2}, {"Hard", 3}}, {{"Fast", 4}, {"Flat", 5}, {"Dense", 6}, {"Debug", 7}}, {}, {}, {{"Records"}, {"Help"}, {"Exit"}}})
end

function love.update(dt)
    if State == 2 then
        Game:update(dt)
        -- print(Game.time)
    end
end

function love.draw()
    if State > 1 and State < 5 then
        Game:draw()
    elseif State == 1 then
        MainMenu:draw()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        if State == 1 then
            local value = MainMenu:getButton()
            if value ~= nil then
                if value[2] ~= nil then
                    Game:create(DifficultyPresets[value[2]])
                    State = 2
                elseif value[1] == "Exit" then
                    love.event.quit()
                end
            end
        elseif State == 2 then
            Game:onLMB()
        end
    end
    if button == 2 then
        if State == 2 then
            Game:onRMB()
        end
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if State == 1 then
        MainMenu:onMouseMove(x, y)
    end
end

function initSounds()
    SoundDie    = love.audio.newSource("sound/die.wav", "static")
    SoundHit    = love.audio.newSource("sound/hit.wav", "static")
    SoundPoint  = love.audio.newSource("sound/point.wav", "static")
    SoundSwoosh = love.audio.newSource("sound/swoosh.wav", "static")
    SoundWing   = love.audio.newSource("sound/wing.wav", "static")
end