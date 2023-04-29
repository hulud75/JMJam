require("mainMenu_bg")
require("buttonStart")
require("mainGame")

local sButton  = {image  = image,
x      = startButton_x,
y      = startButton_y,
width  = scaleButton_X,
height = scaleButton_Y,
}

debug = true
window_w = 1280
window_h = 960
speed = 100
people_count = 300
people_radius = 16
-- world coordinate of the upper left corner
world_x = 0
world_y = 0

newW = 1280
newH = 960

startButton_x = 1100
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

hero = {}
people = {}

function love.load()
    mainMenu_bg:load()
    mainGame:load()
    buttonStart:load()
    love.window.setMode(window_w, window_h)
end
    
function love.draw()
    mainMenu_bg:draw(world_x, world_y)
    buttonStart:draw(startButton_x,startButton_y,scaleButton_X,scaleButton_Y)
end
