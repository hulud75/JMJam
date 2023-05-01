math.randomseed(os.time())

require("mainMenu_bg")
require("buttonStart")
require("mainGame")

release = true
debug = false and not release
full_screen = false or release
page = release and "menu" or "mainGame"
window_w = 1920
window_h = 1080

speed = 100
people_radius = 16
-- world coordinate of the upper left corner
screen_offset_x = 0
screen_offset_y = 0

mainMenu_newWidth = 1920
mainMenu_newHeight = 1080

isDown = love.keyboard.isDown
loadVal = 0
sButton  = {
    image  = buttonStart.image,
    x      = startButton_x,
    y      = startButton_y,
    width  = scaleButton_X,
    height = scaleButton_Y,
}
people = {}

function love.load()
    mainMenu_bg:load()
    mainGame:load()
    if full_screen then
        love.window.setFullscreen(true)
        window_w, window_h = love.graphics.getDimensions()
    else
        love.window.setMode(window_w, window_h)
    end
    world = love.physics.newWorld(0, 0, true)
end

function love.keypressed(key)
    if page == "menu" then
        if key == "return" then
            page = "mainGame"
            mainGame:restart()
        end
    else
        mainGame:keypressed(key, scancode, isrepeat)
    end
end

function love.draw()
    if page == "menu" then
        mainMenu_bg:draw(screen_offset_x, screen_offset_y, mainMenu_newWidth,mainMenu_newHeight)
    else
        mainGame:draw()
    end
end

function love.update(dt)
    if page == "menu" then
        mainMenu_bg:update(dt)
    else
        mainGame.update(dt)
    end
end
