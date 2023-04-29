mainMenu_bg = {}

function mainMenu_bg.load(self)
    mainMenu_bg.image = love.graphics.newImage("bgStartMenu.png")
end
    
function mainMenu_bg.draw(self)
    --local r = -math.pi/4
    local r = 0
    local newW = 1280
    local newH = 960

    love.graphics.draw(self.image, -world_x, -world_y, r, newW, newH)
end
