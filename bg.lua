bg = {}

goal_x = 15472
goal_y = 1024
goal_radius_sq = 600*600

function bg.load(self)
    bg.lava = love.graphics.newImage("lava_0000.png")
    bg.lava:setWrap("repeat", "repeat")
    bg.groundData = love.image.newImageData("ground_05.png")
    bg.ground = love.graphics.newImage(bg.groundData)
    bg.lava_heat = love.graphics.newImage("lava_heat.png")
    bg.w = bg.ground:getWidth()
    bg.h = bg.ground:getHeight()
    bg.lava_quad = love.graphics.newQuad(0, 0, bg.w, bg.h, bg.lava:getWidth(), bg.lava:getHeight())
    bg.shader = love.graphics.newShader [[
        extern number time;
        extern number screen_offset_x;
        extern number screen_offset_y;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {
            vec2 size = vec2(512, 512);

            float ratio = 1.0;
            float wobbler_time = 100.0*time;
            float period = 10;
            float amplitude = 0.01;
            float paralax_space = 0.00001;
            float paralax_time = time*100;

            vec2 paralax_offset = vec2(screen_offset_x*paralax_space+paralax_time, screen_offset_y*paralax_space);

            vec2 local = mod(texture_coords * size, period) / period;
            vec2 offset = vec2(
                 sin(texture_coords.x * period + wobbler_time)+paralax_offset.x, 
                (cos(texture_coords.y * period + wobbler_time)+paralax_offset.y)*ratio
            )*amplitude;
            local = mod(texture_coords + offset, 1.0);
            vec2 uv = vec2(local.x, local.y);
            return Texel(texture, uv);
            //return vec4(uv.x, uv.y, 0, 1);
        }
    ]]
    bg.time = 0
end

function bg.update(self, dt)
    self.shader:send("time", self.time)
    self.shader:send("screen_offset_x", screen_offset_x)
    self.shader:send("screen_offset_y", screen_offset_y)
    self.time = self.time + dt/100
end

function bg.draw(self)
    local r = 0

    love.graphics.setShader(bg.shader)
    love.graphics.draw(self.lava, bg.lava_quad, -screen_offset_x, -screen_offset_y, r)

    love.graphics.setShader()
    love.graphics.draw(self.ground, -screen_offset_x, -screen_offset_y, r)
end

function bg.draw_overlay(self)
    local r = 0
    love.graphics.setBlendMode("add")
    love.graphics.draw(self.lava_heat, -screen_offset_x, -screen_offset_y, r, 4)
    love.graphics.setBlendMode("alpha")
end

function bg.heat(self, x, y)
    return self:isLava(x, y) and 1 or 0
end

function bg.isLava(self, x, y)
    if (x >= 0 and x < self.w and y >= 0 and y < self.h) then
        r, g, b, a = bg.groundData:getPixel(x, y)
        return a < 0.5
    end
    return false
end

function bg.isGoal(self, x, y)
    dx = x-goal_x
    dy = y-goal_y
    return dx*dx+dy*dy < goal_radius_sq
end
