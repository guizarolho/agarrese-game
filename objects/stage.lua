local Stage = Object:extend()

function Stage:new(stageIndex, world)
    self.grid = StageEnum[stageIndex]
    self.world = world

    self.totalMemories = 0
    self.cells = {}
    self.obstacles = {}

    self.playerSpawn = nil
    self.portalSpawn = nil
    self.enemySpawns = {}
    self.exitHidden = true

    -- Stage Sprites

    self.floorTiles = {}
    for index, path in ipairs(FloorEnum[stageIndex]) do
        self.floorTiles[index] = love.graphics.newImage(path)
    end

    self.wallTiles = {}
    for index, path in ipairs(WallEnum[stageIndex]) do
        self.wallTiles[index] = love.graphics.newImage(path)
    end

    self:buildGrid()
    self:buildPathNodes()

    --------------------------------------------------------------------
    -- TILE_ANIMATION
    --------------------------------------------------------------------
    
    -- Portal
    self.portalImage = love.graphics.newImage("sprites/portal.png")
    local portalGrid = Anim8.newGrid(
        _G.TILE_SIZE,
        _G.TILE_SIZE,
        self.portalImage:getWidth(),
        self.portalImage:getHeight()
    )
    self.portalAnimation = Anim8.newAnimation(
        portalGrid("1-21", 1),
        0.08
    )

    -- Fragment
    self.fragmentImage = love.graphics.newImage("sprites/fragment.png")
    local fragmentGrid = Anim8.newGrid(
        _G.TILE_SIZE,
        _G.TILE_SIZE,
        self.fragmentImage:getWidth(),
        self.fragmentImage:getHeight()
    )
    self.fragmentAnimation = Anim8.newAnimation(
        fragmentGrid("1-11", 1),
        0.08
    )

    -- Item Sprites
    self.speedImage = love.graphics.newImage("sprites/pill.png")
    self.visionImage = love.graphics.newImage("sprites/glasses.png")
    self.invincibleImage = love.graphics.newImage("sprites/ghost.png")
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
            self.cells[rowIndex][colIndex]:setTileIndex()

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

function Stage:update(dt)
    if not self.exitHidden then
        self.portalAnimation:update(dt)
    end

    self.fragmentAnimation:update(dt)
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

            -- Floor Tile
            love.graphics.draw(
                self.floorTiles[self.cells[row][col].tileVariationIndex],
                px,
                py
            )

            -- Walls
            if cell.obstacle then
                love.graphics.draw(
                    self.wallTiles[self.cells[row][col].tileVariationIndex],
                    px,
                    py
                )

            -- Portal
            elseif not self.exitHidden and cell.char == SpawnEnum.PortalSpawn then
                self.portalAnimation:draw(
                    self.portalImage,
                    px,
                    py
                )
            -- Fragment Memories 
            elseif cell.collectable and cell.char == ItemsEnum.Fragment then
                self.fragmentAnimation:draw(
                    self.fragmentImage,
                    px,
                    py
                )

            -- Vision Buff Collectable
            elseif cell.collectable and cell.char == ItemsEnum.Vision then
                love.graphics.draw(
                    self.visionImage,
                    px,
                    py
                )

            -- Speed Buff Collectable
            elseif cell.collectable and cell.char == ItemsEnum.Speed then
                love.graphics.draw(
                    self.speedImage,
                    px,
                    py
                )

            -- Invincible Buff Collectable
            elseif cell.collectable and cell.char == ItemsEnum.Invincible then
                love.graphics.draw(
                    self.invincibleImage,
                    px,
                    py
                )
            end
            love.graphics.setColor(1, 1, 1)
        end
    end
end

return Stage