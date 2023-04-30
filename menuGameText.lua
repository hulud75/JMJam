menuGameText = {}

function menuGameText.load(self)
    menuGameText.image = love.graphics.newImage("title.png")
end

function menuGameText.draw(self,startButton_x,startButton_y,newWidth,newHeight)
    currentWidth, currentHeight = self.image:getDimensions()
    newW = newWidth / currentWidth
    newH = newHeight / currentHeight
    r = 0
    love.graphics.draw(self.image, startButton_x, startButton_y, r, newW, newH)
end

