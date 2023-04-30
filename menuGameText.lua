menuGameText = {}

function menuGameText.load(self)
    menuGameText.image = love.graphics.newImage("title.png")
end

function menuGameText.draw(self,startButton_x,startButton_y)
    currentWidth, currentHeight = self.image:getDimensions()
    r = 0
    love.graphics.draw(self.image, startButton_x, startButton_y, r)
end

