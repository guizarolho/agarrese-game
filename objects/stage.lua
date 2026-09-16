local Stage = Object:extend()

function Stage:new(stageMap)
    self.grid = stageMap
    self.totalMemories = 0
    self.cells = {}

    self:buildGrid()
end

function Stage:buildGrid()
    for rowIndex, rowMap in ipairs(self.grid) do
        self.cells[rowIndex] = {}

        for colIndex = 1, #rowMap do
            local char = rowMap:sub(colIndex, colIndex)

            if char == 'o' then
                self.totalMemories = self.totalMemories + 1
            end

            local isObstacle = char == '#'
            local isCollectable = char == '.' or char == 'o'

            self.cells[rowIndex][colIndex] = CellData(
                isObstacle,
                isCollectable,
                char
            )
        end
    end
end

function Stage:getCell(col, row)
    if row < 1 or row > #self.cells then return nil end
    if col < 1 or col > #self.cells[row] then return nil end
    return self.cells[row][col]
end

function Stage:isObstacle(col, row)
    local cell = self:getCell(col, row)
    return not cell or cell.obstacle
end

function Stage:isCollectable(col, row)
    local cell = self:getCell(col, row)
    return cell ~= nil and cell.collectable
end

function Stage:isComplete(memoriesCollected)
    return memoriesCollected >= self.totalMemories
end

function Stage:collect(col, row)
    local cell = self:getCell(col, row)

    if cell and cell.collectable then
        cell.collectable = false
        return cell.char
    end

    return nil
end

function Stage:draw()
    for row, rowCells in ipairs(self.cells) do
        for col, cell in ipairs(rowCells) do

            local px = (col - 1) * TILE_SIZE
            local py = (row - 1) * TILE_SIZE

            if cell.obstacle then
                love.graphics.setColor(0.3, 0.3, 0.3)
                love.graphics.rectangle("fill", px, py, TILE_SIZE, TILE_SIZE)

            elseif cell.collectable and cell.char == 'o' then
                love.graphics.setColor(1, 1, 0.4)
                love.graphics.circle("fill", px + TILE_SIZE / 2, py + TILE_SIZE / 2, TILE_SIZE / 3)

            elseif cell.collectable and cell.char == '.' then
                love.graphics.setColor(1, 1, 1)
                love.graphics.circle("fill", px + TILE_SIZE / 2, py + TILE_SIZE / 2, TILE_SIZE / 6)
            end
        end
    end
end

return Stage