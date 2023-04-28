window_w = 1280
window_h = 960
speed = 100
people_count = 300
people_radius = 16

function rect(x, y, w, h)
    return {x=x, y=y, w=w, h=h}
end

function normalize(x, y)
    l = math.sqrt(x*x+y*y)
    return x/l, y/l
end

isDown = love.keyboard.isDown

hero = {}
people = {}

function love.load()
    love.window.setMode(window_w, window_h)
    love.physics.setMeter(32)
    world = love.physics.newWorld(0, 0, true)
    hero.body = love.physics.newBody(world, 20, 20, "static")
    hero.shape = love.physics.newCircleShape(people_radius)
    hero.fixture = love.physics.newFixture(hero.body, hero.shape, 1)
    hero_x, hero_y = hero.body:getPosition()
    for i=1,people_count do
        p = {}
        x = math.random(0, window_w)
        y = math.random(0, window_h)
        p.body = love.physics.newBody(world, x, y, "dynamic")
        p.shape = love.physics.newCircleShape(people_radius)
        p.fixture = love.physics.newFixture(p.body, p.shape, 1)

        table.insert(people, p)
    end
end

function love.draw()
    x, y = hero.body:getPosition()
    love.graphics.print("Hello World", 400, 300)
    love.graphics.rectangle("fill", x, y, people_radius*2, people_radius*2)
    for k,p in pairs(people) do
        x, y = p.body:getPosition()
        love.graphics.rectangle("line", x, y, people_radius*2, people_radius*2)
    end
end

function love.update(dt)
    world:update(dt)

    hero_x, hero_y = hero.body:getPosition()

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

    hero.body:setPosition(hero_x, hero_y)

    for k,p in pairs(people) do
        x, y = p.body:getPosition()
        dx, dy = normalize(hero_x-x, hero_y-y)
        p.body:setLinearVelocity(dx*dt*10000, dy*dt*10000)
    end
end

