function love.load()
    Object = require "sti/classic"
    Player = require "objects/player"

    Player:new()

    WINDOW_HEIGHT = 1920
    WINDOW_WIDTH = 1080
    TILE_SIZE = 32
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
            local px = (col - 1) * TILE_SIZE
            local py = (row - 1) * TILE_SIZE

            if char == '#' then
                love.graphics.setColor(0.3, 0.3, 0.3)
                love.graphics.rectangle("fill", px, py, TILE_SIZE, TILE_SIZE)
            elseif char == 'o' then
                love.graphics.setColor(1, 1, 0.4)
                love.graphics.circle("fill", px + TILE_SIZE/2, py + TILE_SIZE/2, TILE_SIZE/3)
            end
        end
    end

    Player:draw()
end