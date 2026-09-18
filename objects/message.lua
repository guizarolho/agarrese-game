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
    if not self.active then
        return
    end

    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle(
        "fill",
        0,
        0,
        _G.WINDOW_WIDTH,
        WINDOW_HEIGHT

    )
    if self.image ~= nil then
        local imageWidth = self.image:getWidth()
        local imageHeight = self.image:getHeight()

        local maxWidth = _G.WINDOW_WIDTH * 0.75
        local maxHeight = _G.WINDOW_HEIGHT * 0.65

        local scale = math.min(
            maxWidth / imageWidth,
            maxHeight / imageHeight
        )

        local width = imageWidth * scale
        local height = imageHeight * scale

        local x = (_G.WINDOW_WIDTH - width) / 2
        local y = (_G.WINDOW_HEIGHT - height) / 2

        love.graphics.setColor(0.05, 0.05, 0.05, 1)
        love.graphics.rectangle(
            "fill",
            x - 10,
            y - 10,
            width + 20,
            height + 20
        )

        -- Imagem
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(
            self.image,
            x,
            y,
            0,
            scale,
            scale
        )
    end

    -- Mensagem
    if self.message ~= nil then
        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.printf(
            self.message,
            50,
            _G.WINDOW_HEIGHT - 100,
            _G.WINDOW_WIDTH - 100,
            "center"
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return Message