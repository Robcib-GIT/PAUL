%% Take photos until a valid position is reached
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-06-02


function [pos, pos2, nattemps] = myCapture(robot)
    pos = [-1 -1 -1];
    nattemps = 1;
    while find(pos == [-1 -1 -1])
        [pos, pos2] = robot.CapturePosition();
    end
end