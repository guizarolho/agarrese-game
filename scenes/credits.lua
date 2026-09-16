Credits = Object:extend()

function Credits:new()
    -- Add background image
    love.graphics.setFont(FONT)
end

function Credits:update(dt)
end

function Credits:keypressed(key)
    SceneManager:changeScene(SceneEnum.Menu)
end

function Credits:draw()
    love.graphics.print(
        "Thank you for playing!",
        50,
        420
    )
end

return Credits