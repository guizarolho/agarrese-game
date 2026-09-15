Menu = Object:extend()

function Menu:new()
    self.image = love.graphics.newImage('') 
    love.graphics.setFont(FONT)
end

function Menu:update(dt)
end

function Menu:draw()
    love.graphics.draw(self.image, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 0, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
    love.graphics.print("Press any key to start", 50, 420)
end