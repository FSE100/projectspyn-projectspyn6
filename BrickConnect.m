% Connects computer to brick.
brick = ConnectBrick('WHEELYS');
brick.playTone(25, 2000, 500);
disp(brick.GetBattLevel())