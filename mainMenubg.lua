bg = {}

function bg.load(self)
    bg = love.graphics.newImage("bgStartMenu.png")
    
function bg.draw(self)
    --local r = -math.pi/4
    local r = 0
    love.graphics.draw(self.image, -world_x, -world_y, r)
end