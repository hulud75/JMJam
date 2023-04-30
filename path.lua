Path = {}

function Path:new()
  local p = {points = {}, radius = 50, maxLength = 20}
  setmetatable(p, self)
  self.__index = self
  return p
end

function Path:addPoint(px, py)
  table.insert(self.points, px)
  table.insert(self.points, py)
  if #self.points > self.maxLength * 2 then
    table.remove(self.points, 1)
    table.remove(self.points, 1)
  end
end

function Path:lastPoint()
  local size = #self.points
  if size >= 2 then
    return unpack(self.points, size - 1, size)
  end
end

function Path:lastSegment()
  local size = #self.points
  if size >= 4 then
  	return unpack(self.points, size - 3, size)
  end
end

function Path:segments()
  local i = -3
  local size = #self.points
  return function()
    i = i + 4
    if i + 4 <= size then return unpack(self.points, i, i + 4) end
  end
end

function Path:draw()
  if #self.points >= 4 then
    love.graphics.push()
    love.graphics.translate(-screen_offset_x, -screen_offset_y)
    -- love.graphics.rotate(-math.pi/4)
    love.graphics.setLineWidth(self.radius * 2)
    love.graphics.line(self.points)
    love.graphics.pop()
  end
end

