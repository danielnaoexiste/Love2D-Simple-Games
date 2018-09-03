-- Requiring Libs
    Object = require 'libs.classic';
    push = require 'libs.push';

-- Requiring Classes
    require 'Classes.bird';   
    require 'Classes.pipe';

-- Global Variables
    windowWidth = 630;
    windowHeight = 720;
    virtualWidth = 340;
    virtualHeight = 388;
    score = 0;
    highScore = 0;

function love.load()
    -- Removes Bilinear Filter
    love.graphics.setDefaultFilter('nearest', 'nearest');
    
    -- Randomize
    math.randomseed(os.time());
    listOfPipes = {};
    resetGame();

    --  Sets font
    pixelFont = love.graphics.newFont('fonts/kongtext.ttf', 8);

    -- Screen Setup with virtual resolutions from push lib
    push:setupScreen(virtualWidth, virtualHeight, windowWidth, windowHeight, {
        fullscreen = false,
        resizable = false,
        vsync = true
    });

    -- "Can Count Score = True"
    nextPipe = 1;
end

function love.update(dt)
    -- Updates Birbs n' Pipes
    Birb:update(dt);
  
    -- For each pipe in the listOfPipes table
    for i, pipe in ipairs(listOfPipes) do
        pipe:update(dt);           -- Updates the Pipe
        pipe:checkCollision(Birb); -- Checks Collision and Birb Offscreen
        
        if pipe.dead then                 -- If the pipe is offscreen
            table.remove(listOfPipes, i); -- Destroy it
            if nextPipe == 2 then   -- If the score has already been added
                nextPipe = 1;       -- Resets the NextPipe "Boolean"
            end
        end

        if Birb.x > listOfPipes[1].x + listOfPipes[1].width -- Checks Next Pipe Position
            and nextPipe == 1 then  -- If the previous pipe has been destroyed
            score = score + 1;      -- Counts only 1+ to the score
            nextPipe = 2;           -- NextPipe "Boolean = false"
        end
    end   
end 


function love.keypressed(key)
    -- Handles Single Key Presses
    if key == 'escape' then
        love.event.quit()
    else
        Birb:keypressed(key);
    end
end

--[[ function love.touchpressed()
    Birb:keypressed();
end ]]

function love.draw(dt)
    push:start(); -- Starts Push Rendering

    -- Background Color
    love.graphics.clear(.14, .36, .46, 1)
    
    
    -- Birb Draw Event
    Birb:draw(dt);

    -- Draw Pipes
    for i, pipe in ipairs(listOfPipes) do
        pipe:draw(dt);
    end
    
    -- Ui Text
    love.graphics.setFont(pixelFont);
    love.graphics.setColor(1, 1, 1, 1);
    love.graphics.printf("Score: " .. score, 0, 10, virtualWidth, 'left');
    love.graphics.printf("Highscore: " .. highScore, 0, 20, virtualWidth, 'left');
    
    push:finish(); -- Ends Push rendering
end

function resetGame()
    -- Deletes existing pipes
    for i, pipe in ipairs(listOfPipes) do
        table.remove(listOfPipes, i);
    end
   
    -- Recreates the Birb and the Pipes
    Birb = Bird(62, 200, 30, 25);
    listOfPipes = {};
    table.insert(listOfPipes, Pipe(virtualWidth, 0, 54, virtualHeight));
    table.insert(listOfPipes, Pipe(virtualWidth + ((virtualWidth + 54) / 2), 0, 54, virtualHeight));
    
    -- Sets Highscore
    if score > highScore then
        highScore = score
        score = 0;
    end

    -- Resets canScoreCounter
    nextPipe = 1;
end