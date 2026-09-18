Life = Object:extend()

function Life:new(player)
    self.player = player
    self.maximum = 3
    self.current = self.player.hitPoints
    self.width = 150
    self.height = 10
end

function Life:update(dt)
    self.current = self.player.hitPoints
end

function Life:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle(
        "fill",
        _G.WINDOW_WIDTH / 3,
        10,
        self.width * (self.current / self.maximum),
        self.height
    )
end

return Life