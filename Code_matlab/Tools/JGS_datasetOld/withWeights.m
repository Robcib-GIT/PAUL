%% Tests with different loads

% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-12-22

% Setup
nValv = 2;

r.ResetVoltagesPositions();
r.OP_mode = 0;
r.CapturePosition();

% Test
for i = 1:4
    r.WriteOneValveMillis(nValv, 200);
    pause(5)
    r.CapturePosition();
    pause(1)
end
pause(1)
for i = 1:4
    r.WriteOneValveMillis(nValv, -100);
    pause(5)
    r.CapturePosition();
    pause(1)
end

posList = r.positions;
save(strcat(string(datetime('now', 'Format', 'yyyy-MM-dd-HH-mm-ss')),'-', 'pos1.mat'), 'posList');