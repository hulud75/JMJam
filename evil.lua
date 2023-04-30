evil = {}

function evil.load(self)
    evil.image = love.graphics.newImage("evil_smoke.png")
    evil.speed = 500
end

function evil.draw(self)
    local r = -math.pi/4
    dx, dy = rotate(self.x, 0, r)
    love.graphics.draw(self.image, dx-screen_offset_x, dy-screen_offset_y, r)
end

function evil.update(self, dt)
    self.x = self.x+dt*self.speed
end

function evil.heat(self, x, y)
    return x < self.x+self.image:getWidth() and 1 or 0
end

function evil.restart(self)
    evil.x = -evil.image:getWidth()
end
