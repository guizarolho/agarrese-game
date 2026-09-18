local CellData = Object:extend()

function CellData:new(isObstacle, isCollectable, utf8char)
    self.obstacle = isObstacle
    self.collectable = isCollectable
    self.char = utf8char
end

function CellData:setFloorTileIndex(tiles)
    self.floorVariationIndex = love.math.random(#tiles)
end

function CellData:setWallTileIndex(tiles)
    self.wallVariationIndex = love.math.random(#tiles)
end

return CellData