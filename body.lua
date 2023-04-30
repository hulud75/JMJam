require("math_utils")

function body(x, y, physic_mode, radius, render_mode, sprites)
    local result = {
        render_mode = render_mode,
        alive = true,
        animation = math.random(0, sprites.animation_steps),
        angle = 0,
        heat = 0,
        maxSpeed = 700, maxForce = 20,
        ax = 0, ay = 0,
        sprites = sprites
    }
    result.body = love.physics.newBody(world, x, y, physic_mode)
    result.shape = love.physics.newCircleShape(radius)
    result.fixture = love.physics.newFixture(result.body, result.shape, 1)

    function result.draw(self)
        local x, y = worldToScreen(self.body:getPosition())
        local radius = self.shape:getRadius()
        love.graphics.setColor(1, 1-self.heat, 1-self.heat)

        self.sprites:draw((x + radius) - self.sprites.w/2, (y + radius) - self.sprites.h/2, self.animation, self.angle)

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
            people[self] = nil
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
        local heating_speed = 0.4
        if evil:die(x, y) or bg:die(x, y) then
            self.heat = self.heat+dt*heating_speed
        else
            self.heat = math.max(0.0, self.heat-dt*heating_speed)
        end
        if self.heat > 1 then
            self:die()
        end
    end

    function result.applyForce(self, fx, fy)
        self.ax = self.ax + fx
        self.ay = self.ay + fy
    end

    function result.seek(self, tx, ty)
        local px, py = self.body:getPosition()
        local vx, vy = self.body:getLinearVelocity()
        local dx, dy = normalize(tx - px , ty - py)
        dx, dy = dx * self.maxSpeed, dy * self.maxSpeed
        local steerX, steerY = limitMagnitude(dx - vx, dy - vy, self.maxForce)
        self:applyForce(steerX, steerY)
    end

    function result.followPath(self, path)
        local PREDICTOR_LENGTH = 25
        local TARGET_LENGTH = 100
        local px, py = self.body:getPosition()
        local vx, vy = self.body:getLinearVelocity()
        if vx == 0 or vy == 0 then vx, vy = 0.01, 0.01 end
        local predictX, predictY = normalize(vx, vy)
        predictX, predictY = predictX * PREDICTOR_LENGTH, predictY * PREDICTOR_LENGTH
        local plx, ply = px + predictX, py + predictY

        local bestDistance = 9999999
        local targetX, targetY = nil, nil
        for ax, ay, bx, by in path:segments() do
            local npx, npy = closestPointToPoint(plx, ply, ax, ay, bx, by, true)
            local distance = distance(npx, npy, plx, ply)
            if distance < bestDistance then
                bestDistance = distance
                local dirX, dirY = normalize(bx - ax, by - ay)
                dirX, dirY = dirX * TARGET_LENGTH, dirY * TARGET_LENGTH
                targetX, targetY = npx + dirX, npy + dirY
            end
        end

        if targetX ~= nil and bestDistance > path.radius then
            self:seek(targetX, targetY)
        end
    end

    function result.updateAcceleration(self)
        local vx, vy = self.body:getLinearVelocity()
        local nvx, nvy = vx + self.ax, vy + self.ay
        self.body:setLinearVelocity(nvx, nvy)
        if nvx == 0 or nvy == 0 then nvx, nvy = 0.01, 0.01 end
        local dx, dy = normalize(nvx, nvy)
        self.angle = angleFromDir(dx, dy)
        self.ax, self.ay = 0, 0
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
        local maxSpeed = 400

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
