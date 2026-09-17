Message = Object:extend()

function Message:new()
    self.active = false
    self.message = nil

    love.graphics.setFont(_G.FONT)
end

function Message:show()
    self.active = true
end

function Message:setMessage(message)
    self.message = message
end

function Message:keypressed(key)
    if key == 'escape' then
        self.active = false
        self.message = nil
    end
end

function Message:update()
end

function Message:draw()
    if self.active then        
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle(
            "fill",
            0,
            0,
            _G.WINDOW_WIDTH,
            _G.WINDOW_HEIGHT
        )
    
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(
            self.message,
            50,
            420
        )
    end
end

return Message