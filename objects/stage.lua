local Stage = Object:extend()

function Stage:new(stageMap, world)
    self.grid = stageMap
    self.world = world

    self.totalMemories = 0
    self.cells = {}
    self.obstacles = {}

    self.playerSpawn = nil
    self.portalSpawn = nil
    self.enemySpawns = {}
    self.exitHidden = true

    self:buildGrid()
    self:buildPathNodes()
end

-- Builds path nodes for A*
function Stage:buildPathNodes()
    self.pathNodes = {}
    self.nodeAt = {}

    for rowIndex, rowCells in ipairs(self.cells) do
        self.nodeAt[rowIndex] = {}
        for colIndex, cell in ipairs(rowCells) do
            if not cell.obstacle then
                local node = {x = colIndex, y = rowIndex}
                table.insert(self.pathNodes, node)
                self.nodeAt[rowIndex][colIndex] = node
            end
        end
    end
end

-- Builds cell data grid
-- https://discussions.unity.com/t/unity-learn-course-create-a-2d-roguelike-game-add-obstacles-2-add-obstacles/1645084
function Stage:buildGrid()
    for rowIndex, rowMap in ipairs(self.grid) do
        self.cells[rowIndex] = {}

        for colIndex = 1, #rowMap do
            local char = rowMap:sub(colIndex, colIndex)

            if char == ItemsEnum.Fragment then
                self.totalMemories = self.totalMemories + 1
            end

            if char == SpawnEnum.PlayerSpawn then
                self.playerSpawn = {
                    col = colIndex,
                    row = rowIndex
                }

            elseif char == SpawnEnum.PortalSpawn then
                self.portalSpawn = {
                    col = colIndex,
                    row = rowIndex
                }

            elseif char == SpawnEnum.EnemySpawn then
                table.insert(self.enemySpawns, {
                    col = colIndex,
                    row = rowIndex
                })
            end

            local isCollectable = false

            for _, value in pairs(ItemsEnum) do
                if char == value then
                    isCollectable = true
                    break
                end
            end

            local isObstacle = char == '#'

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

-- Helpers
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
    if memoriesCollected >= self.totalMemories then
        self.exitHidden = false
        return true
    end

    return false
end

function Stage:collect(col, row)
    local cell = self:getCell(col, row)

    if cell and cell.collectable then
        cell.collectable = false
        return cell.char
    end

    return nil
end

-- Rendering
function Stage:draw()
    for row, rowCells in ipairs(self.cells) do
        for col, cell in ipairs(rowCells) do
            local px = (col - 1) * TILE_SIZE
            local py = (row - 1) * TILE_SIZE

            -- Walls
            if cell.obstacle then
                love.graphics.setColor(0.3, 0.3, 0.3)
                love.graphics.rectangle("fill", px, py, TILE_SIZE, TILE_SIZE)

            -- Portal
            elseif not self.exitHidden and cell.char == SpawnEnum.PortalSpawn then
                love.graphics.setColor(1, 0, 1)
                love.graphics.circle(
                    "fill",
                    px + TILE_SIZE / 2,
                    py + TILE_SIZE / 2,
                    TILE_SIZE / 3
                )

            -- Fragment Memories 
            elseif cell.collectable and cell.char == ItemsEnum.Fragment then
                love.graphics.setColor(1, 1, 0.4)
                love.graphics.circle("fill", px + TILE_SIZE / 2, py + TILE_SIZE / 2, TILE_SIZE / 3)

            -- Vision Buff Collectable
            elseif cell.collectable and cell.char == ItemsEnum.Vision then
                love.graphics.setColor(1, 0, 0)
                love.graphics.circle("fill", px + TILE_SIZE / 2, py + TILE_SIZE / 2, TILE_SIZE / 6)

            -- Speed Buff Collectable
            elseif cell.collectable and cell.char == ItemsEnum.Speed then
                love.graphics.setColor(0, 1, 0)
                love.graphics.circle("fill", px + TILE_SIZE / 2, py + TILE_SIZE / 2, TILE_SIZE / 6)

            -- Invincible Buff Collectable
            elseif cell.collectable and cell.char == ItemsEnum.Invincible then
                love.graphics.setColor(0, 0, 1)
                love.graphics.circle("fill", px + TILE_SIZE / 2, py + TILE_SIZE / 2, TILE_SIZE / 6)
            end

            love.graphics.setColor(1, 1, 1)
        end
    end
end

return Stage