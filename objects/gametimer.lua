local GameTimer = Object:extend()

function GameTimer:new()
    self:reset()
end

function GameTimer:reset(limit)
    self.timeLeft = limit or 60
    self.gameOver = false
    self.playSound = false
end

function GameTimer:update(dt)
    if self.gameOver then
        return
    end

    self.timeLeft = self.timeLeft - dt

    if self.timeLeft <= 0 then
        self.timeLeft = 0
        self.gameOver = true

        if not self.hasPlayedSound then
            TEsound.play(AudioEnum.GameOver, "static", "sfx")
            self.hasPlayedSound = true
        end
    end
end

function GameTimer:addTime(value)
    self.timeLeft = self.timeLeft + value
end

function GameTimer:draw()
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.setFont(love.graphics.newFont(50))

    love.graphics.print(
        string.format("%d", math.ceil(self.timeLeft)),
        10,
        10
    )

    -- Sets standard fonts
    love.graphics.setFont(_G.FONT)
end

return GameTimer