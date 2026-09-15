local CellData = Object:extend()

function CellData:new(isObstacle, isCollectable)
    self.obstacle = isObstacle
    self.collectable = isCollectable
end

return CellData