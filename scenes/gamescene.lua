GameScene = Object:extend()

function GameScene:new()
    self.stage = Stage()
    self.player = Player(self.stage)
    self.gameTimer = GameTimer(TIME_LIMIT)

    self.gameOver = false
end

function GameScene:update(dt)
    if not self.gameOver then
        self.player:update(dt)
    end

    self.gameTimer:update(dt)
end

function GameScene:draw()
    self.stage:draw()
    self.player:draw()
    self.gameTimer:draw()
end

function GameScene:keypressed(key)
end

return GameScene