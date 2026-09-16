Enemy = Object:extend()

function Enemy:new()
end

function Enemy:update(dt)

    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end

    local distance = self:getDistanceToPlayer()

    if distance <= self.detectionRadius then
        self.state = "chase"
    else
        self.state = "patrol"
    end

    if self.state == "patrol" then
        self:patrol(dt)

    elseif self.state == "chase" then
        self:chase(dt)
    end
end

function Enemy:draw()
end

return Enemy