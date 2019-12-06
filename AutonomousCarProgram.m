% The autonomous program for the car.

% Resets  medium motor angle to properly lower and raise ramp.
brick.ResetMotorAngle('C');

global key
InitKeyboard();

% The car navigates through the maze until the color Green is detected.
% If the vehicle encounters any issues, hold the [M] key to assume
% manual control.
while isGreen(brick) == 0
    moveForward(brick);
    pause(0.1);
    switch key
        case 0
            navigateMaze(brick);
        case 'm'
            manualControls(brick);
            CloseKeyboard();
            InitKeyboard();
            break;
    end
end

% Once the color Green is detected, the car switches to manual control
% mode so the user is able to pick up the passenger. Press [Q] to resume
% autonomous behavior.
manualControls(brick);
CloseKeyboard();
InitKeyboard();

% The car navigates through the maze until the color Yellow is detected.
% If the vehicle encounters any issues, hold the [M] key to assume
% manual control.
while isYellow(brick) == 0
    moveForward(brick);
    pause(0.1);
    switch key
        case 0
            navigateMaze(brick);
        case 'm'
            manualControls(brick);
            CloseKeyboard();
            break
    end
end

% Once the color Yellow is detected, the car lowers its ramp and moves
% forward to drop off the passenger.
yellowAction(brick);

% End of program.


% Functions defined below.

% Returns 1 if the RGB values recorded by the color sensor are in the
% RGB range for the Green sqaure; returns 0 otherwise.
function result = isGreen(brick)
    brick.SetColorMode(1,4);
    rgb = brick.ColorRGB(1);
    if rgb(1) >= 15&& rgb(1) <= 42 && rgb(2) >= 60 && rgb(2) <= 95 && rgb(3) >= 61 && rgb(3) <= 89
        result = 1;
    else
        result = 0;
    end
end

% Returns 1 if the RGB values recorded by the color sensor are in the
% RGB range for the Yellow square; returns 0 otherwise.
function result = isYellow(brick)
    brick.SetColorMode(1,4);
    rgb = brick.ColorRGB(1);
    if rgb(1) >= 270 && rgb(1) <= 315 && rgb(2) >= 163 && rgb(2) <= 195 && rgb(3) >= 74 && rgb(3) <= 91
        result = 1;
    else
        result = 0;
    end
end

% The car's ramp is lowered and the vehicle moves forward to slide the
% passenger off.
function yellowAction(brick)
    lowerRamp(brick);
    moveForward(brick);
    pause(1);
    stop(brick);
end

% Manual controls for the car.
function manualControls(brick)
    global key
    while 1
        pause(0.1);
        switch key
            case 'w' % Hold [W] to move forwards.
                moveForward(brick);
                
            case 's' % Hold [S] to move backwards.
                reverse(brick);

            case 'a' % Hold [A] to move right.
                turnRight(brick);

            case 'd' % Hold [D] to move left.
                turnLeft(brick);

            case 'r' % Press [R] to raise ramp.
                brick.MoveMotorAngleRel('C', 10, 55, 'Brake');

            case 'f' % Press [F] to lower ramp.
                brick.MoveMotorAngleRel('C', 10, -55, 'Brake');

            case 0 % Press no keys to stop the vehicle.
                stop(brick);

            case 'q'
                break; % Press [Q] to exit the program.
        end   
    end
end

% Autonomous navigation instructions for car.
function navigateMaze(brick)

    % If red is detected below, stop for 2.5 seconds and continue moving
    % afterwards.
    if checkForStop(brick) == 1
        stop(brick);
        pause(2.5);
        while checkForStop(brick) == 1
            moveForward(brick);
        end
    end
    
    % If the front Touch Sensor is pressed, reverse for a bit and then turn
    % 90 degrees to the left.
    if brick.TouchPressed(4)
        reverse(brick);
        pause(2.2);
        turn90Left(brick);
        moveForward(brick);
        pause(1);
        if brick.TouchPressed(4)
            deadEndTurn(brick);
        end
        
    % Turn 90 degrees to the right if the Ultrasonic Sensor detects a 
    % major distance to the right and then move foward whilst checking
    % for the color red to stop.
    elseif brick.UltrasonicDist(2) >= 65
        turn90Right(brick);
        redDetected = 0;
        for i = 1:13
            if checkForStop(brick) == 1
                 redDetected = redDetected + 1;
            end
            if redDetected == 1
                stop(brick);
                pause(2.5);
            end
            moveForward(brick);
            pause(0.1);
        end
        
    % If the Ultrasonic sensor is too close to the left wall, head towards
    % the center of the path.
    elseif brick.UltrasonicDist(2) > 27.6 && brick.UltrasonicDist(2) < 65
        straightenRight(brick);
        
    % If the Ultrasonic sensor is too close to the right wall, head towards
    % the center of the path.
    elseif brick.UltrasonicDist(2) < 12
        straightenLeft(brick);
        
    end
end

% Returns 1 if the Color Sensor detects red; otherwise, 0 is returned.
function result = checkForStop(brick)
    brick.SetColorMode(1,2);
    if brick.ColorCode(1) == 5
        result = 1;
    else
        result = 0;
    end
end

% Lowers the rear ramp.
function lowerRamp(brick)
   brick.MoveMotorAngleRel('C', 10, -55, 'Brake');
end

% Moves vehicle forwards.
function moveForward(brick)
    brick.MoveMotor('A', -53);
    brick.MoveMotor('D', -50);
end

% Moves vehicle backwards.
function reverse(brick)
    brick.MoveMotor('A', 35);
    brick.MoveMotor('D', 36);
end

% Stops vehicle.
function stop(brick)
    brick.StopMotor('AD', 'Coast');
end

% Reverses vehicle until the Ultrasonic Sensor is at a comfortable distance
% from the right wall or 2.8 seconds pass. Then, the car turns left a bit
% and moves forward for 0.4 seconds whilst checking for the color red to
% stop.
function straightenLeft(brick)
    reverse(brick);
    pause(1.8);
    rTime = 0;
    while brick.UltrasonicDist(2) < 19.8
        reverse(brick);
        pause(0.1);
        rTime = rTime + 1;
        if rTime >= 10
            break;
        end
    end
    turnLeft(brick);
    pause(0.4);
    stop(brick);
    redDetected = 0;
    for i = 1:4
            if checkForStop(brick) == 1
                 redDetected = redDetected + 1;
            end
            if redDetected == 1
                stop(brick);
                pause(2.5);
            end
            moveForward(brick);
            pause(0.1);
    end
    stop(brick);
end

% Reverses vehicle until the Ultrasonic Sensor is at a comfortable distance
% from the left wall or 2.8 seconds pass. Then, the car turns right a bit
% and moves forward for 0.4 seconds whilst checking for the color red to
% stop.
function straightenRight(brick)
    reverse(brick);
    pause(1.8);
    rTime = 0;
    while brick.UltrasonicDist(2) > 19.8 && brick.UltrasonicDist(2) < 65
        reverse(brick);
        pause(0.1);
        rTime = rTime + 1;
        if rTime >= 10
            break;
        end
    end
    turnRight(brick);
    pause(0.4);
    stop(brick);
    redDetected = 0;
    for i = 1:4
            if checkForStop(brick) == 1
                 redDetected = redDetected + 1;
            end
            if redDetected == 1
                stop(brick);
                pause(2.5);
            end
            moveForward(brick);
            pause(0.1);
    end
    stop(brick);
end

% Reverses car for a bit and turns it left by 90 degrees.
function deadEndTurn(brick)
    reverse(brick);
    pause(1.3);
    turn90Left(brick);
end

% Turns car left by 90 degreees.
function turn90Left(brick)
    turnLeft(brick);
    pause(2);
    stop(brick);
end

% Turns car left.
function turnLeft(brick)
    brick.MoveMotor('A', -45);
    brick.MoveMotor('D', 0);
end

% Turns car right by 90 degrees.
function turn90Right(brick)
    turnRight(brick);
    pause(2.2);
    stop(brick);
end

% Turns car right.
function turnRight(brick)
    brick.MoveMotor('D', -45);
    brick.MoveMotor('A', 0);
end