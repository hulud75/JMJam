burn = { psystems = {} }

function burn.load(self)
    particle_img = love.graphics.newImage('particle.png')
end

function burn.draw(self)
    for k,psystem in pairs(self.psystems) do
        love.graphics.draw(psystem.psystem, psystem.x-world_x, psystem.y-world_y, 0, 0.1)
    end
end

function burn.update(self, dt)
    for k,psystem in pairs(self.psystems) do
        psystem.psystem:update(dt)
    end

    -- Remove finished particles
    for i=#self.psystems,1,-1 do
        if self.psystems[i].psystem:getCount() == 0 then
            table.remove(self.psystems, i)
        end
    end
end

function burn.create(self, x, y)
    local psystem = love.graphics.newParticleSystem(particle_img, 32)
    psystem:setParticleLifetime(0.5, 1) -- Particles live at least 2s and at most 5s.
    psystem:setRadialAcceleration(2000, 4000)
    psystem:setAreaSpread("uniform", 50, 50)
    psystem:setColors(255, 255, 0, 255, 128, 0, 0, 255, 0, 0, 0, 0) -- Fade to black.    
    table.insert(self.psystems, { psystem = psystem, x = x, y = y } )
    psystem:emit(32)
end
