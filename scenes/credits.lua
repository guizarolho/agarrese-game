Credits = Object:extend()

--[[
function Credits:new()
    -- Add background image
    self.background = love.graphics.newImage("assets/credits_background.png")

    love.graphics.setFont(FONT)
end
]]

function Credits:update(dt)
end

function Credits:keypressed(key)
    SceneManager:changeScene(SceneEnum.Menu)
end

function Credits:draw()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    --[[
    local imageWidth = self.background:getWidth()
    local imageHeight = self.background:getHeight()

    -- Calculate scale to fill the entire screen
    local scale = math.max(
        screenWidth / imageWidth,
        screenHeight / imageHeight
    )

    -- Draw background centered and scaled
    love.graphics.draw(
        self.background,
        screenWidth / 2,
        screenHeight / 2,
        0,
        scale,
        scale,
        imageWidth / 2,
        imageHeight / 2
    )
    ]]

    -- Message
    local text = 
    
    "Obrigado por jogar!\n\n".. 
    "ADICIONAR OS NOMES DO GRUPO\n\n" ..


    love.graphics.printf(
        text,
        0,
        screenHeight / 2 - FONT:getHeight() / 2,
        screenWidth,
        "center"
    )
end

return Credits