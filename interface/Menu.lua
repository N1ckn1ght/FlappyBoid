Menu = {}
Menu.__index = Menu

function Menu:create(buttons, fontSize, width, height, x, y, xMargin, yMargin, transparency)
    local menu = {}
    setmetatable(menu, Menu)
    menu.fontSize     = fontSize or 30
    menu.width        = width or Width
    menu.height       = height or Height
    menu.x            = x or 0
    menu.y            = y or 0
    menu.xMargin      = xMargin or 30
    menu.yMargin      = yMargin or 30
    menu.transparency = transparency
    menu:init(buttons)
    return menu
end

function Menu:init(buttons)
    self.buttons = buttons
    self.font = love.graphics.newFont(self.fontSize)
    self.buttonWidth = (self.width - self.xMargin * (#self.buttons + 1)) / #self.buttons
    self.buttonHeight = 1
    for _, v in pairs(self.buttons) do
        self.buttonHeight = math.max(self.buttonHeight, #v)
    end
    self.buttonHeight = math.min(180, (self.height - self.yMargin * (self.buttonHeight + 1)) / self.buttonHeight)
end

function Menu:draw()
    -- save love graphics color
    local r, g, b, a = love.graphics.getColor()
    local xChunk = self.xMargin + self.buttonWidth
    local yChunk = self.yMargin + self.buttonHeight

    for k1, column in pairs(self.buttons) do
        for k2, row in pairs(column) do
            if (#row > 0) then
                local x = k1 * self.xMargin + (k1 - 1) * self.buttonWidth + self.x
                local y = k2 * self.yMargin + (k2 - 1) * self.buttonHeight + self.y
                if (self.transparency) then
                    love.graphics.setColor(0, 0, 0, self.transparency)
                    love.graphics.polygon("fill", {x, y, x + self.buttonWidth, y, x + self.buttonWidth, y + self.buttonHeight, x, y + self.buttonHeight})
                end
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.printf(row[1], self.font, x, y, self.buttonWidth, 'center',
                0, 1, 1, 0, -self.buttonHeight / 3)
            end
        end
    end

    if (self.location ~= nil and self.buttons[self.location.x][self.location.y] ~= nil and #self.buttons[self.location.x][self.location.y] > 0) then
        local x = (self.location.x - 1) * xChunk + self.xMargin + self.x
        local y = (self.location.y - 1) * yChunk + self.yMargin + self.y
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.polygon("line", {x, y, x + self.buttonWidth, y, x + self.buttonWidth, y + self.buttonHeight, x, y + self.buttonHeight})
    end
    
    -- load love graphics color
    love.graphics.setColor(r, g, b, a)
end

function Menu:onMouseMove(mouseX, mouseY)
    self.location = self:getButton(Vector:create(mouseX, mouseY))
end

function Menu:getButton(location)
    if (location) then
        local xChunk = self.xMargin + self.buttonWidth
        local xRaw = (location.x - self.x) / xChunk
        local xN = math.floor(xRaw)
        local xCheck = (xRaw - xN) * xChunk - self.xMargin
        if (xCheck < 0) then
            return nil
        end

        local yChunk = self.yMargin + self.buttonHeight
        local yRaw = (location.y - self.y) / yChunk
        local yN = math.floor(yRaw)
        local yCheck = (yRaw - yN) * yChunk - self.yMargin
        if (yCheck < 0) then
            return nil
        end

        return Vector:create(xN + 1, yN + 1)
    elseif (self.location) then
        return self.buttons[self.location.x][self.location.y]
    end
end