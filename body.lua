local function normalize(x, y)
    local l = math.sqrt(x*x+y*y)
    return x/l, y/l
end

function load_body()
    sprite_animation_steps = 8
    sprite_dir_steps = 8
    body_sprites_imageData = love.image.newImageData("sprites.png")
    local remap_dir = {0, 5, 4, 6, 7, 3, 1, 2}
    body_sprites_image = love.graphics.newImage(body_sprites_imageData)
    body_sprite_w = body_sprites_imageData:getWidth() / sprite_animation_steps
    body_sprite_h = body_sprites_imageData:getHeight() / sprite_dir_steps
    body_sprites_quads = {}
    for step = 0,sprite_animation_steps-1 do
        local dirs = {}
        table.insert(body_sprites_quads, dirs)
        for dir = 1,sprite_dir_steps do
            dirs[dir] = love.graphics.newQuad(step*body_sprite_h, remap_dir[dir]*body_sprite_h, body_sprite_h, body_sprite_h, body_sprites_image)
        end
    end
end

function body(x, y, physic_mode, radius, render_mode)
    local result = { render_mode = render_mode, alive = true, animation = math.random(0, sprite_animation_steps), angle = 0 }
    result.body = love.physics.newBody(world, x, y, physic_mode)
    result.shape = love.physics.newCircleShape(radius)
    result.fixture = love.physics.newFixture(result.body, result.shape, 1)

    function result.draw(self)
        local x, y = self.body:getPosition()
        local radius = self.shape:getRadius()
        if self.alive then
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.setColor(1, 0, 0)
        end

        local anim_frame = math.floor(math.mod(self.animation, sprite_animation_steps))+1
        local dir = math.floor(math.mod(self.angle * sprite_dir_steps / (2.0*math.pi) + 0.5, sprite_dir_steps))+1
        love.graphics.draw(body_sprites_image, body_sprites_quads[anim_frame][dir], (x-world_x + radius) - body_sprite_w/2, (y-world_y + radius) - body_sprite_h/2)

        love.graphics.setColor(1, 1, 1)
    end

    function result.getPosition(self)
        return self.body:getPosition()
    end

    function result.setPosition(self, x, y)
        return self.body:setPosition(x, y)
    end

    function result.die(self)
        if self.alive then
            self.alive = false
            x, y = self.body:getPosition()
            burn:create(x, y)
        end
    end

    function result.walk(self)
        self.animation = self.animation+0.25
    end

    function result.setAngle(self, angle)
        self.angle = angle
    end

    function result.update(self, dt)
        x, y = self:getPosition()
        if evil:die(x, y) or bg:die(x, y) then
            self:die()
        end
    end

    function result.updateVelocity(self, id)
        local px, py = self.body:getPosition()
        local vx, vy = self.body:getLinearVelocity()

        -- constants
        local heroAuraRange = 300
        local visualRange = 100
        local protectedRange = 30
        local centeringFactor = 0.005
        local avoidFactor = 0.5
        local matchingFactor = 0.5
        local maxSpeed = 200

        -- accumulators
        local xPosAvg, yPosAvg = 0, 0
        local xVelAvg, yVelAvg = 0, 0
        local neighbors = 0
        local closeDx, closeDy = 0, 0

        for i, p in ipairs(people) do
            if i ~= id then
                local opx, opy = p.body:getPosition()
                local ovx, ovy = p.body:getLinearVelocity()
                local dx = px - opx
                local dy = py - opy

                if math.abs(dx) < visualRange and math.abs(dy) < visualRange then
                    local squaredDistance = dx*dx + dy*dy
                    if squaredDistance < protectedRange*protectedRange then
                        closeDx = closeDx + px - opx
                        closeDy = closeDy + py - opy
                    elseif squaredDistance < visualRange*visualRange then
                        xPosAvg = xPosAvg + opx
                        yPosAvg = yPosAvg + opy
                        xVelAvg = xVelAvg + ovx
                        yVelAvg = yVelAvg + ovy
                        neighbors = neighbors + 1
                    end
                end
            end
        end

        if neighbors > 0 then
            xPosAvg = xPosAvg / neighbors
            yPosAvg = yPosAvg / neighbors
            xVelAvg = xVelAvg / neighbors
            yVelAvg = yVelAvg / neighbors

            vx = vx + (xPosAvg-px) * centeringFactor + (xVelAvg - vx) * matchingFactor
            vy = vy + (yPosAvg-py) * centeringFactor + (yVelAvg - vy) * matchingFactor
        end

        if hero_x-x < heroAuraRange and hero_y-y < heroAuraRange then
            local dhx, dhy = normalize(hero_x - x, hero_y - y)
            vx = vx + dhx * 10
            vy = vy + dhy * 10
        end

        vx = vx + closeDx * avoidFactor
        vy = vy + closeDy * avoidFactor

        local speed = math.sqrt(vx*vx + vy*vy)
        if speed > maxSpeed then
            vx = vx/speed*maxSpeed
            vy = vy/speed*maxSpeed
        end

        self.body:setLinearVelocity(vx, vy)
    end

    return result
end
