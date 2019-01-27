Bird = Object:extend();

function Bird:new(x, y, width, height)
    -- Constructor Function
    self.x, self.auxX = x;
    self.y, self.auxY = y;
    self.width = width;
    self.height = height;
    self.ySpeed = 0;
end

function Bird:update(dt)
    -- Gravity
    print(self.ySpeed)
    self.ySpeed = self.ySpeed + (516 * dt);
    self.y = self.y + (self.ySpeed * dt);
end

function Bird:keypressed(key)
    -- Flops
    if self.y > 0 then
        self.ySpeed = -165;
    end
end

function Bird:draw()
    -- Draws the Bird
    love.graphics.setColor(.87, .84, .27);
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height);
end