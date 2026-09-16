local Stage = Object:extend()

function Stage:new(stageMap, world)
    self.grid = stageMap
    self.world = world

    self.totalMemories = 0
    self.cells = {}
    self.obstacles = {}

    self.exitHidden = true

    self:buildGrid()
end

function Stage:buildGrid()
    for rowIndex, rowMap in ipairs(self.grid) do
        self.cells[rowIndex] = {}

        for colIndex = 1, #rowMap do
            local char = rowMap:sub(colIndex, colIndex)

            if char == ItemsEnum.Fragment then
                self.totalMemories = self.totalMemories + 1
            end

            local isObstacle = char == '#'
            local isCollectable = false

            for _, value in pairs(ItemsEnum) do
                print(value)
                if char == value then
                    isCollectable = true
                end
            end

            self.cells[rowIndex][colIndex] = CellData(
                isObstacle,
                isCollectable,
                char
            )
            if isObstacle then
                local obstacle = {}

                local x = (colIndex - 1) * TILE_SIZE
                local y = (rowIndex - 1) * TILE_SIZE

                self.world:add(
                    obstacle,
                    x,
                    y,
                    TILE_SIZE,
                    TILE_SIZE
                )

                table.insert(self.obstacles, obstacle)
            end
        end
    end
end

function Stage:showPortal()

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
    local isCompleted = memoriesCollected >= self.totalMemories 
    if isCompleted then
        self.exitHidden = false
    end

    return  isCompleted
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

            elseif cell.collectable and cell.char == ItemsEnum.Fragment then
                love.graphics.setColor(1, 1, 0.4)
                love.graphics.circle("fill", px + TILE_SIZE / 2, py + TILE_SIZE / 2, TILE_SIZE / 3)

            elseif cell.collectable and cell.char == ItemsEnum.Vision then
                love.graphics.setColor(1, 0, 0)
                love.graphics.circle("fill", px + TILE_SIZE / 2, py + TILE_SIZE / 2, TILE_SIZE / 6)
            elseif cell.collectable and cell.char == ItemsEnum.Speed then
                love.graphics.setColor(0, 1, 0)
                love.graphics.circle("fill", px + TILE_SIZE / 2, py + TILE_SIZE / 2, TILE_SIZE / 6)
            elseif cell.collectable and cell.char == ItemsEnum.Invincible then
                love.graphics.setColor(0, 0, 1)
                love.graphics.circle("fill", px + TILE_SIZE / 2, py + TILE_SIZE / 2, TILE_SIZE / 6)
            end

            love.graphics.setColor(1, 1, 1)
        end
    end
end

return Stage