mainScoreTxt = {}
scoreColor = {1, 0.5, 0, 1}

function mainScoreTxt.draw(self,scoreSize,scoreCount,score_tx,score_ty)
    love.graphics.setNewFont(scoreSize)
    love.graphics.print({scoreColor, scoreCount}, score_tx, score_ty)
end

