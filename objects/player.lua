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

    self.direction = 'down'
    self.isMoving = false

    self.hitCooldown = 0

    self.world:add(
        self,
        self.x,
        self.y,
        self.size,
        self.size
    )
    self.image = love.graphics.newImage("sprites/joaquim_front.png")
    self.image:setFilter("nearest", "nearest")


    --------------------------------------------------------------------
    --- PLAYER ANIMATION
    --------------------------------------------------------------------
    self.animations = {}

    self.walkDownImage = love.graphics.newImage("sprites/joaquim_walk_down.png")
    local walkDownGrid = Anim8.newGrid(
        _G.TILE_SIZE,
        _G.TILE_SIZE,
        self.walkDownImage:getWidth(),
        self.walkDownImage:getHeight()
    )
    self.animations.down = Anim8.newAnimation(
        walkDownGrid("1-4", 1),
        0.3
    )

    self.walkUpImage = love.graphics.newImage("sprites/joaquim_walk_up.png")
    local walkUpGrid = Anim8.newGrid(
        _G.TILE_SIZE,
        _G.TILE_SIZE,
        self.walkUpImage:getWidth(),
        self.walkUpImage:getHeight()
    )
    self.animations.up = Anim8.newAnimation(
        walkUpGrid("1-4", 1),
        0.3
    )

    self.walkRightImage = love.graphics.newImage("sprites/joaquim_walk_right.png")
    local walkUpGrid = Anim8.newGrid(
        _G.TILE_SIZE,
        _G.TILE_SIZE,
        self.walkRightImage:getWidth(),
        self.walkRightImage:getHeight()
    )
    self.animations.right = Anim8.newAnimation(
        walkUpGrid("1-4", 1),
        0.3
    )

    self.walkLeftImage = love.graphics.newImage("sprites/joaquim_walk_left.png")
    local walkLeftGrid = Anim8.newGrid(
        _G.TILE_SIZE,
        _G.TILE_SIZE,
        self.walkLeftImage:getWidth(),
        self.walkLeftImage:getHeight()
    )
    self.animations.left = Anim8.newAnimation(
        walkLeftGrid("1-4", 1),
        0.3
    )

    -- Load Collect Audio
    -- Load Audio On-hit 
end

function Player:setSpawn(spawn)
    self.x = (spawn.col - 1) * _G.TILE_SIZE
    self.y = (spawn.row - 1) * _G.TILE_SIZE
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
    -- TODO: playSound("fragmentos") aqui, mas só pros itens específicos
    -- que você decidir (Vision, Speed, Invincible, Fragment, ou uma
    -- combinação deles) -- ainda falta definir quais terão esse som

    -- Vision
    if collectedChar == ItemsEnum.Vision then
        local originalRadius = self.visionRadius.radius
        self.visionRadius:alter(originalRadius + _G.VISION_BUFF_FACTOR)
        GAME_TIMER:after(_G.VISION_BUFF_TIMER, function() self.visionRadius:alter(originalRadius) end)

    -- Speed
    elseif collectedChar == ItemsEnum.Speed then
        GAME_TIMER:during(_G.SPEED_BUFF_TIMER, function() self.speed = _G.SPEED_BUFF_FACTOR end, function() self.speed = _G.PLAYER_SPEED end)

    -- Invincible
    elseif collectedChar == ItemsEnum.Invincible then
        GAME_TIMER:during(_G.INVINCIBLE_BUFF_TIMER, function() self.isInvincible = true end, function() self.isInvincible = false end)

    -- Fragment
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

function Player:onHit()
    if self.hitCooldown > 0 then
        return
    end

    self.hitPoints = self.hitPoints - 1
    playSound("dano")
    self.hitCooldown = 1 -- 1 segundo de invencibilidade após tomar dano
end

function Player:update(dt)
    if self.hitCooldown > 0 then
        self.hitCooldown = self.hitCooldown - dt
    end

    local dx, dy = 0, 0

    if love.keyboard.isDown("w") then
        dy = -1
        self.direction = 'up'
        self.animations.up:update(dt)
    end

    if love.keyboard.isDown("a") then
        dx = -1
        self.direction = 'left'
        self.animations.left:update(dt)
    end

    if love.keyboard.isDown("s") then
        dy = 1
        self.direction = 'down'
        self.animations.down:update(dt)
    end

    if love.keyboard.isDown("d") then
        dx = 1
        self.direction = 'right'
        self.animations.right:update(dt)
    end

    if dx ~= 0 or dy ~= 0 then
        self.isMoving = true    
    else
        self.isMoving = false
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

    if self.isMoving then
        if self.direction == 'up' then
                self.animations.up:draw(
                    self.walkUpImage,
                    self.x,
                    self.y
            )
        elseif self.direction == 'left' then
                self.animations.left:draw(
                    self.walkLeftImage,
                    self.x,
                    self.y
                )
        elseif self.direction == 'down' then
            self.animations.down:draw(
                    self.walkDownImage,
                    self.x,
                    self.y
                )
        elseif self.direction == 'right' then
                self.animations.right:draw(
                    self.walkRightImage,
                    self.x,
                    self.y
                )
        end
        else
            love.graphics.draw(
                self.image,
                self.x - (self.spriteSize - self.size) / 2,
                self.y - (self.spriteSize - self.size) / 2,
                0,
                scaleX,
                scaleY
            )
        end
    love.graphics.setColor(1, 1, 1)
end

return Player