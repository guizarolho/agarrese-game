GameScene = Object:extend()

function GameScene:new()
    self.stageIndex = 0
    self.stage = Stage(StageEnum[self.stageIndex])
    self.visionRadius = VisionRadius()
    self.player = Player(self.stage, self.visionRadius)
    self.gameTimer = GameTimer(TIME_LIMIT)
    self.gameOver = false
end

function GameScene:update(dt)
    if not self.gameOver then
        self.player:update(dt)
        self.visionRadius:update(
            -- Center circle to object 
            self.player.x + self.player.size / 2,
            self.player.y + self.player.size / 2
        )
    end
    if self.stage:isComplete(self.player.memoriesCollected) then
        self:nextStage()
    end

    self.gameTimer:update(dt)
end

function GameScene:nextStage()
    self.stageIndex = self.stageIndex + 1

    if not StageEnum[self.stageIndex] then
        self.gameOver = true
        return
    end

    self.stage = Stage(StageEnum[self.stageIndex])
    self.player.stage = self.stage
    self.player.memoriesCollected = 0
    self.player.x, self.player.y = TILE_SIZE, TILE_SIZE
end

function GameScene:draw()
    self.stage:draw()
    self.player:draw()
    self.visionRadius:draw()
    self.gameTimer:draw()
end

function GameScene:keypressed(key)
end

return GameScene