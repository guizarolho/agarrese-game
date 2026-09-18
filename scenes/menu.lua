Menu = Object:extend()
--[[
function Menu:new()

    love.graphics.setFont(FONT)

    -- Carrega a imagem de fundo
    -- colocar o diretorio correto da imagem de fundo do menu
    self.background = love.graphics.newImage("assets/menu_background.png")

end ]]

function Menu:update(dt)

end

function Menu:keypressed(key)
    SceneManager:changeScene(SceneEnum.Game)
end

function Menu:draw()

    --[[ Desenha o fundo
    love.graphics.draw(
        self.background,
        0,
        0
    )
    ]]

    local text =
        "Agarre-se
        \n\n" ..
        "Como jogar: use W, A, S, D para mover seu personagem pelo labirinto.
        \n\n" ..
        "Seu objetivo é coletar todos os fragmentos de memória para desbloquear a memória completa." ..
        "Fuja do tempo e colete itens para te ajudar no caminho. Boa sorte!
        \n\n" ..
        "Pressione qualquer tecla para começar o jogo."

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