require("bg")
require("buttonStart")
require("body")
require("evil")


local sButton  = {image  = image,
x      = startButton_x,
y      = startButton_y,
width  = scaleButton_X,
height = scaleButton_Y,
}

window_w = 1280
window_h = 960
speed = 100
people_count = 300
people_radius = 16
-- world coordinate of the upper left corner
world_x = 0
world_y = 0

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
    bg:load()
    buttonStart:load()
    evil:load()
    love.window.setMode(window_w, window_h)
    love.physics.setMeter(32)
    world = love.physics.newWorld(0, 0, true)
    
    local start_x = window_w/2
    local start_y = bg.ground:getHeight()/2
    hero = body(start_x, start_y, "static", people_radius, "fill")

    for i=1,people_count do
        local x = math.random(0, bg.ground:getWidth())
        local y = math.random(0, bg.ground:getHeight())
        local p = body(x, y, "dynamic", people_radius, "line")
        table.insert(people, p)
    end
end

function love.draw()
    bg:draw(world_x, world_y)
    buttonStart:draw(startButton_x,startButton_y,scaleButton_X,scaleButton_Y)
    hero:draw()
    for k,p in pairs(people) do
        p:draw()
    end
    evil:draw(world_x, world_y)
end
