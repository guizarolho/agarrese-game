-- https://www.youtube.com/watch?v=wC9iu7cuQjI

Enemy = Object:extend()
local astar = require("astar")

function Enemy:new(player, stage, index)
    local spawn = stage.enemySpawns[index]
    self.x = (spawn.col - 1) * _G.TILE_SIZE
    self.y = (spawn.row - 1) * _G.TILE_SIZE

    self.player = player
    self.stage = stage
    self.speed = 90
    self.detectionRadius = 180
    self.attackRange = 25
    self.state = "idle"
    self.path = nil
    self.pathIndex = 1

    self.pathUpdateTimer = 0
    self.pathUpdateInterval = 0.35

    self.image = love.graphics.newImage("sprites/enemy.png")
    self.spriteSize = _G.TILE_SIZE
    self.size = _G.TILE_SIZE - 3
end

function Enemy:setSpawn(spawn)
    self.x = (spawn.col - 1) * _G.TILE_SIZE
    self.y = (spawn.row - 1) * _G.TILE_SIZE
end

-- https://love2d.org/wiki/World:rayCast
function Enemy:hasLineOfSight()
    local startX = self.x + TILE_SIZE / 2
    local startY = self.y + TILE_SIZE / 2
    local endX = self.player.x + TILE_SIZE / 2
    local endY = self.player.y + TILE_SIZE / 2

    local items, len = self.stage.world:querySegment(startX, startY, endX, endY)
    for i = 1, len do
        for _, obstacle in ipairs(self.stage.obstacles) do
            if items[i] == obstacle then
                return false
            end
        end
    end

    return true
end

-- A*
function Enemy:updatePath()
    local startCol = math.floor((self.x + TILE_SIZE / 2) / TILE_SIZE) + 1
    local startRow = math.floor((self.y + TILE_SIZE / 2) / TILE_SIZE) + 1
    local targetCol = math.floor((self.player.x + TILE_SIZE / 2) / TILE_SIZE) + 1
    local targetRow = math.floor((self.player.y + TILE_SIZE / 2) / TILE_SIZE) + 1

    local startNode = self.stage.nodeAt[startRow] and self.stage.nodeAt[startRow][startCol]
    local targetNode = self.stage.nodeAt[targetRow] and self.stage.nodeAt[targetRow][targetCol]

    if startNode and targetNode then
        local validNeighborFunc = function(nodeA, nodeB)
            local dist = math.abs(nodeA.x - nodeB.x) + math.abs(nodeA.y - nodeB.y)
            return dist == 1
        end

        self.path = astar.path(startNode, targetNode, self.stage.pathNodes, true, validNeighborFunc)
        self.pathIndex = 1
    end
end

function Enemy:update(dt)
    local startX = self.x + TILE_SIZE / 2
    local startY = self.y + TILE_SIZE / 2
    local playerX = self.player.x + TILE_SIZE / 2
    local playerY = self.player.y + TILE_SIZE / 2

    local distToPlayer = astar.distance(startX, startY, playerX, playerY)
    local canSeePlayer = self:hasLineOfSight()

    if self.state == "idle" then
        if distToPlayer <= self.detectionRadius and canSeePlayer then
            self.state = "pursuit"
        end

    elseif self.state == "pursuit" then
        if distToPlayer > self.detectionRadius * 1.4 then
            self.state = "idle"
            self.path = nil
        elseif distToPlayer <= self.attackRange and canSeePlayer then
            self.state = "attack"
        else
            self.pathUpdateTimer = self.pathUpdateTimer + dt
            if self.pathUpdateTimer >= self.pathUpdateInterval then
                self.pathUpdateTimer = 0
                self:updatePath()
            end

            self:followPath(dt)
        end

    elseif self.state == "attack" then
        if distToPlayer > self.attackRange or not canSeePlayer then
            self.state = "pursuit"
        else
            self.player:onHit()
        end
    end
end

function Enemy:followPath(dt)
    if not self.path or #self.path == 0 or self.pathIndex > #self.path then return end

    local targetNode = self.path[self.pathIndex]
    local targetX = (targetNode.x - 1) * TILE_SIZE
    local targetY = (targetNode.y - 1) * TILE_SIZE

    local dx = targetX - self.x
    local dy = targetY - self.y
    local dist = math.sqrt(dx * dx + dy * dy)

    if dist < 3 then
        self.pathIndex = self.pathIndex + 1
    else
        self.x = self.x + (dx / dist) * self.speed * dt
        self.y = self.y + (dy / dist) * self.speed * dt
    end
end


function Enemy:draw()
    if self.state == "idle" then
        love.graphics.setColor(0.2, 0.8, 0.2)
    elseif self.state == "pursuit" then
        love.graphics.setColor(1, 0.5, 0)
    elseif self.state == "attack" then
        love.graphics.setColor(1, 0, 0)
    end

    love.graphics.rectangle(
        "fill",
        self.x,
        self.y,
        self.spriteSize,
        self.spriteSize
    )

    if self.state ~= "idle" then
        love.graphics.setColor(1, 1, 0, 0.2)
        love.graphics.line(
            self.x + TILE_SIZE / 2,
            self.y + TILE_SIZE / 2,
            self.player.x + TILE_SIZE / 2,
            self.player.y + TILE_SIZE / 2
        )
    end

    local scaleX = self.spriteSize / self.image:getWidth()
    local scaleY = self.spriteSize / self.image:getHeight()

    love.graphics.draw(
        self.image,
        self.x - (self.spriteSize - self.size) / 2,
        self.y - (self.spriteSize - self.size) / 2,
        0,
        scaleX,
        scaleY
    )

    love.graphics.setColor(1, 1, 1)
end

return Enemy