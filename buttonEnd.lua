buttonEnd = {}

function buttonEnd.load(self)
    buttonEnd.image = love.graphics.newImage("buttonStart.jpg")
end

function buttonEnd.draw(self,endButton_x,endButton_y,newWidth,newHeight)
    currentWidth, currentHeight = self.image:getDimensions()
    newW = newWidth / currentWidth
    newH = newHeight / currentHeight
    r = 0
    love.graphics.draw(self.image, endButton_x, endButton_y, r, newW, newH)
end

