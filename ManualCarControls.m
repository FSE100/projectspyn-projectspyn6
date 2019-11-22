global key
InitKeyboard();

while 1
    pause(0.1);
    switch key
        case 'w' % Hold [W] to move forwards.
            brick.MoveMotor('A', -53);
            brick.MoveMotor('D', -50);
            
        case 's' % Hold [S] to move backwards.
            brick.MoveMotor('A', 50);
            brick.MoveMotor('D', 55);
            
        case 'a' % Hold [A] to move right.
            brick.MoveMotor('A', -50);
            brick.MoveMotor('D', 0);
            
        case 'd' % Hold [D] to move left.
            brick.MoveMotor('D', -50);
            brick.MoveMotor('A', 0);
            
        case 'r' % Press [R] to raise ramp.
            brick.MoveMotorAngleRel('C', 10, 55, 'Brake');
            
        case 'f' % Press [F] to lower ramp.
            brick.MoveMotorAngleRel('C', 10, -55, 'Brake');
            
        case 0 % Press no keys to stop the vehicle.
            brick.StopMotor('AD', 'Coast');
            
        case 'q'
            break; % Press [Q] to exit the program.
    end   
end

CloseKeyboard();