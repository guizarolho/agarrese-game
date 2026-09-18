Credits = Object:extend()

function Credits:new()
    love.graphics.setFont(FONT)
end

function Credits:enter()

    -- Para a música anterior
    TEsound.stop("music")

    -- Música dos créditos
    TEsound.playLooping(
        AudioEnum.theme,
        "static",
        "music"
    )

end

function Credits:update(dt)

end

function Credits:keypressed(key)

    TEsound.stop("music")

    SceneManager:changeScene(SceneEnum.Menu)

end

function Credits:draw()

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

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