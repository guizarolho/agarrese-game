Message = Object:extend()

-- Modal Class
function Message:new()
    self.active = false
    self.message = nil
    self.image = nil
    self.onClose = nil

    love.graphics.setFont(_G.FONT)
end

function Message:show(message, onClose, image)
    self.active = true
    self.message = message
    self.onClose = onClose
    self.image = image and love.graphics.newImage(image) or nil
end

function Message:keypressed(key)
    if key == 'escape' and self.active then
        self.active = false
        
        local callback = self.onClose

        self.message = nil
        self.image = nil
        self.onClose = nil

        if callback then 
            callback()
        end
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
        if self.image ~= nil then
            local imageWidth = self.image:getWidth()
            local imageHeight = self.image:getHeight()

            local scale = math.min(
                _G.WINDOW_WIDTH / imageWidth,
                _G.WINDOW_HEIGHT / imageHeight
            )

            local width = imageWidth * scale
            local height = imageHeight * scale

            local x = (_G.WINDOW_WIDTH - width) / 2
            local y = (_G.WINDOW_HEIGHT - height) / 2
            love.graphics.draw(
                self.video,
                x,
                y,
                0,
                scale,
                scale
            )
        end
        if self.message ~= nil then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print(
                self.message,
                50,
                420
            )
        end
    end
end

return Message