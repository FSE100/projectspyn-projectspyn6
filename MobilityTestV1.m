global key
InitKeyboard();

brick.ResetMotorAngle('C'); % Resets motor angle to properly lower and raise forklift.

while 1 
    pause(0.1);
    switch key
        case 'w' % Hold [W] to move forwards.
            brick.MoveMotor('AD', -100);
        case 's' % Hold [S] to move backwards.
            brick.MoveMotor('AD', 100);
        case 'a' % Hold [A] to move right.
            brick.MoveMotor('A', -100);
            brick.MoveMotor('D', 0);
        case 'd' % Hold [D] to move left.
            brick.MoveMotor('D', -100);
            brick.MoveMotor('A', 0);
        case 0 % Press no keys to stop the vehicle.
            brick.StopMotor('AD', 'Coast');
        case 'e' % Press e to lower or raise ramp based on its current position.
            if brick.GetMotorAngle('C') >= 54 && brick.GetMotorAngle('C') <= 56
                brick.MoveMotorAngleAbs('C', 10, 0, 'Brake');
            else
                brick.MoveMotorAngleAbs('C', 10, 55, 'Brake');
            end
        case 'f' % Fix forklift angle function
            brick.MoveMotorAngleRel('C', 10, -55, 'Brake');
        case 'q'
            break; % Press [Q] to exit the program.
    end
end

CloseKeyboard();