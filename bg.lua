bg = {}

function bg.load(self)
    bg.lava = love.graphics.newImage("lava_01.png")
    bg.groundData = love.image.newImageData("ground_03.png")
    bg.ground = love.graphics.newImage(bg.groundData)
    bg.w = bg.ground:getWidth()
    bg.h = bg.ground:getHeight()
    bg.shader = love.graphics.newShader [[
        extern number time;
        extern number world_x;
        extern number world_y;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {
            vec2 size = vec2(8096, 1024);

            float ratio = 8.0;
            float wobbler_time = 100.0*time;
            float period = 100;
            float amplitude = 0.001;
            float paralax_space = 0.01;
            float paralax_time = time*200;

            vec2 paralax_offset = vec2(world_x*paralax_space+paralax_time, world_y*paralax_space-paralax_time);

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
    self.shader:send("world_x", world_x)
    self.shader:send("world_y", world_y)
    self.time = self.time + dt/100
end

function bg.draw(self)
    -- local r = -math.pi/4
    local r = 0

    love.graphics.setShader(bg.shader)
    love.graphics.draw(self.lava, -world_x, -world_y, r)

    love.graphics.setShader()
    love.graphics.draw(self.ground, -world_x, -world_y, r)
end

function bg.die(self, x, y)
    if (x >= 0 and x < self.w and y >= 0 and y < self.h) then
        r, g, b, a = bg.groundData:getPixel(x, y)
        return a < 0.5
    end
    return false
end