turn90Left(brick);
%turn90Right(brick);
%complete180(brick);
%straightenRight(brick);
stop(brick);
%straightenRight(brick);

function moveForward(brick)
    brick.MoveMotor('A', -53);
    brick.MoveMotor('D', -50);
end

function stop(brick)
    brick.StopMotor('AD', 'Coast');
end

function turn90Left(brick)
    turnLeft(brick);
    pause(1.7);
    stop(brick);
end


function turnLeft(brick)
    brick.MoveMotor('A', -45);
    brick.MoveMotor('D', 0);
end


function turn90Right(brick)
    turnRight(brick);
    pause(1.61);
    stop(brick);
end


function turnRight(brick)
    brick.MoveMotor('D', -45);
    brick.MoveMotor('A', 0);
end

function complete180(brick)
    turnRight(brick);
    pause(4);
    stop(brick);
end

function straightenLeft(brick)
    reverse(brick);
    pause(0.3);
    turnLeft(brick);
    pause(0.3);
    moveForward(brick);
    pause(0.4);
end

function straightenRight(brick)
    reverse(brick);
    pause(0.3);
    turnRight(brick);
    pause(0.3);
    moveForward(brick);
    pause(0.4);
end

function reverse(brick)
    brick.MoveMotor('A', 50);
    brick.MoveMotor('D', 50);
end