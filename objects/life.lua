Life = Object:extend()

function Life:new()
    self.total = 3
    self.current = self.total
    self.width = 150
    self.height = 10
end

function Life:update()
end

function Life:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle(
        "fill",
        _G.WINDOW_HEIGHT - self.width * 2,
        10,
        self.width * (self.current / self.total),
        self.height
    )
end

return Life