Menu = Object:extend()

function Menu:new()
    -- Add background image
    love.graphics.setFont(FONT)
end

function Menu:update(dt)
end

function Menu:keypressed(key)
    SceneManager:changeScene(SceneEnum.Game)
end

function Menu:draw()
    love.graphics.print(
        "Press any key to start",
        50,
        420
    )
end

return Menu