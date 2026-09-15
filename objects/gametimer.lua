local GameTimer = Object:extend()

function GameTimer:new(limit)
    self.limit = limit or 60
    self.timeLeft = self.limit
    self.gameOver = false

    -- Delay / During / After
    TIMER:during(self.limit,
        function(dt, left)
            self.timeLeft = left
        end,
        function()
            self.gameOver = true
            self.timeLeft = 0
        end
    )
end

function GameTimer:update()
end

function GameTimer:draw()
    love.graphics.setFont(FONT)
    love.graphics.print(string.format("%d", math.ceil(self.timeLeft)), 10, 10)

    if self.gameOver then
        love.graphics.printf("GAME OVER", 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, "center")
    end
end

return GameTimer