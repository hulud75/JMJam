mainMenu_bg = {}
menuTxtColor = {1, .75, 0, 1}

function mainMenu_bg.load(self)
    mainMenu_bg.image = love.graphics.newImage("title.png")
end
    
function mainMenu_bg.draw(self,mainMenu_x,mainMenu_y,mainMenu_newWidth,mainMenu_newHeight)
    currentWidth, currentHeight = self.image:getDimensions()
    newW = mainMenu_newWidth / currentWidth
    newH = mainMenu_newHeight / currentHeight
    r = 0
    love.graphics.draw(self.image, mainMenu_x, mainMenu_y, r, newW, newH)
end

function mainMenu_bg.update(self, dt)
end
