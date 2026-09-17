local CellData = Object:extend()

function CellData:new(isObstacle, isCollectable, utf8char)
    self.obstacle = isObstacle
    self.collectable = isCollectable
    self.char = utf8char
end

function CellData:setTileIndex()
    self.tileVariationIndex = love.math.random(1, 2)
end

return CellData