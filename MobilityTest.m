global key
InitKeyboard();

brick.ResetMotorAngle('C'); % Resets motor angle to properly lower and raise forklift.

while 1
    pause(0.1);
    switch key
        case 'w' % Hold [W] to move forwards.
            brick.MoveMotor('DA', 50);
        case 's' % Hold [S] to move backwards.
            brick.MoveMotor('DA', -50);
        case 'a' % Hold [A] to move right.
            brick.MoveMotor('A', 50);
            brick.MoveMotor('D', 0);
        case 'd' % Hold [D] to move left.
            brick.MoveMotor('D', 50);
            brick.MoveMotor('A', 0);
        case 0 % Press no keys to stop the vehicle.
            brick.StopMotor('DA', 'Coast');
        case 'spacebar' % Press spacebar to lower or raise ramp based on its current position.
            if brick.GetMotorAngle('C') == 0
                brick.MoveMotorAngleAbs('C', 10, 90, 'Brake');
            else
                brick.MoveMotorAngleAbs('C', 10, 0, 'Brake');
            end
        case 'q'
            break; % Press [Q] to exit the program.
    end
end

CloseKeyboard();