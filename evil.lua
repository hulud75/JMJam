evil = {}

function evil.load(self)
    evil.image = love.graphics.newImage("evil_smoke.png")
    evil.x = -evil.image:getWidth()
    evil.speed = 100
end

function evil.draw(self)
    --local r = -math.pi/4
    local r = 0
    love.graphics.draw(self.image, self.x-world_x, -world_y, r)
end

function evil.update(self, dt)
    self.x = self.x+dt*self.speed
end

function evil.die(self, x, y)
    return x < self.x+self.image:getWidth()
end
