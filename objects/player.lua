local function getCell(col, row)
    if row < 1 or row > #Stage.cells then
        return nil
    end

    if col < 1 or col > #Stage.cells[row] then
        return nil
    end

    return Stage.cells[row][col]
end

local function collides(x, y, size)
    local left   = math.floor(x / TILE_SIZE) + 1
    local right  = math.floor((x + size - 1) / TILE_SIZE) + 1
    local top    = math.floor(y / TILE_SIZE) + 1
    local bottom = math.floor((y + size - 1) / TILE_SIZE) + 1

    for row = top, bottom do
        for col = left, right do
            local cell = getCell(col, row)
            if not cell or cell.obstacle then
                return true
            elseif cell.passable and not cell.obstacle then
                return false
                -- collect 
            end
        end
    end

    return false
end

local Player = Object:extend()

function Player:new()
    self.x = 32
    self.y = 32
    self.speed = 200
    self.size = 30
end

function Player:move(dx, dy, dt)
    local newX = self.x + dx * self.speed * dt

    if not collides(newX, self.y, self.size) then
        self.x = newX
    end

    local newY = self.y + dy * self.speed * dt

    if not collides(self.x, newY, self.size) then
        self.y = newY
    end
end

function Player:update(dt)
    local dx, dy = 0, 0

    if love.keyboard.isDown("w") then
        dy = -1
    end

    if love.keyboard.isDown("a") then
        dx = -1
    end

    if love.keyboard.isDown("s") then
        dy = 1
    end

    if love.keyboard.isDown("d") then
        dx = 1
    end

    self:move(dx, dy, dt)
end

function Player:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle(
        "fill",
        self.x,
        self.y,
        self.size,
        self.size
    )
end

return Player