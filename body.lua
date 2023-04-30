require("math_utils")

function body(x, y, physic_mode, radius, render_mode, sprites, sprites_idle, shaman)
    local result = {
        render_mode = render_mode,
        alive = true,
        saved = false,
        animation = math.random(0, sprites.animation_steps),
        angle = 0,
        heat = 0,
        maxSpeed = 900, maxForce = 40,
        ax = 0, ay = 0,
        sprites = sprites,
        sprites_idle = sprites_idle,
        inLava = false,
        teleporting = 0,
        shaman = shaman
    }
    result.body = love.physics.newBody(world, x, y, physic_mode)
    result.shape = love.physics.newCircleShape(radius)
    result.fixture = love.physics.newFixture(result.body, result.shape, 1)
    result.body:setLinearVelocity(0, 0)

    function result.draw(self)
        if self.alive then
            local x, y = worldToScreen(self.body:getPosition())
            local radius = self.shape:getRadius()
            love.graphics.setColor(1-self.teleporting, 1-self.heat+self.teleporting, 1-self.heat-self.teleporting)

            vx, vy = self.body:getLinearVelocity()
            v = math.max(math.abs(vx), math.abs(vy))
            local sprites = v > 0 and self.sprites or self.sprites_idle
            sprites:draw((x + radius) - self.sprites.w/2, (y + radius) - self.sprites.h/2, self.animation, self.angle, self.inLava)

            love.graphics.setColor(1, 1, 1)
        end
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
            burn:create(x, y, true)
            people[self] = nil
        end
    end

    function result.save(self)
        self.saved = true
        if not self.shaman then
            score_saved = score_saved+1
        end
        if self.alive then
            self.alive = false
            x, y = self.body:getPosition()
            burn:create(x, y, false)
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

        self.inLava = bg:isLava(x, y)
        -- Heating
        local heating_speed = evil:heat(x, y) + bg:heat(x, y)
        if heating_speed > 0 then
            self.heat = self.heat+dt*heating_speed
        else
            local cool_speed = 0.4
            self.heat = math.max(0.0, self.heat-dt*cool_speed)
        end
        if self.heat > 1 then
            self:die()
        end

        -- Goal
        if bg:isGoal(x, y) and (not self.shaman or x < evil.x) then
            self.teleporting = self.teleporting + dt*(self.shaman and 100000 or 1)
        end
        if self.teleporting > 1 then
            self:save()
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
        if bg:isLava(px, py) then dx, dy = dx / 2, dy / 2 end
        local steerX, steerY = limitMagnitude(dx - vx, dy - vy, self.maxForce)
        self:applyForce(steerX, steerY)
    end

    function result.followPath(self, path)
        local PREDICTOR_LENGTH = 25
        local TARGET_LENGTH = 200
        local ATTRACT_RANGE = 400
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

        if targetX ~= nil and bestDistance > path.radius and bestDistance < ATTRACT_RANGE then
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

    return result
end
