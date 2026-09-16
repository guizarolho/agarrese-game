local GameTimer = Object:extend()

function GameTimer:new(limit)
    self.timeLeft = limit or 60
    self.gameOver = false
end

function GameTimer:update(dt)
    if self.gameOver then
        return
    end

    self.timeLeft = self.timeLeft - dt

    if self.timeLeft <= 0 then
        self.timeLeft = 0
        self.gameOver = true
    end
end

function GameTimer:addTime(value)
    self.timeLeft = self.timeLeft + value
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