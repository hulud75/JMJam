
function load_sprites(filename)
    self = {}
    self.animation_steps = 7
    self.dir_steps = 8
    local imageData = love.image.newImageData(filename)
    local remap_dir = {1, 0, 7, 6, 5, 4, 3, 2}
    self.image = love.graphics.newImage(imageData)
    self.w = imageData:getWidth() / self.animation_steps
    self.h = imageData:getHeight() / self.dir_steps
    self.quads = {}
    for step = 0,self.animation_steps-1 do
        local dirs = {}
        table.insert(self.quads, dirs)
        for dir = 1,self.dir_steps do
            dirs[dir] = {}
            dirs[dir][1] = love.graphics.newQuad(step*self.h, remap_dir[dir]*self.h, self.h, self.h, self.image)
            dirs[dir][2] = love.graphics.newQuad(step*self.h, remap_dir[dir]*self.h, self.h, self.h*3/6, self.image)
        end
    end

    function self.draw(self, x, y, anim_frame, angle, lava)
        anim_frame = math.floor(math.mod(anim_frame, self.animation_steps))+1
        local dir = math.floor(math.mod(angle * self.dir_steps / (2.0*math.pi) + 0.5, self.dir_steps))+1
        love.graphics.draw(self.image, self.quads[anim_frame][dir][lava and 2 or 1], x, y)
    end

    return self
end
