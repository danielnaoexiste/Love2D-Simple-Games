Player = Object:extend();

-- Loads the Player
function Player:new(x, y, width, height)
    self.x = x;
    self.y = y;
    self.width = width;
    self.height = height;
    self.gravity = 200;
    self.runSpeed = 300;
    self.xVelocity = 0;
    self.yVelocity = 0;
    self.terminalVelocity = 500;
    self.onGround = false;
    self.jumpVelocity = -250;
end

function Player:update(dt)
    ApplyGravity(self, dt);
    Collide(self, dt);
    Move(self, dt);
end

function Player:keypressed(key)
    if key == "w" and self.onGround then
        print(self.onGround);
        self.onGround = false;
        self.yVelocity = self.jumpVelocity;
    end 
end

function Player:draw() 
    love.graphics.setColor(1, 1, 0);
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height);
end

function Move(self, dt)
    if love.keyboard.isDown("d") then
        self.xVelocity = self.runSpeed; 
    elseif love.keyboard.isDown("a") then
        self.xVelocity = -self.runSpeed; 
    else
        print(self.onGround);
        self.xVelocity = 0;
    end
end

function ApplyGravity(self, dt)
    -- Calculates Gravity
    if self.yVelocity < self.terminalVelocity then
        self.yVelocity = self.yVelocity + self.gravity * dt;
    else
        self.yVelocity = self.terminalVelocity;
    end
end

function Collide(self, dt)
    local futureX = self.x + self.xVelocity * dt;
    local futureY = self.y + self.yVelocity * dt;
    local nextX, nextY, cols, len = world:move(self, futureX, futureY);
    self.onGround = false;

    for i = 1, len do 
        local col = cols[i];
        if col.normal.y == -1 or col.normal.y == 1 then
            self.yVelocity = 0;
        end

        if col.normal.y == -1 then
            self.onGround = true;
        end 
    end
    self.x = nextX;
    self.y = nextY;
end