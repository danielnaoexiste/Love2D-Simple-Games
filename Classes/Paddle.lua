Paddle = Object:extend();

-- Initiates the paddle in the parameters
function Paddle:new(x, y, width, height)
    self.x = x;
    self.y = y;
    self.width = width;
    self.height = height;
    self.dy = 0;
end

function Paddle:update(dt)
    -- Moves the Paddles
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt);
    else
        self.y = math.min(virtualHeight - self.height, self.y + self.dy * dt);
    end
end

-- Renders the paddle
function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height);
end