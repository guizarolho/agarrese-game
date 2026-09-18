GameScene = Object:extend()

function GameScene:new()
    self:reset()
end

function GameScene:enter()
    self:reset()
    self:updateMusic()
end


function GameScene:reset()
    self.stageIndex = 1
    self.paused = false
    self.gameClear = false

    self.world = Bump.newWorld(TILE_SIZE)

    self.stage = Stage(
        self.stageIndex,
        self.world
    )

    self.visionRadius = VisionRadius()

    self.gameTimer = GameTimer(_G.TIME_LIMIT)
    self.player = Player(
        self.stage,
        self.visionRadius,
        self.gameTimer,
        self.world
    )

    self.life = Life(self.player, self.stage)
    self.enemies = {}
    for index, _ in ipairs(self.stage.enemySpawns) do
        self.enemies[index] = Enemy(self.player, self.stage, index)
    end

    self.transitioning = false
    self.videoPlayer = nil
    self.message = Message()
end

function GameScene:updateMusic()
    TEsound.stop("music")

    local music = AudioEnum[self.stageIndex]

    if music then
        TEsound.playLooping(
            music,
            "stream",
            "music"
        )
    end
end

function GameScene:update(dt)
    if self.videoPlayer then
        self.videoPlayer:update(dt)
        return
    end

    if self.paused then
        return
    end

    if self.message.active then
        self.message:update(dt)
        return
    end

    self.stage:update(dt)
    self.gameTimer:update(dt)

    if not self.gameTimer.gameOver and not self.player.gameOver then
        self.life:update(dt)
        self.player:update(dt)

        for _, enemy in ipairs(self.enemies) do
            enemy:update(dt)
        end

        self.visionRadius:update(
            self.player.x + self.player.size / 2,
            self.player.y + self.player.size / 2
        )

        self.stage:isComplete(
            self.player.memoriesCollected
        )

        if not self.stage.exitHidden
            and self:isPlayerOnPortal()
        then
            self:beforeNextStage()
        end
    end
end

function GameScene:beforeNextStage()
    if self.transitioning then
        return
    end

    self.transitioning = true
    self.message:show(
        MessageEnum[self.stageIndex],
        function()
            self:nextStage()
        end,
        PhotoEnum[self.stageIndex]
    )
end

function GameScene:isPlayerOnPortal()
    local portal = self.stage.portalSpawn
    if not portal then return false end

    local centerX = self.player.x + self.player.size / 2
    local centerY = self.player.y + self.player.size / 2

    local col = math.floor(centerX / TILE_SIZE) + 1
    local row = math.floor(centerY / TILE_SIZE) + 1

    return col == portal.col and row == portal.row
end

function GameScene:getWorldOffset()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local worldWidth = self.stage:getWidth()
    local worldHeight = self.stage:getHeight()

    local offsetX = (screenWidth - worldWidth) / 2
    local offsetY = (screenHeight - worldHeight) / 2

    return offsetX, offsetY
end

function GameScene:nextStage()
    self.stageIndex = self.stageIndex + 1
    self.transitioning = false

    if not StageEnum[self.stageIndex] then
        self.gameClear = true
        TEsound.stop("music")
        self.videoPlayer = VideoPlayer(
            "video/game_ending.ogv",
            function()
                SceneManager:changeScene(SceneEnum.Credits)
            end
        )
        return
    end

    -- New world
    self.world = Bump.newWorld(TILE_SIZE)

    -- New Stage
    self.stage = Stage(
        self.stageIndex,
        self.world
    )

    -- Reset Player
    self.player.stage = self.stage
    self.player.world = self.world
    self.player:setSpawn(self.stage.playerSpawn)
    self.world:add(
        self.player,
        self.player.x,
        self.player.y,
        self.player.size,
        self.player.size
    )

    -- Reset Enemies
    self.enemies = {}
    for index, _ in ipairs(self.stage.enemySpawns) do
        self.enemies[index] = Enemy(
            self.player,
            self.stage,
            index
        )
    end

    self.player.memoriesCollected = 0
    self.visionRadius:reset()
    self.gameTimer:reset()
    self:updateMusic()

    TEsound.play(AudioEnum.Win, "static", "sfx")
end

function GameScene:draw()
    if self.videoPlayer then
        self.videoPlayer:draw()
        return
    end

    local offsetX, offsetY = self:getWorldOffset()
    love.graphics.push()
    love.graphics.translate(offsetX, offsetY)

    self.stage:draw()
    self.player:draw()

    for _, enemy in ipairs(self.enemies) do
        enemy:draw()
    end

    self.visionRadius:draw()
    self.gameTimer:draw()
    self.life:draw()
    love.graphics.pop()
    

    if self.gameTimer.gameOver or self.player.gameOver then
        self.message:show(
            "GAME OVER",
            function()
                SceneManager:changeScene(SceneEnum.Menu)
            end
        )
    end
    self.message:draw()
end

function GameScene:keypressed(key)
    self.message:keypressed(key)
    if key == 'p' then
        self.paused = not self.paused
    end
end

return GameScene