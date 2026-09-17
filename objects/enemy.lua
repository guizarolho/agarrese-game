Enemy = Object:extend()

function Enemy:new(player, stage, index)
    local spawn = stage.enemySpawns[index]

    self.player = player
    self.stage = stage

    self.x = (spawn.col - 1) * TILE_SIZE + TILE_SIZE / 2
    self.y = (spawn.row - 1) * TILE_SIZE + TILE_SIZE / 2
    self.spriteSize = _G.TILE_SIZE

    self.speed = 80
    self.detectionRadius = 150
    self.chaseTolerance = 80
    
end

function Enemy:update(dt)
end

function Enemy:patrol(dt)
end

function Enemy:chase(dt)
end

function Enemy:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle( 
        "fill", 
        self.x + TILE_SIZE / 2,
        self.y + TILE_SIZE / 2,
        self.spriteSize, 
        self.spriteSize 
    )
end

return Enemy