require("mainMenu_bg")
require("buttonStart")
require("mainGame")


debug = true
page = "menu"
window_w = 1280
window_h = 960
speed = 100
people_count = 300
people_radius = 16
-- world coordinate of the upper left corner
world_x = 0
world_y = 0

mainMenu_newWidth = 1280
mainMenu_newHeight = 960

startButton_x = 100
startButton_y = 800

scaleButton_X = 150
scaleButton_Y = 125
startButton_R = 0


function rect(x, y, w, h)
    return {x=x, y=y, w=w, h=h}
end

function normalize(x, y)
    l = math.sqrt(x*x+y*y)
    return x/l, y/l
end

function world_to_screen(x, y)
    return x-world_x, y-world_y
end

function clamp(x, min, max)
    return math.max(math.min(x, max), min)
end

isDown = love.keyboard.isDown
loadVal = 0
sButton  = {
    image  = buttonStart.image,
    x      = startButton_x,
    y      = startButton_y,
    width  = scaleButton_X,
    height = scaleButton_Y,
}

function love.load()
    mainMenu_bg:load()
    mainGame:load()
    buttonStart:load()
    love.window.setMode(window_w, window_h)
end

function love.mousepressed(mx, my, startButton)
    if startButton == 1 and mx >= sButton.x and mx < sButton.x+sButton.width and my >= sButton.y and my < sButton.y+sButton.height then
        print("Pressed button!")
        page = "mainGame"
    end
end
    
function love.draw()
    if page == "menu" then
        mainMenu_bg:draw(world_x, world_y, mainMenu_newWidth,mainMenu_newHeight)
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




