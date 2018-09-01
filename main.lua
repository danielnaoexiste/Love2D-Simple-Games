-- Requiring Libs 
    push = require 'libs.push'
    Object = require 'libs.classic'

-- Requiring Classes
    require 'Classes.Ball'
    require 'Classes.Paddle'

-- Global Variables
    windowWidth = 1280;
    windowHeight = 720;
    virtualWidth = 432;
    virtualHeight = 243;
    paddleSpeed = 200;


function love.load()
    -- Pixel filter || Removes bilinear filter
    love.graphics.setDefaultFilter('nearest', 'nearest');

    -- Seed the RNG (randomness) so that random calls are
    -- Always random, using the os.time() -> Lua randomize()
    math.randomseed(os.time());

    -- Creates the Font
    pixelFont = love.graphics.newFont('fonts/kongtext.ttf', 8);
    scoreFont = love.graphics.newFont('fonts/manaspc.ttf', 32);

    -- Sets Push Lib virtual resolutions
    push:setupScreen(virtualWidth, virtualHeight, windowWidth, windowHeight, {
        fullscreen = false,
        resizable = false,
        vsync = true
    });

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    };

    -- Score Counters
    player1Score = 0;
    player2Score = 0;
    
    -- Creates the paddles
    player1 = Paddle(10, 30, 5, 20);
    player2 = Paddle(virtualWidth - 10, virtualHeight - 30, 5, 20);

    -- Creates the Ball
    ball = Ball(virtualWidth/2 - 2, virtualHeight/2 - 2, 4, 4);
    
    -- Serving Player (1 or 2)
    servingPlayer = 1;

    -- gameState
    gameState = 'start';
end

function love.update(dt)
    -- Controls the Serve's ball direction
    if gameState == 'serve' then
        ball.dy = math.random(-50, 50);
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200);
        else
            ball.dx = -math.random(140, 200);
        end 
    elseif gameState == 'play' then
        -- Checks collision and reverse dx, increasing speed
        -- and altering dy
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03;
            ball.x = player1.x + 5;

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150);
            else
                ball.dy = math.random(10, 150);
            end

            sounds['paddle_hit']:play();
        end
        
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03;
            ball.x = player2.x - 4;
            
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150);
            else
                ball.dy = math.random(10, 150);
            end
            
            sounds['paddle_hit']:play();
        end
        
    end
    
    -- Detect Screen Border Collisions
    if ball.y <= 0 then
        ball.y = 0;
        ball.dy = -ball.dy;
        sounds['wall_hit']:play();
    end
    
    -- (-4) is the size of the ball
    if ball.y >= virtualHeight - 4 then
        ball.y = virtualHeight - 4;
        ball.dy = -ball.dy;
        sounds['wall_hit']:play();
    end
    
    if ball.x < 0 then
        servingPlayer = 1
        player2Score = player2Score + 1;
        
        if player2Score == 10 then
            ball:reset();
            winningPlayer = 2;
            gameState = 'done';
        else
            gameState = 'serve';
            ball:reset();
        end
        
        sounds['score']:play();
    end
    
    if ball.x > virtualWidth then
        servingPlayer = 2
        player1Score = player1Score + 1;
        
        if player1Score == 10 then
            ball:reset();
            winningPlayer = 1;
            gameState = 'done';
        else
            gameState = 'serve';
            ball:reset();
        end
        
        sounds['score']:play();
    end
    
    -- Player 1 Movement
    if love.keyboard.isDown('w') then
        player1.dy = -paddleSpeed;
    elseif love.keyboard.isDown('s') then
        player1.dy = paddleSpeed;
    else
        player1.dy = 0;
    end

    -- Player 2 Movement
    if love.keyboard.isDown('up') then
        player2.dy = -paddleSpeed;
    elseif love.keyboard.isDown('down') then
        player2.dy = paddleSpeed;
    else
        player2.dy = 0;
    end

    -- Makes the game start and the Ball moves
    if gameState == 'play' then
        ball:update(dt);
    end

    player1:update(dt);
    player2:update(dt);
end

function love.keypressed(key)
    -- Register Single Key Presses
    if key == 'escape' then
        if gameState == 'play' or gameState == 'serve' then
            gameState = 'start'
            player1Score = 0;
            player2Score = 0;
        else
            love.event.quit();
        end
    elseif key == 'enter' or key == 'return' then
        -- Starts and/or Pauses the Game
        if gameState == 'start' then
            gameState = 'serve';
        elseif gameState == 'serve' then
            gameState = 'play';
        elseif gameState == 'done' then
            gameState = 'serve';
            ball:reset();

            -- reset scores to 0
            player1Score = 0;
            player2Score = 0;

            -- Loser Serves
            if winningPlayer == 1 then
                servingPlayer = 2;
            else
                servingPlayer = 1;
            end
        end

        sounds['wall_hit']:play();
    end
end

function love.draw(dt)
    push:start(); -- Starts Push Rendering

    -- Pong Background Color || Clears the screen with a color
    love.graphics.clear(40/255, 45/255, 52/255, 1); -- Color goes from 0 to 1 now
    
    -- Sets the font and Draws the Welcome text
    love.graphics.setFont(pixelFont);
    if gameState == 'start' then
        love.graphics.printf("Welcome to Pong!", 0, 10, virtualWidth, 'center');
        love.graphics.printf("Press enter to Play!", 0, 20, virtualWidth, 'center');
    elseif gameState == 'serve' then
        love.graphics.printf("Player" .. tostring(servingPlayer) .. "'s serve!", 0, 10, virtualWidth, 'center');
    elseif gameState == 'done' then
        love.graphics.setFont(pixelFont);
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!', 0, 10, virtualWidth, 'center');
        love.graphics.setFont(pixelFont);
        love.graphics.printf('Press Enter to restart!', 0, 30, virtualWidth, 'center');
    elseif gameState == 'play' then
        -- Nothing
    end

    -- Display Scores
    displayScores();

    -- Renders the Objects
    player1:render();
    player2:render();
    ball:render();

    -- Displays the FPS
    -- displayFPS();
    
    push:finish(); -- Ends Push Rendering
end

function displayFPS ()
    -- Displays the FPS for Debbugging
    love.graphics.setFont(pixelFont);
    love.graphics.setColor(0, 1, 0, 1);
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10);
end

function displayScores ()
    -- Sets the font and Draws the Scores
    love.graphics.setFont(scoreFont);
    love.graphics.print(tostring(player1Score), virtualWidth/2 - 52, virtualHeight/3); 
    love.graphics.print(tostring(player2Score), virtualWidth/2 + 30, virtualHeight/3); 
end