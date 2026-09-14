function love.conf(t)
    t.identity = "pacman-clone"
    t.version = "11.5"
    t.console = false

    t.window.width = 1920
    t.window.height = 1080
    t.window.title = "PacMan"

    t.window.resizable = false
    t.window.borderless = false
    t.window.fullscreen = false
    t.window.vsync = 1

    -- t.modules.audio = true
end