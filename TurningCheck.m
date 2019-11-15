brick.GyroCalibrate(3); % Calibrate car's position for accurate turning.
brick.GyroAngle(3);

gyroTurn90Left(brick);
%timeTurn90Left(brick);
%timeTurn90Right(brick);
%complete180(brick);

function moveForward(brick)
    brick.MoveMotor('A', -55);
    brick.MoveMotor('D', -50);
end

function stop(brick)
    brick.StopMotor('AD', 'Coast');
end

function gyroTurn90Left(brick)
    turnLeft(brick);
    pause(1.5);
    stop(brick);
    angle = brick.GyroAngle(3);
    disp(angle);
    while mod(angle, 90) < -1 && mod(angle, 90) > 1
        turnLeft(brick);
    end
    stop(brick);
end


function timeTurn90Left(brick)
    turnLeft(brick);
    pause(1.8);
    stop(brick);
end

function turnLeft(brick)
    brick.MoveMotor('A', -50);
    brick.MoveMotor('D', 0);
end

function timeTurn90Right(brick)
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