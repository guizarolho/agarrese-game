CellData = Object:extend()

function CellData:new(isObstacle, isCollectable)
    self.passable = isObstacle
    self.collectable = isCollectable
end

return CellData