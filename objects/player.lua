local Player = Object:extend()

function Player:new(stage, visionRadius, world)
    self.x = _G.TILE_SIZE
    self.y = _G.TILE_SIZE
    self.speed = 200
    self.spriteSize = TILE_SIZE
    self.size = TILE_SIZE - 3
    self.stage = stage
    self.world = world
    self.visionRadius = visionRadius
    self.hitPoints = 3

    self.isInvincible = false
    self.memoriesCollected = 0

    self.world:add(
        self,
        self.x,
        self.y,
        self.size,
        self.size
    )
end

function Player:checkCollectable()
    local centerX = self.x + self.size / 2
    local centerY = self.y + self.size / 2

    local col = math.floor(centerX / TILE_SIZE) + 1
    local row = math.floor(centerY / TILE_SIZE) + 1

    if self.stage:isCollectable(col, row) then
        self:collect(col, row)
    end
end


function Player:collect(col, row)
    local collectedChar = self.stage:collect(col, row)
    -- TEsound.play()
    if collectedChar == 'x' then
        TIMER:during(10, function() self.isInvincible = true end, function() self.isInvincible = false end)
    elseif collectedChar == '/' then
        TIMER:during(10, function() self.speed = 600 end, function() self.speed = 200 end)
    elseif collectedChar == 'o' then
        self.memoriesCollected = self.memoriesCollected + 1
        self.visionRadius:alter(self.visionRadius.radius + 100)
    end
end

function Player:move(dx, dy, dt)
    local goalX = self.x + dx * self.speed * dt
    local goalY = self.y + dy * self.speed * dt

    local x, y = self.world:move(
        self,
        goalX,
        goalY
    )

    self.x = x
    self.y = y
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
    self:checkCollectable()
end

function Player:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle(
        "fill",
        self.x - (self.spriteSize - self.size) / 2,
        self.y - (self.spriteSize - self.size) / 2,
        self.spriteSize,
        self.spriteSize
    )
end

return Player