function distance(ax, ay, bx, by)
  local dx = ax - bx
  local dy = ay - by
  return math.sqrt(dx * dx + dy * dy)
end

function magnitude(x, y)
  return math.sqrt(x * x + y * y)
end

function normalize(x, y)
  local l = magnitude(x, y)
  return x/l, y/l
end

function dot(ax, ay, bx, by)
  return ax * bx + ay * by
end

function projectOnLine(px, py, ax, ay, bx, by)
  local apx, apy = px - ax, py - ay
  local abx, aby = bx - ax, by - ay
  abx, aby = normalize(abx, aby)
  local d = dot(apx, apy, abx, aby)
  abx, aby = abx * d, aby * d
  return ax + abx, ay + aby
end

function limitMagnitude(x, y, m)
  local l = magnitude(x, y)
  if l > m then
    local nx, ny = normalize(x, y)
    return nx * m, ny * m
  end
  return x, y
end

function angleFromDir(x, y)
    return math.pi*2 + math.atan2(y, x)
end

