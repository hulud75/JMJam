function distance(ax, ay, bx, by)
  local dx = ax - bx
  local dy = ay - by
  return math.sqrt(dx * dx + dy * dy)
end
