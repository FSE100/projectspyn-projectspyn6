brick.GyroCalibrate(3); % Calibrate car's position for accurate turning.

moveForward(brick);
pause(0.1);
turn90Left(brick);
%turn90Right(brick);
%complete180(brick);

function moveForward(brick)
    brick.MoveMotor('A', -55);
    brick.MoveMotor('D', -50);
end

function stop(brick)
    brick.StopMotor('AD', 'Coast');
end

function turn90Left(brick)
    turnLeft(brick);
    pause(0.5);
    stop(brick);
    brick.GyroAngle(3);
    disp(brick.GyroAngle(3));
    while angle > -5 && angle < 5
        turnLeft(brick);
    end
    stop(brick);
end

%{
function turn90Left(brick)
    turnLeft(brick);
    pause(1.8);
    stop(brick);
end
%}

function turnLeft(brick)
    brick.MoveMotor('A', -50);
    brick.MoveMotor('D', 0);
end

function turn90Right(brick)
    turnRight(brick);
    pause(1.62);
    stop(brick);
end

function turnRight(brick)
    brick.MoveMotor('D', -50);
    brick.MoveMotor('A', 0);
end

function complete180(brick)
    turnRight(brick);
    pause(3.15);
    stop(brick);
end