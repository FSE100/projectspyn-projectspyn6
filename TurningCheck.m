%turn90Left(brick);
%turn90Right(brick);
%complete180(brick);

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