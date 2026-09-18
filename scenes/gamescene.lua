GameScene = Object:extend()

function GameScene:new()
    self:reset()
end

function GameScene:enter()
    self:reset()
end


function GameScene:reset()
    self.stageIndex = 4
    self.paused = false
    self.gameOver = false

    self.world = Bump.newWorld(TILE_SIZE)

    self.stage = Stage(
        self.stageIndex,
        self.world
    )

    self.visionRadius = VisionRadius()

    self.life = Life()
    self.gameTimer = GameTimer(_G.TIME_LIMIT)
    self.player = Player(
        self.stage,
        self.visionRadius,
        self.gameTimer,
        self.world
    )

    self.enemies = {}
    for index, _ in ipairs(self.stage.enemySpawns) do
        self.enemies[index] = Enemy(self.player, self.stage, index)
    end

    self.transitioning = false
    self.stageMessages = {
        [1] = "fase1",
        [2] = "fase2",
        [3] = "fase3",
        [4] = "fase4"
    }

    self.message = Message()
    -- TESound:play(soundtrack)
end

function GameScene:update(dt)
    if self.paused then
        return
    end

    self.stage:update(dt)
    self.gameTimer:update(dt)

    if not self.gameTimer.gameOver then

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
        self.stageMessages[self.stageIndex],
        function()
            self:nextStage()
        end
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

function GameScene:nextStage()
    self.stageIndex = self.stageIndex + 1
    self.transitioning = false

    if not StageEnum[self.stageIndex] then
        self.gameOver = true
        SceneManager:changeScene(SceneEnum.Credits)
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

    self.visionRadius:reset()
    self.player.memoriesCollected = 0
end

function GameScene:draw()
    self.stage:draw()
    self.player:draw()
    for _, enemy in ipairs(self.enemies) do
        enemy:draw()
    end
    
    self.message:draw()
    self.visionRadius:draw()
    self.gameTimer:draw()
    self.life:draw()
end

function GameScene:keypressed(key)
    if key == 'p' then
        self.paused = not self.paused
    end
end

return GameScene