bg = {}

function bg.load(self)
    bg = love.graphics.newImage("bgStartMenu.png")
    
function bg.draw(self)
    --local r = 0
    local r = 0
    love.graphics.draw(self.image, -screen_offset_x, -screen_offset_y, r)
end
