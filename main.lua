function love.load()
    -- Import Libs
    Object = require "lib/classic"
    Timer = require "lib/timer"
    Binocles = require "lib/binocles"
    Bump = require "lib/bump"
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
    Credits = require "scenes/credits"

    -- Import Enums
    StageEnum = require "enum/stageenum"
    SceneEnum = require "enum/sceneenum"
    ItemsEnum = require "enum/itemsenum"

    -- Global Variables
    TILE_SIZE = 32
    TIME_LIMIT = 999
    TIMER = Timer()
    FONT = love.graphics.newFont(18)
    GAME_OVER = false
    PLAYER_SPEED = 200
    WINDOW_WIDTH = 1920
    WINDOW_HEIGHT = 1080
    WORLD = Bump.newWorld(TILE_SIZE)

    -- Items
    VISION_BUFF_FACTOR = 50
    VISION_BUFF_TIMER = 5

    SPEED_BUFF_FACTOR = 300
    SPEED_BUFF_TIMER = 5

    INVENCIBLE_BUFF_TIMER = 5

    -- Config SceneManager
    MENU = Menu()
    GAME = GameScene()
    CREDITS = Credits()

    SceneManager:new()
    SceneManager:addScene(SceneEnum.Menu, MENU)
    SceneManager:addScene(SceneEnum.Game, GAME)
    SceneManager:addScene(SceneEnum.Credits, CREDITS)
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