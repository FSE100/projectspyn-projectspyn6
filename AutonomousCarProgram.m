brick.SetColorMode(1,2); % Color sensor shall return basic colors.
brick.ResetMotorAngle('C'); % Resets motor angle to properly lower and raise ramp.
brick.GyroCalibate(2); % Calibrate car's position for accurate turning.

while brick.ColorCode(3) ~= 3 % Navigate through maze until the color Green is detected.
    pause(0.1);
    navigateMaze(brick);
end

greenAction(); % Pick up passenger.

while brick.ColorCode(3) ~= 4 % Navigate through maze until the color Yellow is detected.
    pause(0.1);
    navigateMaze(brick);
end

yellowAction(); % Drop off passenger.

while brick.ColorCode(3) ~= 2 % Navigate through maze until the color Blue is detected.
    pause(0.1);
    navigateMaze(brick);
end

blueAction(); % Park.

% End of program.
% Functions defined below.

function greenAction
    complete180();
    lowerRamp();
    reverse();
    pause(1);
    raiseRamp();
end

function yellowAction
    lowerRamp();
    moveForward();
    pause(1);
    raiseRamp();
end

function blueAction
    moveForward();
    pause(1);
end

function navigateMaze(brick)

    if brick.ColorCode(2) == 5 % Stop the car at a red strip for 3 seconds.
        stop(brick);
        pause(3);
        while brick.ColorCode(1) == 5 % Move car forward until the red strip is not detected.
            pause(0.1);
            moveFoward(brick);
        end
    end        
    
    if brick.UltrasonicDist(2) > 70 % Turn car right when a major distance to the right is detected.
        turn90Right(brick);
    end
    
    if brick.TouchPressed(4) % Reverse the car for a bit and turn left when the front Touch Sensor is pressed.
        reverse(brick);
        pause(1);
        turn90Left(brick);
    end
    
    if brick.UltrasonicDist(2) > 23
        turnLeft(brick);
        pause(0.3);
    elseif brick.UltrasonicDist(2) < 15
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
    
    moveForward(brick);
    
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
    pause(1.74);
    stop(brick);
end

function turnLeft(brick)
    brick.MoveMotor('D', -50);
    brick.MoveMotor('A', 0);
end

function turn90Right(brick)
    turnRight(brick);
    pause(1.9);
    stop(brick);
end

function turnRight(brick)
    brick.MoveMotor('A', -50);
    brick.MoveMotor('D', 0);
end

function complete180(brick)
    turnLeft(brick);
    pause(3.55);
    stop(brick);
end