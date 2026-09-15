function love.load()
    WindowWidth = 1080
    WindowHeight = 1920
    TileSize = 32
    Player = {
        x = 40,
        y = 40,
        speed = 200,
        size = 20
    }
end

-- https://github.com/Przemekkkth/love-pacman/
MapGrid = {
    '############################',
    '#............##............#',
    '#.####.#####.##.#####.####.#',
    '#o#  #.#   #.##.#   #.#  #o#',
    '#.####.#####.##.#####.####.#',
    '#..........................#',
    '#.####.##.########.##.####.#',
    '#.####.##.###  ###.##.####.#',
    '#......##....##....##......#',
    '######.#####.##.#####.######',
    '     #.##### ## #####.#    #',
    '     #.##          ##.#    #',
    '     #.## ######## ##.#    #',
    '######.## #      # ##.######',
    '      .   #      #   .      ',
    '######.## #      # ##.######',
    '#    #.## ######## ##.#    #',
    '#    #.##          ##.#    #',
    '#    #.##.########.##.#    #',
    '######.##.###  ###.##.######',
    '#............##............#',
    '#.####.#####.##.#####.####.#',
    '#.####.#####.##.#####.####.#',
    '#o..##.......  .......##..o#',
    '###.##.##.########.##.##.###',
    '###.##.##.###  ###.##.##.###',
    '#......##....##....##......#',
    '#.#####  ###.##.###  #####.#',
    '#.##########.##.##########.#',
    '#..........................#',
    '############################'
}

local function isWall(col, row)
    local rowStr = MapGrid[row]
    if not rowStr then return true end
    local char = rowStr:sub(col, col)
    if char == '' then return true end
    return char == '#'
end

local function collides(x, y, size)
    local left   = math.floor(x / TileSize) + 1
    local right  = math.floor((x + size - 1) / TileSize) + 1
    local top    = math.floor(y / TileSize) + 1
    local bottom = math.floor((y + size - 1) / TileSize) + 1

    for row = top, bottom do
        for col = left, right do
            if isWall(col, row) then
                return true
            end
        end
    end
    return false
end

local function move(dx, dy, dt)
    local newX = Player.x + dx * Player.speed * dt
    if not collides(newX, Player.y, Player.size) then
        Player.x = newX
    end

    local newY = Player.y + dy * Player.speed * dt
    if not collides(Player.x, newY, Player.size) then
        Player.y = newY
    end
end

function love.update(dt)
    local dx, dy = 0, 0
    if love.keyboard.isDown("w") then dy = -1 end
    if love.keyboard.isDown("a") then dx = -1 end
    if love.keyboard.isDown("s") then dy = 1 end
    if love.keyboard.isDown("d") then dx = 1 end
    move(dx, dy, dt)
end

function love.draw()
    for row, rowStr in ipairs(MapGrid) do
        for col = 1, #rowStr do
            local char = rowStr:sub(col, col)
            local px = (col - 1) * TileSize
            local py = (row - 1) * TileSize

            if char == '#' then
                love.graphics.setColor(0.3, 0.3, 0.3)
                love.graphics.rectangle("fill", px, py, TileSize, TileSize)
            elseif char == 'o' then
                love.graphics.setColor(1, 1, 0.4)
                love.graphics.circle("fill", px + TileSize/2, py + TileSize/2, TileSize/3)
            end
        end
    end

    -- Draw the player
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", Player.x, Player.y, Player.size, Player.size)
end