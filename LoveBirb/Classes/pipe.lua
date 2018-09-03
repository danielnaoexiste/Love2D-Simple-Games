Pipe = Object:extend();

function Pipe:new(x, y, width, height)
    -- Constructor function
    self.x, self.aux = x;
    self.y = y;
    self.width = width;
    self.height = height;
    
    self.spaceHeight = 100; -- Space Between Bottom and Top
    self.spaceYMin = 54;    -- Minimum Y value for the Space
    
    -- Random position for the Space between 
    -- Top and Bottom Pipes
    self.spaceY = love.math.random(
        self.spaceYMin, 
        self.height - self.spaceHeight - self.spaceYMin
    );

end

function Pipe:update(dt)
    -- Moves the pipe
    self.x = self.x - (60 * dt); 
    
    -- When the pipes goes offscreen
    -- Deletes the current one and creates a new Pipe
    if (self.x + self.width) < 0 then
        self.dead = true;
        Pipe:reset(); 
    end
end

function Pipe:draw(dt)
    -- Green Color
    love.graphics.setColor(.37, .82, .28);
    
    -- Top Pipe
    love.graphics.rectangle(
        'fill',
        self.x,
        0,
        self.width,
        self.spaceY
    ); 
    
    -- Bottom Pipe
    love.graphics.rectangle(
        'fill', 
        self.x,
        self.spaceY + self.spaceHeight,
        self.width,
        self.height - self.spaceY - self.spaceHeight
    );

end

function Pipe:reset()
    -- Creates new pipes
    table.insert(listOfPipes, Pipe(virtualWidth, 0, 54, virtualHeight));
end

function Pipe:checkCollision(obj)
    if Birb.x < self.x  + self.width                              -- Checks X position
        and Birb.x + Birb.width > self.x                          -- Checks X position
        and (
            Birb.y < self.spaceY                                  -- Top Pipe Collision
            or 
            Birb.y + Birb.height > self.spaceY + self.spaceHeight -- Bottom Pipe Collision
        ) or Birb.y > virtualWidth + 2 * Birb.height then         -- Birb offscreen
        resetGame();
    end
end