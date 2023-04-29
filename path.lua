Path = {points = {}}

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
  size = #self.points
  return self.points[size - 1], self.points[size]
end

function Path:draw()
  if #self.points >= 4 then
    love.graphics.push()
    love.graphics.translate(-world_x, -world_y)
    love.graphics.line(self.points)
    love.graphics.pop()
  end
end

