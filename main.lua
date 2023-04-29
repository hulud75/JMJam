require("bg")
require("body")
require("evil")

window_w = 1280
window_h = 960
speed = 100
people_count = 300
people_radius = 16
-- world coordinate of the upper left corner
world_x = 0
world_y = 0

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
    hero:draw()
    for k,p in pairs(people) do
        p:draw()
    end
    evil:draw(world_x, world_y)
end

function love.update(dt)
    world:update(dt)
    evil:update(dt)
    bg:update(dt)

    hero_x, hero_y = hero:getPosition()

    function move_hero(x, y)
        hero_x = hero_x+x
        hero_y = hero_y+y
    end

    hero_speed = 400*dt
    if isDown("right") then
        move_hero(hero_speed, 0)
    end
    if isDown("left") then
        move_hero(-hero_speed, 0)
    end
    if isDown("up") then
        move_hero(0, -hero_speed)
    end
    if isDown("down") then
        move_hero(0, hero_speed)
    end

    -- Update the hero position
    local diameter = hero.shape:getRadius()*2
    hero_x = clamp(hero_x, 0, bg.ground:getWidth()-diameter)
    hero_y = clamp(hero_y, 0, bg.ground:getHeight()-diameter)
    hero:setPosition(hero_x, hero_y)

    -- Update the view position
    world_x = clamp(hero_x - window_w/2, 0, bg.ground:getWidth()-window_w)
    world_y = clamp(hero_y - window_h/2, 0, bg.ground:getHeight()-window_h)

    hero:update(dt)

    for k,p in pairs(people) do
        p:update(dt)
        x, y = p:getPosition()
        dx, dy = normalize(hero_x-x, hero_y-y)
        p.body:setLinearVelocity(dx*dt*10000, dy*dt*10000)
    end
end

