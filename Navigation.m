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
    brick.SetColorMode(1,2);
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
    pause(2.2);
    stop(brick);
end


function turnRight(brick)
    brick.MoveMotor('D', -45);
    brick.MoveMotor('A', 0);
end

%GENE
%{
function straightenLeft(brick)
    reverse(brick);
    pause(1.8);
    stop(brick);
    rTime = 0;
    while brick.UltrasonicDist(2) < 10
        reverse(brick);
        pause(0.1);
        rTime = rTime + 1;
        if rTime >= 30
            break;
        end
        moveForward(brick);
        pause(1.5);
        stop(brick);
        break;
    end
    %Normal  Straight
    turnLeft(brick);
    pause(0.4);
    moveForward(brick);
    pause(1.5);
    stop(brick);
end

function straightenRight(brick)
    reverse(brick);
    pause(1);
    stop(brick);
    rTime = 0;
    while brick.UltrasonicDist(2) > 29.6 && brick.UltrasonicDist(2) < 65    %stuck part
        reverse(brick);
        pause(0.1);
        rTime = rTime + 1;  %3 sec
         if rTime >= 30
            break;
         end
        moveForward(brick);
        pause(1.5);
        turnRight(brick);
        pause(1.5);
        stop(brick);
        break;
    end
    turnRight(brick);
    pause(0.2);
    moveForward(brick);
    pause(1.5);
    stop(brick);
end
%}

%CRIS
%{
function straightenLeft(brick)
    reverse(brick);
    pause(1.8);
    if brick.TouchPressed(3)
        stop(brick);
        moveForward(brick);
        pause(1.5);
        turnLeft(brick);
        pause(0.4);
    else
        rTime = 0;
        while brick.UltrasonicDist(2) < 10
            reverse(brick);
            pause(0.1);
            rTime = rTime + 1;
            if rTime >= 30
                break;
            end
        end
        turnLeft(brick);
        pause(0.4);
        moveForward(brick);
        pause(1);
        stop(brick);
    end
end

function straightenRight(brick)
    reverse(brick);
    pause(1.8);
    if brick.TouchPressed(3)
        stop(brick);
        moveForward(brick);
        pause(1.5);
        turnRight(brick);
        pause(0.4);
    else
        rTime = 0;
        while brick.UltrasonicDist(2) < 10
            reverse(brick);
            pause(0.1);
            rTime = rTime + 1;
            if rTime >= 30
                break;
            end
        end
        turnRight(brick);
        pause(0.4);
        moveForward(brick);
        pause(1);
        stop(brick);
    end
end
%}