-- https://www.youtube.com/watch?v=d-geCesItCc
SceneManager = Object:extend()

function SceneManager:new()
    self.scenes = {}
    self.currentScene = nil
    self.currentSceneIndex = nil -- Scene list enum value
    self.transitioning = false
    self.alpha = 0
end

function SceneManager:addScene(index, scene)
    self.scenes[index] = scene
end

function SceneManager:changeScene(name, duration)
    if self.transitioning or not self.scenes[name] then return end

    -- Hides Current Screen
    duration = duration or 0.4
    self.transitioning = true
    self.targetSceneName = name
    self.alpha = 0

    -- Gradually Displays New Screen
    TIMER:tween(duration, self, {alpha = 1}, 'linear', function()
        self.currentScene = self.scenes[self.targetSceneName]
        self.currentSceneIndex = self.targetSceneName

        if self.currentScene.enter then
            self.currentScene:enter()
        end

        -- Terminates transitioning, sets boolean false, hides transition rectangle
        TIMER:tween(duration, self, {alpha = 0}, 'linear', function()
            self.transitioning = false
        end)
    end)
end

function SceneManager:update(dt)
    if self.currentScene then
        self.currentScene:update(dt)
    end
end

function SceneManager:keypressed(key)
    if self.currentScene and self.currentScene.keypressed then
        self.currentScene:keypressed(key)
    end
end

function SceneManager:draw()
    if self.currentScene then
        self.currentScene:draw()
    end

    if self.transitioning then
        love.graphics.setColor(0, 0, 0, self.alpha) -- hidden

        love.graphics.rectangle(
            "fill",
            0,
            0,
            WINDOW_WIDTH,
            WINDOW_HEIGHT
        )

        love.graphics.setColor(1, 1, 1, 1) -- shown
    end
end

return SceneManager