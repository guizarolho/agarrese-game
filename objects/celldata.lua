local CellData = Object:extend()

function CellData:new(isObstacle, isCollectable, utf8char)
    self.obstacle = isObstacle
    self.collectable = isCollectable
    self.char = utf8char
end

return CellData