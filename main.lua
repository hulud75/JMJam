require("bg")
require("buttonStart")
require("body")
require("evil")
require("burn")
require("path")
require("math_utils")

debug = true
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

function angleFromDir(x, y)
    return math.pi*2 + math.atan2(y, x)
end

function love.load()
    bg:load()
    buttonStart:load()
    evil:load()
    burn:load()
    load_body()
    love.window.setMode(window_w, window_h)
    love.physics.setMeter(32)
    world = love.physics.newWorld(0, 0, true)
    
    local start_x = window_w/2
    local start_y = bg.ground:getHeight()/2
    hero = body(start_x, start_y, "static", people_radius, "fill")
    hero.path = Path:new()
    hero.path:addPoint(start_x, start_y)

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
    if debug then hero.path:draw() end
    for k,p in pairs(people) do
        p:draw()
    end
    burn:draw()
    evil:draw(world_x, world_y)
end

function love.update(dt)
    world:update(dt)
    evil:update(dt)
    bg:update(dt)
    burn:update(dt)

    hero_x, hero_y = hero:getPosition()

    walk = false

    local hero_dir_x = 0
    local hero_dir_y = 0

    function move_hero(x, y, angle)
        hero_dir_x = hero_dir_x+x
        hero_dir_y = hero_dir_y+y
        walk = true
    end

    local hero_speed = 400*dt
    if isDown("right") then
        move_hero(hero_speed, 0, 0)
    end
    if isDown("left") then
        move_hero(-hero_speed, 0, math.pi)
    end
    if isDown("up") then
        move_hero(0, -hero_speed, math.pi*3/2)
    end
    if isDown("down") then
        move_hero(0, hero_speed, math.pi/2)
    end

    -- Update the hero position
    local diameter = hero.shape:getRadius()*2
    hero_x = clamp(hero_x+hero_dir_x, 0, bg.ground:getWidth()-diameter)
    hero_y = clamp(hero_y+hero_dir_y, 0, bg.ground:getHeight()-diameter)
    hero:setPosition(hero_x, hero_y)
    if walk then
        hero:walk()
    end
    hero:setAngle(angleFromDir(hero_dir_x, hero_dir_y))

    -- Update the view position
    world_x = clamp(hero_x - window_w/2, 0, bg.ground:getWidth()-window_w)
    world_y = clamp(hero_y - window_h/2, 0, bg.ground:getHeight()-window_h)

    hero:update(dt)
    local lpx, lpy = hero.path:getLastPoint()
    if distance(hero_x, hero_y, lpx, lpy) > 100 then
        print("putting down a point")
        hero.path:addPoint(hero_x, hero_y)
    end

    for k,p in pairs(people) do
        p:walk()
        p:update(dt)
        x, y = p:getPosition()
        dx, dy = normalize(hero_x-x, hero_y-y)
        p:setAngle(angleFromDir(dx, dy))
        p:updateVelocity(k)
    end
end

