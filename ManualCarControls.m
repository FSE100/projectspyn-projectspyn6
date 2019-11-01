global key
InitKeyboard();

brick.SetColorMode(1,2);
brick.GyroCalibrate(2);
brick.ResetMotorAngle('C'); % Resets motor angle to properly lower and raise forklift.

exit = false;
while exit == false
    if brick.TouchPressed(4)
        brick.beep(); % If the touch sensor is pressed, the car shall beep.
    end
    while 1
        switch key
            case 'w' % Hold [W] to move forwards.
                brick.MoveMotor('DA', 50);
            case 's' % Hold [S] to move backwards.
                brick.MoveMotor('DA', -50);
            case 'a' % Hold [A] to move right.
                brick.MoveMotor('A', 50);
                brick.StopMotor('D', 'Coast');
                % brick.MoveMotor('B', 5); << This might be better.
            case 'd' % Hold [D] to move left.
                brick.MoveMotor('D', 50);
                brick.StopMotor('A', 'Coast');
                % brick.MoveMotor('A', 5); << This might be better.
            case 0 % Press no keys to stop the vehicle.
                brick.StopMotor('DA', 'Coast');
            case 'spacebar' % Press spacebar to lower or raise ramp based on its current position.
                if brick.GetMotorAngle('C') == 0
                    brick.MoveMotorAngleAbs('C', 10, 90, 'Brake');
                else
                    brick.MoveMotorAngleAbs('C', 10, 0, 'Brake');
                end
            case 'e' % Press [E] to display distance to right.
                display(brick.UltrasonicDist(1));
            case 'r' % Press [R] to display rotation of vehicle relative to its initial position.
                display(brick.GyroAngle(2));
            case 'f' % Press [F] to display color below vehicle.
                color = brick.ColorCode(1);
                switch color
                    case 0
                        disp('Unknown Color');
                    case 1
                        disp('Black');
                    case 2
                        disp('Blue');
                    case 3
                        disp('Green');
                    case 4
                        disp('Yellow');
                    case 5
                        disp('Red');
                    case 6
                        disp('White');
                    case 7
                        disp('Brown');
                end
            case 'q'
                exit = true;
                break; % Press [Q] to exit the program.
        end
    end
end

CloseKeyboard();