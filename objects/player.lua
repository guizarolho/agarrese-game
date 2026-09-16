local Player = Object:extend()

function Player:new(stage, visionRadius, gameTimer, world)
    local spawn = stage.playerSpawn

    self.x = (spawn.col - 1) * _G.TILE_SIZE
    self.y = (spawn.row - 1) * _G.TILE_SIZE
    self.speed = _G.PLAYER_SPEED
    self.spriteSize = _G.TILE_SIZE
    self.size = _G.TILE_SIZE - 3

    self.stage = stage
    self.world = world
    self.visionRadius = visionRadius
    self.hitPoints = 3

    self.isInvincible = false
    self.memoriesCollected = 0
    self.gameTimer = gameTimer

    self.world:add(
        self,
        self.x,
        self.y,
        self.size,
        self.size
    )
    self.image = love.graphics.newImage("sprites/joaquim.png")
    self.image:setFilter("nearest", "nearest")

    -- Load Sprite
    -- Load Collect Audio
    -- Load Audio On-hit 

    -- Column / Row / Frame
    -- anim8.newAnimation(self.grid('4-6', 1), 0.2) 
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
    -- TEsound.play(collectEffect)
    if collectedChar == ItemsEnum.Vision then
        local originalRadius = self.visionRadius.radius

        self.visionRadius:alter(originalRadius + _G.VISION_BUFF_FACTOR)

        GAME_TIMER:after(_G.VISION_BUFF_TIMER, function() self.visionRadius:alter(originalRadius) end)
    elseif collectedChar == ItemsEnum.Speed then
        GAME_TIMER:during(_G.SPEED_BUFF_TIMER, function() self.speed = _G.SPEED_BUFF_FACTOR end, function() self.speed = _G.PLAYER_SPEED end)
    elseif collectedChar == ItemsEnum.Invincible then
        GAME_TIMER:during(_G.INVINCIBLE_BUFF_TIMER, function() self.isInvincible = true end, function() self.isInvincible = false end)
    elseif collectedChar == ItemsEnum.Fragment then
        self.memoriesCollected = self.memoriesCollected + 1
        self.gameTimer:addTime(_G.GAME_TIMER_BUFF)
        if self.stage:isComplete(self.memoriesCollected) then
            self.visionRadius:alter(10000000)
        else
            self.visionRadius:alter(self.visionRadius.radius + 50)
        end
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
    love.graphics.setColor(1, 1, 1, 1)
    if self.isInvincible then
        love.graphics.setColor(1, 0, 0)
    end

    local scaleX = self.spriteSize / self.image:getWidth()
    local scaleY = self.spriteSize / self.image:getHeight()

    love.graphics.draw(
        self.image,
        self.x - (self.spriteSize - self.size) / 2,
        self.y - (self.spriteSize - self.size) / 2,
        0,
        scaleX,
        scaleY
    )
    love.graphics.setColor(1, 1, 1)
end

return Player