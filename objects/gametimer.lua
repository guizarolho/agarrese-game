local GameTimer = Object:extend()

function GameTimer:new(limit)
    -- Load audio for tick (?)
    self.limit = limit or 60
    self.timeLeft = self.limit
    self.gameOver = false
    self.paused = false
end

function GameTimer:update(dt)
    if self.paused or self.gameOver then
        return
    end

    self.timeLeft = self.timeLeft - dt

    if self.timeLeft <= 0 then
        self.timeLeft = 0
        self.gameOver = true
    end
end

function GameTimer:pause()
    self.paused = true
end

function GameTimer:resume()
    self.paused = false
end

function GameTimer:draw()
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.setFont(FONT)

    love.graphics.print(
        string.format("%d", math.ceil(self.timeLeft)),
        10,
        10
    )

    if self.gameOver then
        love.graphics.printf(
            "GAME OVER",
            0,
            WINDOW_HEIGHT / 2,
            WINDOW_WIDTH,
            "center"
        )
    end
end

return GameTimer