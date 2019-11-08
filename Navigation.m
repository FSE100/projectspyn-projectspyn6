brick.SetColorMode(1,2); % Color sensor shall return basic colors.
brick.ResetMotorAngle('C'); % Resets motor angle to properly lower and raise ramp.

global key
InitKeyboard();

while true
    switch key
        case 0
            moveForward(brick);
            pause(0.1);
            disp(brick.UltrasonicDist(2))
            navigateMaze(brick);
        case 'q'
            stop(brick);
            break;
    end
end

CloseKeyboard();

function navigateMaze(brick)

    if brick.ColorCode(1) == 5 % Stop the car at a red strip for 3 seconds.
        stop(brick);
        pause(3);
        while brick.ColorCode(1) == 5 % Move car forward until the red strip is not detected.
            pause(0.1);
            moveFoward(brick);
        end
        
    elseif brick.UltrasonicDist(2) > 30 % Turn car right when a major distance to the right is detected.
        turn90Right(brick);
        moveForward(brick);
        pause(0.5);
        
    elseif brick.TouchPressed(4) % Reverse the car for a bit and turn left when the front Touch Sensor is pressed.
        reverse(brick);
        pause(1);
        turn90Left(brick);
        
    elseif brick.UltrasonicDist(2) > 24 && brick.UltrasonicDist(2) < 30
        turnLeft(brick);
        pause(0.3);
    elseif brick.UltrasonicDist(2) < 14
        turnRight(brick);
        pause(0.3);
    end
    
    %{
    if mod(brick.GyroAngle(2),90) > 10 % If the car is 10 degrees off track, a right turn shall be conducted.
        turnLeft();
        pause(0.3);
    elseif mod(brick.GyroAngle(2),90) < -10
        turnRight();
        pause(0.3);
    end
    %}   
end

function raiseRamp(brick)
    brick.MoveMotorAngleAbs('C', 10, 55, 'Brake');
end

function lowerRamp(brick)
   brick.MoveMotorAngleAbs('C', 10, 0, 'Brake');
end

function moveForward(brick)
    brick.MoveMotor('A', -55);
    brick.MoveMotor('D', -50);
end

function reverse(brick)
    brick.MoveMotor('A', 50);
    brick.MoveMotor('D', 50);
end

function stop(brick)
    brick.StopMotor('AD', 'Coast');
end

function turn90Left(brick)
    turnLeft(brick);
    pause(2.2);
    stop(brick);
end

function turnLeft(brick)
    brick.MoveMotor('A', -50);
    brick.MoveMotor('D', 0);
end

function turn90Right(brick)
    turnRight(brick);
    pause(1.8);
    stop(brick);
end

function turnRight(brick)
    brick.MoveMotor('D', -50);
    brick.MoveMotor('A', 0);
end

function complete180(brick)
    turnRight(brick);
    pause(3.7);
    stop(brick);
end