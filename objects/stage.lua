local Stage = Object:extend()

function Stage:new()
    self.grid = {
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

    self.cells = {}

    self:buildGrid()
end

function Stage:collect(col, row)
    local cell = self.cells[row][col]

    if cell and cell.collectable then
        cell.collectable = false
        return true
    end

    return false
end

function Stage:buildGrid()
    for row, rowStr in ipairs(self.grid) do
        self.cells[row] = {}

        for col = 1, #rowStr do
            local char = rowStr:sub(col, col)

            local isObstacle = char == '#'
            local isCollectable = char == '.' or char == 'o'

            self.cells[row][col] = CellData(
                isObstacle,
                isCollectable
            )
        end
    end
end

function Stage:isObstacle(col, row)
    local cell = self:getCell(col, row)
    return not cell or cell.obstacle
end

function Stage:getCell(col, row)
    if row < 1 or row > #self.cells then return nil end
    if col < 1 or col > #self.cells[row] then return nil end
    return self.cells[row][col]
end

function Stage:draw()
    for row, rowStr in ipairs(self.grid) do
        for col = 1, #rowStr do

            local char = rowStr:sub(col, col)

            local px = (col - 1) * TILE_SIZE
            local py = (row - 1) * TILE_SIZE

            if char == '#' then
                love.graphics.setColor(0.3, 0.3, 0.3)
                love.graphics.rectangle(
                    "fill",
                    px,
                    py,
                    TILE_SIZE,
                    TILE_SIZE
                )

            elseif char == 'o' then
                love.graphics.setColor(1, 1, 0.4)
                love.graphics.circle(
                    "fill",
                    px + TILE_SIZE / 2,
                    py + TILE_SIZE / 2,
                    TILE_SIZE / 3
                )

            elseif char == '.' then
                love.graphics.setColor(1, 1, 1)
                love.graphics.circle(
                    "fill",
                    px + TILE_SIZE / 2,
                    py + TILE_SIZE / 2,
                    TILE_SIZE / 6
                )
            end
        end
    end
end

return Stage