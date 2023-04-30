require("bg")
require("buttonEnd")
require("body")
require("evil")
require("burn")
require("path")
require("math_utils")
require("sprites")

window_w = 1280
window_h = 960
speed = 100
people_count = 300
people_radius = 16
-- Screen offset
screen_offset_x = 0
screen_offset_y = 0

endButton_x = 1100
endtButton_y = -800
scaleButton_X = 150
scaleButton_Y = 125
startButton_R = 0

hero_speed = 400
hero_speed_lava = 200

isDown = love.keyboard.isDown

mainGame = {}


eButton  = {
    image  = buttonEnd.image,
    x      = endButton_x,
    y      = endButton_y,
    width  = scaleButton_X,
    height = scaleButton_Y,
}


function mainGame.load()
    bg:load()
    buttonEnd:load()
    evil:load()
    burn:load()
    love.physics.setMeter(32)

    shaman_sprites = load_sprites("shamanSheet_01.png")
    peon_sprites = load_sprites("peonPossessedSheet_01.png")
    game_over_image = love.graphics.newImage("shamanSheet_01.png")
    
end

function mainGame.restart(self)
    world = love.physics.newWorld(0, 0, true)
    evil:restart()
    local start_x = math.sqrt(2)*math.max(window_w, window_h)*0.5
    local start_y = bg.ground:getHeight()/2
    hero = body(start_x, start_y, "static", people_radius, "fill", shaman_sprites)
    hero.path = Path:new()
    hero.path:addPoint(start_x, start_y)

    people = {}
    for i=1,people_count do
        local x = math.random(0, bg.ground:getWidth())
        local y = math.random(0, bg.ground:getHeight())
        local p = body(x, y, "dynamic", people_radius, "line", peon_sprites)
        people[p] = true
    end
    game_over_time = nil
    game_over = false
end

function mainGame.testRestart(self)
    if game_over then
        self:restart()
    end
end

function mainGame.keypressed(self, key, scancode, isrepeat )
    self:testRestart()
end

function mainGame.draw()
    bg:draw(screen_offset_x, screen_offset_y)
    buttonEnd:draw(endButton_x,endButton_y,scaleButton_X,scaleButton_Y)
    hero:draw()
    if debug then hero.path:draw() end
    for p,k in pairs(people) do
        p:draw()
    end
    burn:draw()
    evil:draw(screen_offset_x, screen_offset_y)
    bg:draw_overlay(screen_offset_x, screen_offset_y)

    if not hero.alive then        
        local fade_time = 5
        local wait_time = 2
        local time = love.timer.getTime()
        if not game_over_time then
            game_over_time = time
        end
        if time > game_over_time+wait_time then
            game_over = true
            alpha = math.max(0, (time - wait_time - game_over_time) / fade_time)
            love.graphics.setColor(0,0,0,alpha)
            love.graphics.rectangle("fill", 0, 0, window_w, window_h)
            love.graphics.setColor(1,1,1,1)
            scale = math.max(window_w / game_over_image:getWidth(), window_h / game_over_image:getHeight())
            love.graphics.draw(game_over_image, 0, 0, 0, scale)
        end
    end
end

function mainGame.update(dt)
    world:update(dt)
    evil:update(dt)
    bg:update(dt)
    burn:update(dt)

    hero_x, hero_y = hero:getPosition()

    walk = false

    local hero_dir_x = 0
    local hero_dir_y = 0

    function move_hero(x, y)
        hero_dir_x = hero_dir_x+x
        hero_dir_y = hero_dir_y+y
        walk = true
    end

    if hero.alive then
        if isDown("right") then
            move_hero(1, 0)
        end
        if isDown("left") then
            move_hero(-1, 0)
        end
        if isDown("up") then
            move_hero(0, -1)
        end
        if isDown("down") then
            move_hero(0, 1)
        end
    end

    local speed = bg:isLava(hero_x, hero_y) and hero_speed_lava or hero_speed
    hero_dir_x, hero_dir_y = normalize(hero_dir_x, hero_dir_y)
    hero_dir_x, hero_dir_y = mul(hero_dir_x, hero_dir_y, speed*dt, speed*dt)

    -- Update the hero position
    local diameter = hero.shape:getRadius()*2
    hero_x = clamp(hero_x+hero_dir_x, 0, bg.ground:getWidth()-diameter)
    hero_y = clamp(hero_y+hero_dir_y, 0, bg.ground:getHeight()-diameter)
    hero_x = hero_x+hero_dir_x
    hero_y = hero_y+hero_dir_y
    hero:setPosition(hero_x, hero_y)
    if walk then
        hero:walk()
    end
    hero:setAngle(angleFromDir(hero_dir_x, hero_dir_y))

    -- Update the view position
    sx, sy = worldToScreen(hero_x, hero_y)
    screen_offset_x = screen_offset_x + sx - window_w/2
    screen_offset_y = screen_offset_y + sy - window_h/2

    function clampScreen(x, y)
        local wx, wy = screenToWorld(x, y)
        if wx < 0 then
            wx = 0
        end
        if wy < 0 then
            wy = 0
        end
        if wx > bg.ground:getWidth() then
            wx = bg.ground:getWidth()
        end
        if wy > bg.ground:getHeight() then
            wy = bg.ground:getHeight()
        end
        local sx, sy = worldToScreen(wx, wy)
        screen_offset_x = screen_offset_x + sx - x
        screen_offset_y = screen_offset_y + sy - y
    end
    clampScreen(0, 0)
    clampScreen(window_w, 0)
    clampScreen(window_w, window_h)
    clampScreen(0, window_h)

    hero:update(dt)
    local lpx, lpy = hero.path:lastPoint()
    if distance(hero_x, hero_y, lpx, lpy) > 100 then
        hero.path:addPoint(hero_x, hero_y)
    end

    for p,v in pairs(people) do
        p:walk()
        p:update(dt)
        -- x, y = p:getPosition()
        -- dx, dy = normalize(hero_x-x, hero_y-y)
        -- p:setAngle(angleFromDir(dx, dy))
        -- p:updateVelocity(k)
        p:followPath(hero.path)
        -- p:seek(hero_x, hero_y)
        p:updateAcceleration()
    end
end

