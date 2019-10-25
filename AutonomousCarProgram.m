brick.SetColorMode(2,3);
brick.ResetMotorAngle('C'); % Resets motor angle to properly lower and raise forklift.

while brick.ColorCode(3) ~= 3 % Navigate through maze until the color Green is detected.
    navigateMaze();
end



%{ 
When green is detected:
    Complete a 180 degree turn.
    Lower the pickup hook.
    Reverse into passanger, successfully picking them up.
    After the passenger is secured, raise the hook and continue navigating.
%}

while brick.ColorCode(3) ~= 4
    navigateMaze();
end

%{
When yellow is detected:
	Lower the pickup hook.
    Move foward until passenger is off.
    Raise hook and continue navgiating through maze.
%}

while brick.ColorCode(3) ~= 2
    navigateMaze();
end

%{
When blue is detected:
    Move forward a bit.
    Stop motors and program.
%}

function navigateMaze()
    brick.GyroCalibrate(2); % Calibrate car's position for accurate turning.

    if brick.ColorCode(2) == 5 % Stop the car at a red strip for 3 seconds.
        brick.StopMotor('AB', 'Brake');
        pause(3);
        while brick.ColorCode(2) == 5 % Move car forward until the red strip is not detected.
            brick.MoveMotor('AB', 25);
        end
    end        
    
    if brick.UltrasonicDist(1) > 10 % Turn car right when a major distance to the right is detected.
        while mod(brick.GyroAngle(2),90) ~= 0 % Car continues turning until the car is facing 90 degrees from its original position.
            brick.MoveMotor('B', 50);
            brick.StopMotor('A', 'Coast');
            % brick.MoveMotor('A', 5); << This might be better.
        end
            % If Gyro Sensor is inaccurate, turn the vehicle for a
            % certain amount of time instead.
    end
    
    if brick.TouchPressed(4) % Reverse the car for a bit and turn left when the front Touch Sensor is pressed.
        brick.MoveMotor('AB', -25);
        pause(1.5);
        while mod(brick.GyroAngle(2),90) ~= 0 
            brick.MoveMotor('A', 50);
            brick.StopMotor('B', 'Coast');
            % brick.MoveMotor('B', 5); << This might be better.
        end
            % If Gyro Sensor is inaccurate, turn the vehicle for a
            % certain amount of time instead.
    end
    
    if mod(brick.GyroAnle(2),90) > 10 % If the car is 10 degrees off track, a right turn shall be conducted.
        brick.MoveMotor('B', 50);
        brick.StopMotor('A', 'Coast');
        % brick.MoveMotor('A', 5); << This might be better.
        pause(0.3);
    elseif mod(brick.GyroAnle(2),90) < -10
        brick.MoveMotor('A', 50);
        brick.StopMotor('B', 'Coast');
        % brick.MoveMotor('B', 5); << This might be better.
        pause(0.3);
    end
    
    brick.MoveMotor('AB', 50);
    % pause(1); Might wanna add this.
    
end