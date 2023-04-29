mainMenu_bg = {}

function mainMenu_bg.load(self)
    mainMenu_bg.image = love.graphics.newImage("bgStartMenu.png")
    mainMenu_bg.shader = love.graphics.newShader [[
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
    mainMenu_bg.time = 0
end
    
function mainMenu_bg.draw(self,mainMenu_x,mainMenu_y,mainMenu_newWidth,mainMenu_newHeight)
    currentWidth, currentHeight = self.image:getDimensions()
    newW = mainMenu_newWidth / currentWidth
    newH = mainMenu_newHeight / currentHeight
    r = 0
    love.graphics.draw(self.image, mainMenu_x, mainMenu_y, r, newW, newH)
end

function mainMenu_bg.update(self, dt)
    self.time = self.time + dt
end