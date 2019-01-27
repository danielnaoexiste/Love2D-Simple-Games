-- Requiring Libraries 
    Object = require 'libs.classic';
    bump = require 'libs.bump';

-- Creates physics world
    world = bump.newWorld();
    local map = require 'levels.level_1' 
    
-- Requiring Classes
    require 'classes.player';
    require 'classes.levelManager';
    

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest');
    Player = Player(love.graphics.getWidth()/2, 0, 32, 64);

    -- Adds to the Physics World
    world:add(Player, Player.x, Player.y, Player.width, Player.height);
    Level(map);
end

function love.update(dt)
    Player:update(dt);
end

function love.keypressed(key)
    -- Handles Single Key Presses
    if key == 'escape' then
        love.event.quit()
    else
        Player:keypressed(key);
    end
end

function love.draw()
    Player:draw();
    Level:draw(map);
end