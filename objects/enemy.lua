local Enemy = Object:extend()

function Enemy:new(x, y)
    self.x = x
    self.y = y
    self.speed = 200
    self.size = 30
end

function Enemy:update()
    -- move patrol
end

function Enemy:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle(
        "fill",
        self.x,
        self.y,
        self.size,
        self.size
    )
end

return Enemy