Life = Object:extend()

function Life:new(player, stage)
    self.player = player
    self.stage = stage

    self.current = self.player.currentHitPoints
    self.maximum = self.player.maxHitPoints
    
    self.width = 150
    self.height = 10
    self.margin = 10
end

function Life:update(dt)
    self.current = self.player.currentHitPoints
end

function Life:draw()
    local worldWidth = self.stage:getWidth() 
    local x = worldWidth - self.width - self.margin
    local y = 10 love.graphics.setColor(0.2, 0.2, 0.2)

    love.graphics.rectangle( "fill", x, y, self.width, self.height )
    love.graphics.setColor(1, 0, 0) 
    love.graphics.rectangle( 
        "fill",
        x,
        y,
        self.width * (self.current / self.maximum),
        self.height
    )
    love.graphics.setColor(1, 1, 1)
end

return Life