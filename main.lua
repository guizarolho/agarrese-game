function love.load()
    -- Import Libs
    Object = require "lib/classic"
    Timer = require "lib/timer"
    Binocles = require "lib/binocles"
    Bump = require "lib/bump"
    TEsound = require "lib/tesound"
    Astar = require "lib/a-star"
    Anim8 = require "lib/anim8"

    -- Import Objects
    Player = require "objects/player"
    VisionRadius = require "objects/visionradius"
    Enemy = require "objects/enemy"
    Stage = require "objects/stage"
    CellData = require "objects/celldata"
    GameTimer = require "objects/gametimer"
    Life = require "objects/life"
    Message = require "objects/message"

    -- Import Scene
    SceneManager = require "scenes/scenemanager"
    Menu = require "scenes/menu"
    GameScene = require "scenes/gamescene"    
    Credits = require "scenes/credits"

    -- Import Enums
    StageEnum = require "enum/stageenum"
    SceneEnum = require "enum/sceneenum"
    ItemsEnum = require "enum/itemsenum"
    SpawnEnum = require "enum/spawnenum"
    WallEnum = require "enum/wallenum"
    FloorEnum = require "enum/floorenum"

    -- Global Variables
    TILE_SIZE = 32
    TIME_LIMIT = 999
    TIMER = Timer()
    GAME_TIMER = Timer()
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
    INVINCIBLE_BUFF_TIMER = 5
    GAME_TIMER_BUFF = 20

       -- Músicas
    MUSIC = {
        menu = love.audio.newSource("sfx/musicamenucreditos.ogg", "stream"),
        credits = love.audio.newSource("sfx/musicamenucreditos.ogg", "stream"),
        fase1 = love.audio.newSource("sfx/musicafase1.mp3", "stream"),
        fase2 = love.audio.newSource("sfx/musicafase2mp3.mp3", "stream"),
        fase3 = love.audio.newSource("sfx/musicafase3.mp3", "stream"),
        fase4 = love.audio.newSource("sfx/musicafase4.mp3", "stream"),
        dano = love.audio.newSource("sfx/musicadano.mp3", "static"),
        fragmentos = love.audio.newSource("sfx/musicafragmentos.MP3", "static"),
    }
    
love.audio.setVolume(0.1) -- volume master normal

MUSIC.menu:setVolume(0.5)
MUSIC.credits:setVolume(0.5)
MUSIC.fase1:setVolume(0.5)
MUSIC.fase2:setVolume(0.5)
MUSIC.fase3:setVolume(0.5)
MUSIC.fase4:setVolume(0.5)
MUSIC.dano:setVolume(1.0)
MUSIC.fragmentos:setVolume(1.0)


for key, source in pairs(MUSIC) do
    if key ~= "dano" and key ~= "fragmentos" then
        source:setLooping(true)
    end
end

    CURRENT_MUSIC = nil

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

    if not GAME.paused then
        GAME_TIMER:update(dt)
    end

    SceneManager:update(dt)
end

function love.keypressed(key)
    SceneManager:keypressed(key)
end

function love.draw()
    SceneManager:draw()
end

function playSound(soundKey)
    local sound = MUSIC[soundKey]
    if not sound then return end

    -- clona a fonte pra permitir sobreposição (ex: vários hits seguidos)
    local instance = sound:clone()
    instance:play()
end

-- Função global de troca de música
function playMusic(musicKey)
    local newTrack = MUSIC[musicKey]
    if not newTrack then
        return
    end

    if newTrack == CURRENT_MUSIC then
        return
    end

    if CURRENT_MUSIC then
        CURRENT_MUSIC:stop()
    end

    CURRENT_MUSIC = newTrack
    CURRENT_MUSIC:play()

end