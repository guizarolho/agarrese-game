function love.load()
    Object = require "sti/classic"
    Player = require "objects/player"
    TileSize = 32

    Player:new()

    WINDOW_HEIGHT = 1920
    WINDOW_WIDTH = 1080
    FONT = love.graphics.newFont(18)

    -- TILE = love.graphics.newImage('')
    -- PLAYER_SPRITE = love.graphics.newImage('')
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
    '#    #.##### ## #####.#    #',
    '#    #.##          ##.#    #',
    '#    #.## ######## ##.#    #',
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

function love.update(dt)
    Player:update(dt)
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

    Player:draw()
end