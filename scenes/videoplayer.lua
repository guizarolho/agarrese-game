VideoPlayer = Object:extend()

function VideoPlayer:new(path, onFinish)
    self.video = love.graphics.newVideo(path)
    self.onFinish = onFinish -- callback function
    self.finished = false -- flag

    self.video:play()
end

function VideoPlayer:update(dt)
    if self.finished then
        return
    end

    if not self.video:isPlaying() then
        self.finished = true

        if self.onFinish then
            self.onFinish()
        end
    end
end

function VideoPlayer:draw()
    local videoWidth = self.video:getWidth()
    local videoHeight = self.video:getHeight()

    local scale = math.min(
        _G.WINDOW_WIDTH / videoWidth,
        _G.WINDOW_HEIGHT / videoHeight
    )

    local width = videoWidth * scale
    local height = videoHeight * scale

    local x = (_G.WINDOW_WIDTH - width) / 2
    local y = (_G.WINDOW_HEIGHT - height) / 2

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        self.video,
        x,
        y,
        0,
        scale,
        scale
    )
end

function VideoPlayer:keypressed(key)
    if key == "escape" then
        self.video:pause()
    end
end

return VideoPlayer



