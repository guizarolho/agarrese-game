function love.load()
    -- Import Libs
    Object = require "lib/classic"
    Timer = require "lib/timer"
    Binocles = require "lib/binocles"
    TEsound = require "lib/tesound"    

    -- Import Objects
    Player = require "objects/player"
    VisionRadius = require "objects/visionradius"
    Enemy = require "objects/enemy"
    Stage = require "objects/stage"
    CellData = require "objects/celldata"
    GameTimer = require "objects/gametimer"

    -- Import Scene
    SceneManager = require "scenes/scenemanager"
    Menu = require "scenes/menu"
    GameScene = require "scenes/gamescene"    
    
    -- Import Enums
    StageEnum = require "enum/stageenum"
    SceneEnum = require "enum/sceneenum"
        
    -- Global Variables
    TILE_SIZE = 32
    TIME_LIMIT = 60
    TIMER = Timer()
    FONT = love.graphics.newFont(18)
    GAME_OVER = false
    WINDOW_WIDTH = 1920
    WINDOW_HEIGHT = 1080

    -- Config SceneManager
    MENU = Menu()
    GAME = GameScene()

    SceneManager:new()
    SceneManager:addScene(SceneEnum.Menu, MENU)
    SceneManager:addScene(SceneEnum.Game, GAME)
    SceneManager:changeScene(SceneEnum.Menu)
end


function love.update(dt)
    TIMER:update(dt)
    SceneManager:update(dt)
end

function love.keypressed(key)
    SceneManager:keypressed(key)
end

function love.draw()
    SceneManager:draw()
end