Path = {points = {}, radius = 50}

function Path:new(o)
  local p = o or {}
  setmetatable(p, self)
  self.__index = self
  return p
end

function Path:addPoint(px, py)
  table.insert(self.points, px)
  table.insert(self.points, py)
end

function Path:getLastPoint()
  local size = #self.points
  if size >= 2 then
    return unpack(self.points, size - 1, size)
  end
end

function Path:getLastLine()
  local size = #self.points
  if size >= 4 then
  	return unpack(self.points, size - 3, size)
  end
end

function Path:draw()
  if #self.points >= 4 then
    love.graphics.push()
    love.graphics.translate(-world_x, -world_y)
    love.graphics.setLineWidth(self.radius * 2)
    love.graphics.line(self.points)
    love.graphics.pop()
  end
end

