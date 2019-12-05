brick.SetColorMode(1,2); % Color sensor shall return basic colors.

global key
InitKeyboard();

while true
    switch key
        case 0
            moveForward(brick);
            pause(0.1);
            navigateMaze(brick);
        case 'q'
            stop(brick);
            break;
    end
end
CloseKeyboard();


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
        pause(3.5); 
        
    elseif brick.UltrasonicDist(2) >= 65 % Turn car right when a major distance to the right is detected.
        turn90Right(brick);
        moveForward(brick);
        pause(2);
    
    %{
    STRAIGHTENING METHODS
    elseif brick.UltrasonicDist(2) > 27.5 && brick.UltrasonicDist(2) < 65
        checkForStop(brick);
        straightenRight(brick);
    elseif brick.UltrasonicDist(2) < 11.5
        checkForStop(brick);
        straightenLeft(brick);
    %}
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
    brick.MoveMotor('A', -38);
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
    pause(1.6);
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