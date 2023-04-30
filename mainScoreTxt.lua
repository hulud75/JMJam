mainScoreTxt = {}

function mainScoreTxt.load(self)
    mainScoreTxt.image = love.graphics.newImage("mainScore.png")
end

function mainScoreTxt.draw(self,mainScoreTxt_x,mainScoreTxt_y,newWidth,newHeight)
    currentWidth, currentHeight = self.image:getDimensions()
    newW = newWidth / currentWidth
    newH = newHeight / currentHeight
    r = 0
    love.graphics.draw(self.image, mainScoreTxt_x, mainScoreTxt_y, r, newW, newH)
end

