function love.load()
    Object = require "lib/classic"
    Timer = require "lib/timer"

    Player = require "objects/player"
    Enemy = require "objects/enemy"
    Stage = require "objects/stage"
    CellData = require "objects/celldata"
    GameTimer = require "objects/gametimer"

    TILE_SIZE = 32
    TIME_LIMIT = 60
    TIMER = Timer()
    FONT = love.graphics.newFont(18)
    GAME_OVER = false
    WINDOW_HEIGHT = 1920
    WINDOW_WIDTH = 1080

    Stage:new()
    Player:new()
    GameTimer:new(TIME_LIMIT)
    -- Enemy:new()
end

function love.update(dt)
    TIMER:update(dt)

    if not GAME_OVER then
        Player:update(dt)
    end
end

function love.draw()
    Stage:draw()
    Player:draw()
    GameTimer:draw()
    -- Enemy:draw()
end