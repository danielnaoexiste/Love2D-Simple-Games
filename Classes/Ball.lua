Ball = Object:extend();

-- Loads the Ball with the Parameters
function Ball:new(x, y, width, height)
    self.x = x;
    self.y = y;
    self.width = width;
    self.height = height;

    -- Velocity and Direction
    self.dx = math.random(2) == 1 and 100 or -100;
    self.dy = math.random(-50, 50);
end

function Ball:reset()
    -- Resets the Ball Position and Speed
    self.x = virtualWidth / 2 - 2;
    self.y = virtualHeight / 2 - 2;
    self.dx = math.random(2) == 1 and 100 or -100;
    self.dy = math.random(-50, 50);
end

function Ball:collides(paddle)

    -- Checks if the left edge of either is further to the right than the right edge of the other
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false;
    end

    -- Checks if the bottom edge of either is higher than the top edge of the other
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false;
    end

    -- if not, they are overlapping -> Collision
    return true;
end

function Ball:update(dt) 
    -- Moves the Ball
    self.x = self.x + self.dx * dt;
    self.y = self.y + self.dy * dt;
end

function Ball:render()
    -- Renders the ball
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height);
end