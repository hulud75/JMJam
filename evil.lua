evil = {}

function evil.load(self)
    evil.sprite = love.graphics.newImage("swarmCloud_01.png")
    evil.speed = 500
    evil.length = 4096
end

function evil.draw(self)
    local r = 0
    dx, dy = rotate(self.x, 0, r)
    local x, y = worldToScreen(self.x-evil.length/2, 0)
    love.graphics.draw(self.psystem, x, bg.ground:getHeight()/2)
end

function evil.update(self, dt)
    self.x = self.x+dt*self.speed
    evil.psystem:update(dt)
    self.psystem:emit(dt*4000)
end

function evil.heat(self, x, y)
    return x < self.x and 1 or 0
end

function evil.restart(self)
    evil.x = 0
    evil.psystem = love.graphics.newParticleSystem(evil.sprite, 4000)
    evil.psystem:setLinearAcceleration(-2000, 0)
    evil.psystem:setColors(255, 255, 255, 0, 16, 16, 16, 255, 0, 0, 0, 0) -- Fade to black.    
    evil.psystem:setSizeVariation(1)
    evil.psystem:setSpinVariation(1)
    evil.psystem:setSpin(0, 20)
    evil.psystem:setRotation(0, math.pi*2)
    evil.psystem:setEmissionArea("uniform", evil.length/2, bg.ground:getHeight()/2)
    evil.psystem:setParticleLifetime(0.5, 1) -- Particles live at least 2s and at most 5s.
end
