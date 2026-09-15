local function isWall(col, row)
    local rowStr = Stage.grid[row]
    if not rowStr then return true end
    local char = rowStr:sub(col, col)
    if char == '' then return true end
    return char == '#'
end

local function collides(x, y, size)
    local left   = math.floor(x / _G.TILE_SIZE) + 1
    local right  = math.floor((x + size - 1) / _G.TILE_SIZE) + 1
    local top    = math.floor(y / _G.TILE_SIZE) + 1
    local bottom = math.floor((y + size - 1) / _G.TILE_SIZE) + 1

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

Player = Object:extend()

function Player:new()
    self.x = 32
    self.y = 32
    self.speed = 200
    self.size = 30
    self.dir = { x = 0, y = 0 }
end

function Player:update(dt)
    local dx, dy = 0, 0
    if love.keyboard.isDown("w") then dy = -1 end
    if love.keyboard.isDown("a") then dx = -1 end
    if love.keyboard.isDown("s") then dy = 1 end
    if love.keyboard.isDown("d") then dx = 1 end
    move(dx, dy, dt)
end

function Player:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", Player.x, Player.y, Player.size, Player.size)
end

return Player