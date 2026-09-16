GameScene = Object:extend()

function GameScene:new()
    self:reset()
end

function GameScene:enter()
    self:reset()
end


function GameScene:reset()
    self.stageIndex = 0
    self.paused = false
    self.gameOver = false

    self.world = Bump.newWorld(TILE_SIZE)

    self.stage = Stage(
        StageEnum[self.stageIndex],
        self.world
    )

    self.visionRadius = VisionRadius()

    self.player = Player(
        self.stage,
        self.visionRadius,
        self.world
    )

    self.gameTimer = GameTimer(_G.TIME_LIMIT)
    -- TESound:play(soundtrack)
end

function GameScene:update(dt)
    if self.paused then
        return
    end
    self.gameTimer:update(dt)

    if not self.gameTimer.gameOver then
        self.player:update(dt)

        self.visionRadius:update(
            self.player.x + self.player.size / 2,
            self.player.y + self.player.size / 2
        )
    end

    if not self.gameTimer.gameOver
        and self.stage:isComplete(self.player.memoriesCollected)
    then
        self:nextStage()
    end
end

function GameScene:nextStage()
    self.stageIndex = self.stageIndex + 1

    if not StageEnum[self.stageIndex] then
        self.gameOver = true
        SceneManager:changeScene(SceneEnum.Credits)
        return
    end

    self.world = Bump.newWorld(TILE_SIZE)
    self.stage = Stage(
        StageEnum[self.stageIndex],
        self.world
    )
    self.visionRadius:reset()

    self.player.stage = self.stage
    self.player.world = self.world

    self.player.x = TILE_SIZE
    self.player.y = TILE_SIZE

    self.world:add(
        self.player,
        self.player.x,
        self.player.y,
        self.player.size,
        self.player.size
    )

    self.player.memoriesCollected = 0
end

function GameScene:draw()
    self.stage:draw()
    self.player:draw()
    self.visionRadius:draw()
    self.gameTimer:draw()
end

function GameScene:keypressed(key)
    if key == 'p' then
        self.paused = not self.paused

        if self.paused then
            self.gameTimer:pause()
        else
            self.gameTimer:resume()
        end
    end
end

return GameScene