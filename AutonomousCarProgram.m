brick.ResetMotorAngle('C'); % Resets motor angle to properly lower and raise ramp.

global key
InitKeyboard();

while isGreen(brick) == 0 % Navigate through maze until the color Green is detected.
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

% Pick up passenger.
%greenAction();
manualControls(brick);
CloseKeyboard();
InitKeyboard();

while isYellow(brick) == 0 % Navigate through maze until the color Yellow is detected.
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

% Drop off passenger.
%yellowAction(brick);
manualControls(brick);
CloseKeyboard();
% End of program.


% Functions defined below.
function result = isGreen(brick)
    brick.SetColorMode(1,4);
    rgb = brick.ColorRGB(1);
    if rgb(1) >= 15 && rgb(1) <= 60 && rgb(2) >= 40 && rgb(2) <= 115 && rgb(3) >= 20 && rgb(3) <= 110
        result = 1;
    else
        result = 0;
    end
end

function result = isYellow(brick)
    brick.SetColorMode(1,4);
    rgb = brick.ColorRGB(1);
    if rgb(1) >= 270 && rgb(1) <= 315 && rgb(2) >= 163 && rgb(2) <= 195 && rgb(3) >= 74 && rgb(3) <= 86
        result = 1;
    else
        result = 0;
    end
end

function greenAction(brick)
    complete180(brick);
    lowerRamp(brick);
    reverse(brick);
    pause(1);
    raiseRamp(brick);
end

function yellowAction(brick)
    lowerRamp(brick);
    moveForward(brick);
    pause(1);
    raiseRamp(brick);
end

function manualControls(brick)
    global key
    while 1
        pause(0.1);
        switch key
            case 'w' % Hold [W] to move forwards.
                brick.MoveMotor('A', -55);
                brick.MoveMotor('D', -50);

            case 's' % Hold [S] to move backwards.
                brick.MoveMotor('A', 50);
                brick.MoveMotor('D', 50);

            case 'a' % Hold [A] to move right.
                brick.MoveMotor('A', -50);
                brick.MoveMotor('D', 0);

            case 'd' % Hold [D] to move left.
                brick.MoveMotor('D', -50);
                brick.MoveMotor('A', 0);

            case 'r' % Press [R] to raise ramp.
                brick.MoveMotorAngleRel('C', 10, 55, 'Brake');

            case 'f' % Press [F] to lower ramp.
                brick.MoveMotorAngleRel('C', 10, -55, 'Brake');

            case 0 % Press no keys to stop the vehicle.
                brick.StopMotor('AD', 'Coast');

            case 'q'
                break; % Press [Q] to exit the program.
        end   
    end
end

function navigateMaze(brick)
    checkForStop(brick);
       
    if brick.TouchPressed(4) % Reverse the car for a bit and turn left when the front Touch Sensor is pressed.
        reverse(brick);
        pause(2);
        turn90Left(brick);
        moveForward(brick);
        pause(1.3);
        if brick.TouchPressed(4)
            deadEndTurn(brick);
        end
        
    elseif brick.UltrasonicDist(2) >= 65 % Turn car right when a major distance to the right is detected.
        turn90Right(brick);
        moveForward(brick);
        pause(2); 
        
        
    elseif brick.UltrasonicDist(2) > 25.5 && brick.UltrasonicDist(2) < 65
        checkForStop(brick);
        straightenRight(brick);
    elseif brick.UltrasonicDist(2) < 13.5
        checkForStop(brick);
        straightenLeft(brick);
    end
end

function checkForStop(brick)
    if brick.ColorCode(1) == 5 % Stop the car at a red strip for 2.5 seconds.
        stop(brick);
        pause(2.5);
        while brick.ColorCode(1) == 5 % Move car forward until the red strip is not detected.
            pause(0.1);
            moveForward(brick);
        end
    end
end

function raiseRamp(brick)
    brick.MoveMotorAngleAbs('C', 10, 55, 'Brake');
end

function lowerRamp(brick)
   brick.MoveMotorAngleAbs('C', 10, 0, 'Brake');
end

function moveForward(brick)
    brick.MoveMotor('A', -40);
    brick.MoveMotor('D', -35);
end

function reverse(brick)
    brick.MoveMotor('A', 35);
    brick.MoveMotor('D', 35);
end

function stop(brick)
    brick.StopMotor('AD', 'Coast');
end

function straightenLeft(brick)
    reverse(brick);
    pause(0.7);
    turnLeft(brick);
    pause(0.3);
    moveForward(brick);
    pause(0.7);
end

function straightenRight(brick)
    reverse(brick);
    pause(0.7);
    turnRight(brick);
    pause(0.3);
    moveForward(brick);
    pause(0.7);
end

function deadEndTurn(brick)
    reverse(brick);
    pause(1.2);
    turnLeft(brick);
    pause(1);
    moveForward(brick);
    pause(0.5);
    turnLeft(brick);
    pause(1);
end

function turn90Left(brick)
    turnLeft(brick);
    pause(2);
    stop(brick);
end

function turnLeft(brick)
    brick.MoveMotor('A', -50);
    brick.MoveMotor('D', 0);
end

function turn90Right(brick)
    turnRight(brick);
    pause(1.9);
    stop(brick);
end

function turnRight(brick)
    brick.MoveMotor('D', -50);
    brick.MoveMotor('A', 0);
end

function complete180(brick)
    turnRight(brick);
    pause(4);
    stop(brick);
end