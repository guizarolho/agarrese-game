GameScene = Object:extend()

function GameScene:new()
    self.stage = Stage()
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

    self.gameTimer:update(dt)
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