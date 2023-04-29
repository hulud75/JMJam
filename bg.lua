bg = {}

function bg.load(self)
    bg.image = love.graphics.newImage("map_01.0003.png")
end

function bg.draw(self)
    --local r = -math.pi/4
    local r = 0
    love.graphics.draw(self.image, -world_x, -world_y, r)
end
