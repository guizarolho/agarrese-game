local Player = Object:extend()

function Player:new(stage)
    self.x = _G.TILE_SIZE
    self.y = _G.TILE_SIZE
    self.speed = 200
    self.size = 30
    self.stage = stage

    self.memoriesCollected = 0
    self.score = 0
end

function Player:collides(x, y, size)
    local hitObstacle = false
    local left   = math.floor(x / TILE_SIZE) + 1
    local right  = math.floor((x + size - 1) / TILE_SIZE) + 1
    local top    = math.floor(y / TILE_SIZE) + 1
    local bottom = math.floor((y + size - 1) / TILE_SIZE) + 1

    for row = top, bottom do
        for col = left, right do
            if self.stage:isObstacle(col, row) then
                hitObstacle = true
            elseif self.stage:isCollectable(col, row) then
                self:collect(col, row)
            end
        end
    end

    return hitObstacle
end

function Player:collect(col, row)
    local collectedChar = self.stage:collect(col, row)

    if collectedChar == '.' then
        self.score = self.score + 10
    elseif collectedChar == 'o' then
        self.memoriesCollected = self.memoriesCollected + 1
    end
end

function Player:move(dx, dy, dt)
    local newX = self.x + dx * self.speed * dt

    if not self:collides(newX, self.y, self.size) then
        self.x = newX
    end

    local newY = self.y + dy * self.speed * dt

    if not self:collides(self.x, newY, self.size) then
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