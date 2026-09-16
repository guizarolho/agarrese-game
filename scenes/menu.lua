Menu = Object:extend()

function Menu:new()
    -- self.image = 'path'
    love.graphics.setFont(FONT)
end

function Menu:update(dt)
end

function Menu:keypressed(key)
    SceneManager:changeScene(SceneEnum.Game)
end

function Menu:draw()
    -- Add background image love.graphics.newImage(.png)
    love.graphics.print(
        "Press any key to start",
        50,
        420
    )
end

return Menu