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
        {1520, 520, {250, Width * 0.5, 550, 180, 65, 72,  30, 0.004, 1200, 2}},     -- Easy
        {1520, 520, {250, Width * 0.5, 500, 150, 60, 80,  30, 0.004, 1200, 2}},     -- Normal
        {2000, 666, {250, Width * 0.5, 450, 140, 60, 80,  30, 0.004, 1200, 2}},     -- Hard
        {1240, 400, {800, Width * 0.5, 950, 100, 60, 66,  30, 0.004, 2000, 2}},     -- Fast
        {1520, 520, {250, Width * 0.5, 550, 150, 60, 300, 30, 0.004, 1500, 2}},     -- Flat
        {1100, 250, {450, Width      , 60,  180, 60, 60,  30, 0.004, 1500, 2, 60}}, -- Dense
        {1100, 250, {450, Width      , 6,   180, 6,  6,   20, 0.004, 1500, 2, 15}}, -- Cave
        {1100, 250, {450, Width      , 1,   300, 1,  1,   0,  0.004, 1500, 2, 15}}  -- Debug
    }

    PlayGame = nil
    MainMenu = Menu:create({{{"Easy", 1}, {"Normal", 2}, {"Hard", 3}, {"Fast", 4}}, {{"Flat", 5}, {"Dense", 6}, {"Cave", 7}, {"Debug\n(unstable)", 8}}, {}, {}, {{"Records"}, {"Help"}, {}, {"Exit"}}})
    LoseMenu = Menu:create({{{}}, {{}}, {{}}, {{}}, {{}}, {{}}, {{"Menu"}, {"Restart"}}}, 18, Width, 120, 0, 0, 6, 6, 0.7)
end

function love.update(dt)
    if State == 2 then
        PlayGame:update(dt)
    end
end

function love.draw()
    if State > 1 and State < 5 then
        PlayGame:draw()
        if (State > 2) then
            LoseMenu:draw()
        end
        showStat(PlayGame.time,           Width * 0.333, 10, 160, 18, 0.7,   0,  120, 2, "time ")
        showStat(PlayGame.field.velocity, Width * 0.667, 10, 160, 18, 0.7, 250, 1000, 0, "speed ")
    elseif State == 1 then
        MainMenu:draw()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        if State == 2 then
            PlayGame:onLMB()
        elseif State == 1 then
            local value = MainMenu:getButton()
            if value ~= nil then
                -- it's necessary to prevent accidental click next time this menu will brought up
                MainMenu.location = nil
                if value[2] ~= nil then
                    PlayGame = Game:create(DifficultyPresets[value[2]])
                    State = 2
                elseif value[1] == "Exit" then
                    love.event.quit()
                end
            end
        elseif State > 2 and State < 5 then
            local value = LoseMenu:getButton()
            if value ~= nil then
                -- it's necessary to prevent accidental click next time this menu will brought up
                LoseMenu.location = nil
                if value[1] == "Menu" then
                    State = 1
                elseif value[1] == "Restart" then
                    PlayGame = Game:create(PlayGame.difficulty)
                    State = 2
                end
            end
        end
    elseif button == 2 then
        if State == 2 then
            PlayGame:onRMB()
        end
    elseif button == 3 then
        if State == 2 then
            State = 3
        elseif State == 3 then
            State = 2
        end
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if State == 1 then
        MainMenu:onMouseMove(x, y)
    elseif State > 2 and State < 5 then
        LoseMenu:onMouseMove(x, y)
    end
end

function initSounds()
    SoundDie    = love.audio.newSource("sound/die.wav", "static")
    SoundHit    = love.audio.newSource("sound/hit.wav", "static")
    SoundPoint  = love.audio.newSource("sound/point.wav", "static")
    SoundSwoosh = love.audio.newSource("sound/swoosh.wav", "static")
    SoundWing   = love.audio.newSource("sound/wing.wav", "static")
end

function showStat(metric, x, y, width, fontSize, transparency, minc, maxc, mantissa, addText)
    local r, g, b, a = love.graphics.getColor()
    metric = string.format("%."..mantissa.."f", metric)
    addText = addText or ""
    love.graphics.setColor(0, 0, 0, transparency)
    love.graphics.polygon("fill", {x - width * 0.5, y - fontSize * 0.2, x + width * 0.5, y - fontSize * 0.2, x + width * 0.5, y + fontSize * 1.2, x - width * 0.5, y + fontSize * 1.2})
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(addText..metric, love.graphics.newFont(fontSize), x - width * 0.5, y, width, 'center')
    love.graphics.setColor(r, g, b, a)
end