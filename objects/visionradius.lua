-- https://love2d.org/wiki/love.graphics.setStencil
VisionRadius = Object:extend()

function VisionRadius:new()
    self.radius = 300
end

function VisionRadius:alter(factor)
    self.radius = factor
end

function VisionRadius:update(x, y)
    self.x = x
    self.y = y
end

function VisionRadius:draw()
    love.graphics.stencil(
        function()
            love.graphics.circle(
                "fill",
                self.x,
                self.y,
                self.radius
            )
        end,
        "replace",
        1
    )

    love.graphics.setStencilTest("notequal", 1)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle(
        "fill",
        0,
        0,
        _G.WINDOW_WIDTH,
        _G.WINDOW_HEIGHT
    )
    love.graphics.setStencilTest()
end

return VisionRadius