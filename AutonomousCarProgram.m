brick.ResetMotorAngle('C'); % Resets  medium motor angle to properly lower 
                            % and raise ramp.

global key
InitKeyboard();

% The car navigates through the maze until the color Green is detected.
% If the vehicle encounters any issues, hold the [M] key to assume
% manual control.
while isGreen(brick) == 0
    switch key
        case 0
            moveForward(brick);
            pause(0.1);
            navigateMaze(brick);
        case 'm'
            manualControls(brick);
            CloseKeyboard();
            InitKeyboard();
    end
end

% Once the color Green is detected, the car switches to manual control
% mode so the user is able to pick up the passenger.
yellowAction();

% The car navigates through the maze until the color Yellow is detected.
% If the vehicle encounters any issues, hold the [M] key to assume
% manual control.
while isYellow(brick) == 0
    switch key
        case 0
            moveForward(brick);
            pause(0.1);
            navigateMaze(brick);
        case 'm'
            manualControls(brick);
            CloseKeyboard();
            InitKeyboard();
    end
end

% Once the color Yellow is detected, the car lowers its ramp and moves
% forward to drop off the passenger.
manualControls(brick);
CloseKeyboard();
% End of program.


% Functions defined below.

% Returns 1 if the RGB values recorded by the color sensor are in the
% RGB range for the Green sqaure; returns 0 otherwise.
function result = isGreen(brick)
    brick.SetColorMode(1,4);
    rgb = brick.ColorRGB(1);
    if rgb(1) >= 15 && rgb(1) <= 60 && rgb(2) >= 40 && rgb(2) <= 115 && rgb(3) >= 20 && rgb(3) <= 110
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
    if rgb(1) >= 270 && rgb(1) <= 315 && rgb(2) >= 163 && rgb(2) <= 195 && rgb(3) >= 74 && rgb(3) <= 86
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
                raiseRamp(brick);

            case 'f' % Press [F] to lower ramp.
                lowerRamp(brick);

            case 0 % Press no keys to stop the vehicle.
                stop(brick);

            case 'q'
                break; % Press [Q] to exit the program.
        end   
    end
end

% Autonomous navigation instructions for car.
function navigateMaze(brick)

    if checkForStop(brick) == 1
        stop(brick);
        pause(2.5);
        while checkForStop(brick) == 1
            moveForward(brick);
        end
    end
    
    if brick.TouchPressed(4) % Reverse the car for a bit and turn left when the front Touch Sensor is pressed.
        reverse(brick);
        pause(2.2);
        turn90Left(brick);
        moveForward(brick);
        pause(1);
        if brick.TouchPressed(4)
            deadEndTurn(brick);
        end
        
    elseif brick.UltrasonicDist(2) >= 65 % Turn car right when a major distance to the right is detected.
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
        
    
    elseif brick.UltrasonicDist(2) > 27.6 && brick.UltrasonicDist(2) < 65
        straightenRight(brick);
    elseif brick.UltrasonicDist(2) < 12
        straightenLeft(brick);
        
    end
end

function result = checkForStop(brick)
    if brick.ColorCode(1) == 5
        result = 1;
    else
        result = 0;
    end
end

function raiseRamp(brick)
    brick.MoveMotorAngleAbs('C', 10, 55, 'Brake');
end

function lowerRamp(brick)
   brick.MoveMotorAngleAbs('C', 10, 0, 'Brake');
end

function moveForward(brick)
    brick.MoveMotor('A', -53); %-39/36
    brick.MoveMotor('D', -50);
end

function reverse(brick)
    brick.MoveMotor('A', 35);
    brick.MoveMotor('D', 36);
end

function stop(brick)
    brick.StopMotor('AD', 'Coast');
end

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

function deadEndTurn(brick)
    reverse(brick);
    pause(1.3);
    turn90Left(brick);
end

function turn90Left(brick)
    turnLeft(brick);
    pause(2);
    stop(brick);
end


function turnLeft(brick)
    brick.MoveMotor('A', -45);
    brick.MoveMotor('D', 0);
end


function turn90Right(brick)
    turnRight(brick);
    pause(1.7);
    stop(brick);
end


function turnRight(brick)
    brick.MoveMotor('D', -45);
    brick.MoveMotor('A', 0);
end