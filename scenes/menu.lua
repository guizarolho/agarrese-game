Menu = Object:extend()

function Menu:new()

    love.graphics.setFont(FONT)

    self.title = love.graphics.newImage("illustrations/title.png")

end

function Menu:enter()

    -- Para qualquer música que estava tocando
    TEsound.stop("music")

    -- Música do menu
    TEsound.playLooping(
        AudioEnum.theme,
        "static",
        "music"
    )

end

function Menu:update(dt)

end

function Menu:keypressed(key)

    -- Para a música do menu antes de começar o jogo
    TEsound.stop("music")

    SceneManager:changeScene(SceneEnum.Game)

end

function Menu:draw()

    love.graphics.draw(
        self.title,
        750,
        250,
        0,
        10,
        10
    )

    local text = [[
        Agarre-se
        
        Como jogar: use W, A, S, D para mover seu personagem pelo labirinto.
        
        Seu objetivo é coletar todos os fragmentos de memória para desbloquear a memória completa.
        Fuja do tempo e colete itens para te ajudar no caminho. Boa sorte!



        Pressione qualquer tecla para começar o jogo.
    ]]

    local screenWidth = love.graphics.getWidth()

    love.graphics.printf(
        text,
        50,
        420,
        screenWidth - 100,
        "center"
    )

end

return Menu