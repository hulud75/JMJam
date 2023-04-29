function body(x, y, physic_mode, radius, render_mode)
    local result = { render_mode = render_mode, alive = true }
    result.body = love.physics.newBody(world, x, y, physic_mode)
    result.shape = love.physics.newCircleShape(radius)
    result.fixture = love.physics.newFixture(result.body, result.shape, 1)

    function result.draw(self)
        x, y = self.body:getPosition()
        radius = self.shape:getRadius()
        if self.alive then
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.setColor(1, 0, 0)
        end
        love.graphics.rectangle(self.render_mode, x-world_x, y-world_y, radius*2, radius*2)
        love.graphics.setColor(1, 1, 1)
    end

    function result.getPosition(self)
        return self.body:getPosition()
    end

    function result.setPosition(self, x, y)
        return self.body:setPosition(x, y)
    end

    function result.die(self)
        self.alive = false
    end

    return result
end
