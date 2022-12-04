Menu = {}
Menu.__index = Menu

function Menu:create(buttons)
    local menu = {}
    setmetatable(menu, Menu)
    self:init(buttons)
    return menu
end

function Menu:init(buttons)
    self.buttons = buttons
    self.font = love.graphics.newFont(30)
    self.xMargin = 30
    self.yMargin = 30
    self.buttonWidth = (Width - self.xMargin * (#self.buttons + 1)) / #self.buttons
    self.buttonHeight = 1
    for _, v in pairs(self.buttons) do
        self.buttonHeight = math.max(self.buttonHeight, #v)
    end
    self.buttonHeight = math.min(180, (Height - self.yMargin * (self.buttonHeight + 1)) / self.buttonHeight)
end

function Menu:draw()
    -- save love graphics color
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(1, 1, 1, 1)
    
    for k1, column in pairs(self.buttons) do
        for k2, row in pairs(column) do
            love.graphics.printf(row[1], self.font, k1 * self.xMargin + (k1 - 1) * self.buttonWidth, k2 * self.yMargin + (k2 - 1) * self.buttonHeight, self.buttonWidth, 'center',
            0, 1, 1, 0, -self.buttonHeight / 3)
        end
    end

    if (self.location ~= nil and self.buttons[self.location.x][self.location.y] ~= nil) then
        local xChunk = self.xMargin + self.buttonWidth
        local yChunk = self.yMargin + self.buttonHeight
        local xStart = (self.location.x - 1) * xChunk + self.xMargin
        local yStart = (self.location.y - 1) * yChunk + self.yMargin
        local xEnd   = xStart + self.buttonWidth
        local yEnd   = yStart + self.buttonHeight
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.polygon("line", {xStart, yStart, xEnd, yStart, xEnd, yEnd, xStart, yEnd})
    end
    
    -- load love graphics color
    love.graphics.setColor(r, g, b, a)
end

function Menu:onMouseMove(mouseX, mouseY)
    self.location = self:getButton(Vector:create(mouseX, mouseY))
end

function Menu:getButton(location)
    if (location ~= nil) then
        local xChunk = self.xMargin + self.buttonWidth
        local xRaw = location.x / xChunk
        local xN = math.floor(xRaw)
        local xCheck = (xRaw - xN) * xChunk - self.xMargin
        if (xCheck < 0) then
            return nil
        end

        local yChunk = self.yMargin + self.buttonHeight
        local yRaw = location.y / yChunk
        local yN = math.floor(yRaw)
        local yCheck = (yRaw - yN) * yChunk - self.yMargin
        if (yCheck < 0) then
            return nil
        end

        return Vector:create(xN + 1, yN + 1)
    elseif (self.location ~= nil) then
        return self.buttons[self.location.x][self.location.y]
    end
end