function distance(ax, ay, bx, by)
  local dx = ax - bx
  local dy = ay - by
  return math.sqrt(dx * dx + dy * dy)
end

function magnitude(x, y)
  return math.sqrt(x * x + y * y)
end

function normalize(x, y)
    l = math.sqrt(x*x+y*y)
    if l == 0 then return 0, 0 end
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

function closestPointToPointParameter(px, py, ax, ay, bx, by, clampToLine)
  local apx, apy = px - ax, py - ay
  local abx, aby = bx - ax, by - ay
  local t = dot(abx, aby, apx, apy) / dot(abx, aby, abx, aby)
  if clampToLine then
    t = clamp(t, 0, 1)
  end
  return t
end

function closestPointToPoint(px, py, ax, ay, bx, by, clampToLine)
  local t = closestPointToPointParameter(px, py, ax, ay, bx, by, clampToLine)
  return (bx - ax) * t + ax, (by - ay) * t + ay
end

function limitMagnitude(x, y, m)
  local l = magnitude(x, y)
  if l > m then
    local nx, ny = normalize(x, y)
    return nx * m, ny * m
  end
  return x, y
end

function rect(x, y, w, h)
    return {x=x, y=y, w=w, h=h}
end

function rotate(x, y, a)
    return
      x*math.cos(a) - y*math.sin(a),
      x*math.sin(a) + y*math.cos(a)
end

function worldToScreen(x, y)
  return x-screen_offset_x, y-screen_offset_y
end

function screenToWorld(x, y)
  return x+screen_offset_x, y+screen_offset_y
end

function clamp(x, min, max)
    return math.max(math.min(x, max), min)
end

function angleFromDir(x, y)
    return math.pi*2 + math.atan2(y, x)
end

function add(x1, y1, x2, y2)
  return x1+x2, y1+y2
end

function mul(x1, y1, x2, y2)
  return x1*x2, y1*y2
end
