require("mainMenu_bg")
require("buttonStart")
require("mainGame")

release = true
debug = false and not release
full_screen = false or release
page = "game" or (release and "menu")
window_w = 1280
window_h = 960
speed = 100
people_count = 300
people_radius = 16
-- world coordinate of the upper left corner
screen_offset_x = 0
screen_offset_y = 0

mainMenu_newWidth = 1280
mainMenu_newHeight = 960

startButton_x = 100
startButton_y = 800

scaleButton_X = 150
scaleButton_Y = 125
startButton_R = 0


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
    buttonStart:load()
    if full_screen then
        love.window.setFullscreen(true)
        window_w, window_h = love.graphics.getDimensions()
    else
        love.window.setMode(window_w, window_h)
    end
end

function love.mousepressed(mx, my, startButton)
    if startButton == 1 and mx >= sButton.x and mx < sButton.x+sButton.width and my >= sButton.y and my < sButton.y+sButton.height then
        page = "mainGame"
    end
end
    
function love.draw()
    if page == "menu" then
        mainMenu_bg:draw(screen_offset_x, screen_offset_y, mainMenu_newWidth,mainMenu_newHeight)
        buttonStart:draw(startButton_x,startButton_y,scaleButton_X,scaleButton_Y)
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




