function love.load()
    Object = require "lib/classic"
    Timer = require "lib/timer"

    Player = require "objects/player"
    Enemy = require "objects/enemy"
    Stage = require "objects/stage"
    CellData = require "objects/celldata"
    GameTimer = require "objects/gametimer"

    WINDOW_HEIGHT = 1920
    WINDOW_WIDTH = 1080
    TILE_SIZE = 32
    FONT = love.graphics.newFont(18)
    GAME_OVER = false
    TIME_LIMIT = 60
    TIMER = Timer()

    Stage:new()
    Player:new()
    -- Enemy:new()
    GameTimer:new(TIME_LIMIT)
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