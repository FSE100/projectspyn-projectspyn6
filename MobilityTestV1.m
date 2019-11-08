brick.GyroCalibrate(3);

global key
InitKeyboard();

while 1
    pause(0.1);
    switch key
        case 'w' % Hold [W] to move forwards.
            brick.MoveMotor('A', -55);
            brick.MoveMotor('D', -50);
        case 's' % Hold [S] to move backwards.
            brick.MoveMotor('A', 50);
            brick.MoveMotor('D', 50);
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
        case 'e' % Press [E] to display color below vehicle.
            brick.SetColorMode(1, 2);
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
        case 'g' % Press [G] to display Red, Green & Blue RGB values.
            brick.SetColorMode(1, 4);
            rgb = brick.ColorRGB(1);
            disp([num2str(rgb(1)) ' ' num2str(rgb(2)) ' ' num2str(rgb(3))])
        case 'x' % Press [X] to display whether the color detected is yellow or green based on RGB input.
            brick.SetColorMode(1,4);
            rgb = brick.ColorRGB(1);
            if rgb(1) >= 380 && rgb(1) <= 430 && rgb(2) >= 250 && rgb(2) <= 290
                disp('Yellow')
            elseif rgb(1) >= 15 && rgb(1) <= 50 && rgb(2) >= 40 && rgb(2) <= 110 && rgb(3) >= 20 && rgb(3) <= 110
                disp('Green')
            else
                disp('The color detected is neither yellow nor green.')
            end
        case 't' % Press [T] to display distance to right.
            disp(brick.UltrasonicDist(2));
        case 'z' % Press [Z] to display angle relative to intial position.
            disp(brick.GyroAngle(3));
        case 0 % Press no keys to stop the vehicle.
            brick.StopMotor('AD', 'Coast');
        case 'q'
            break; % Press [Q] to exit the program.
    end
    
    if brick.TouchPressed(4)
            brick.beep(); % If the touch sensor is pressed, the car shall beep.
    end
    
end

CloseKeyboard();