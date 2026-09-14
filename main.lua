function love.load()
    Player = {
        x = 100,
        y = 100,
        speed = 200
    }
end

local function move(x, y)
    Player.x = Player.x + x * Player.speed
    Player.y = Player.y + y * Player.speed
end

function love.update(dt)
    local dx, dy = 0, 0

    if love.keyboard.isDown("w") then
        dy = -1
    end

    if love.keyboard.isDown("a") then
        dx = -1
    end

    if love.keyboard.isDown("s") then
        dy = 1
    end

    if love.keyboard.isDown("d") then
        dx = 1
    end

    move(dx, dy, dt)
end

function love.draw()
    love.graphics.rectangle("fill", Player.x, Player.y, 20, 20)
end