burn = { psystems = {} }

function burn.load(self)
    particle_img = love.graphics.newImage('particle.png')
    burn_sound = love.audio.newSource("deathByFireFast.mp3", "static")
    teleport_sound = love.audio.newSource("teleportationExtraFast.mp3", "static")
end

function burn.draw(self)
    local r = 0
    for k,psystem in pairs(self.psystems) do
        local x, y = worldToScreen(psystem.x, psystem.y)
        love.graphics.draw(psystem.psystem, x, y, 0, 0.1)
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

function burn.create(self, x, y, burn)
    local psystem = love.graphics.newParticleSystem(particle_img, 32)
    psystem:setParticleLifetime(0.5, 1) -- Particles live at least 2s and at most 5s.
    psystem:setRadialAcceleration(2000, 4000)
    psystem:setEmissionArea("uniform", 50, 50)
    if burn then
        psystem:setColors(255, 255, 0, 255, 128, 0, 0, 255, 0, 0, 0, 0) -- Fade to black.    
        burn_sound:stop()
        burn_sound:play()
    else
        psystem:setColors(255, 255, 255, 255, 0, 255, 0, 255, 0, 255, 0, 0) -- Fade to black.
        teleport_sound:stop()
        teleport_sound:play()
    end
    table.insert(self.psystems, { psystem = psystem, x = x, y = y } )
    psystem:emit(32)
end
