Credits = Object:extend()

function Credits:new()
    -- Add background image
    -- self.background = love.graphics.newImage("assets/credits_background.png")

    love.graphics.setFont(FONT)
end

function Credits:enter()
    TEsound.stop("music")
    -- playMusic("menu")
end

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
    local text = [[
        Créditos Game

        Programação: 
        Guilherme Mendes Fontes

        Game design: 
        Victor Resende 
        Flávio Eduardo Romano

        Pixel Art:
        Alberto Kin
        Giovanna Vieira

        Creative Writing:
        Camille Borges

        Ilustração:
        Maria Clara Hasegawa

        Temática:
        Lucas Rossi 

        Teaser: 
        João Vitor Carvalho
        Max Ribeiro
        André Costalonga
        Lucas Rossi

        Trilhas e efeitos:
        Natal - Leberch Christmas
        The Fishing - AmmitMusics
        Kitchen cooking show - Alex Morgan
        This Heavy Metal - MrClaps
        Player Hit - Grey Frog Games
    ]]
    

    love.graphics.printf(
        text,
        0,
        200,
        screenWidth,
        "center"
    )
end

return Credits