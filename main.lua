function love.load()
    Object = require "sti/classic"
    Player = require "objects/player"
    Stage = require "objects/stage"

    Stage:new()
    Player:new()

    WINDOW_HEIGHT = 1920
    WINDOW_WIDTH = 1080
    TILE_SIZE = 32
    FONT = love.graphics.newFont(18)
end

function love.update(dt)
    Player:update(dt)
end

function love.draw()
    Player:draw()
    Stage:draw()
end