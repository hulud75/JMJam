require("mainMenu_bg")
require("buttonStart")
require("mainGame")
require("pressEnterText")
require("menuGameText")

release = true
debug = false and not release
full_screen = false or release
page = release and "menu" or "mainGame"
window_w = 1920
window_h = 1080

speed = 100
people_count = 300
people_radius = 16
-- world coordinate of the upper left corner
screen_offset_x = 0
screen_offset_y = 0

mainMenu_newWidth = 1920
mainMenu_newHeight = 1080

startButton_x = 50
startButton_y = 800
scaleButton_X = 150
scaleButton_Y = 125
startButton_R = 0

pressEnterText_x = 500
pressEnterText_y = 300
pressEnterText_sx = 1000
pressEnterText_sy = 1080

menuGameText_x = 300
menuGameText_y = 50
menuGameText_sx = 1000
menuGameText_sy = 1000


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
    pressEnterText.load()
    menuGameText.load()
    mainGame:restart()
end

function love.mousepressed(mx, my, startButton)
    if startButton == 1 and mx >= sButton.x and mx < sButton.x+sButton.width and my >= sButton.y and my < sButton.y+sButton.height then
        page = "mainGame"
    end
end

function love.keypressed(key)
    if page == "menu" then
        if key == "return" then
            page = "mainGame"
        end
    else
        mainGame:keypressed(key, scancode, isrepeat)
    end
end

function love.draw()
    if page == "menu" then
        mainMenu_bg:draw(screen_offset_x, screen_offset_y, mainMenu_newWidth,mainMenu_newHeight)
        menuGameText:draw(world_x, world_y,menuGameText_sx,menuGameText_sy)
        pressEnterText:draw(pressEnterText_x,pressEnterText_y,pressEnterText_sx,pressEnterText_sy)
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
