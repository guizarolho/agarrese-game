function love.conf(t)
    WINDOW_WIDTH = 1920
    WINDOW_HEIGHT = 1080

    t.identity = "pacman-clone"
    t.version = "11.5"
    t.console = false

    t.window.width = WINDOW_WIDTH
    t.window.height = WINDOW_HEIGHT
    t.window.title = "PacMan"

    t.window.resizable = false
    t.window.borderless = false
    t.window.fullscreen = false
    t.window.vsync = 1

    -- t.modules.audio = true
end