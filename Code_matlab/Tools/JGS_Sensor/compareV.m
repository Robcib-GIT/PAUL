%% Comparing voltages between steps
% 
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-06-13

%% Setup
compVoltages = zeros(7,19);

%% Action
t1 = datetime("now");

% 50ms
r.ResetVoltagesPositions();
r.Measure();
compVoltages(1,1) = r.voltages(end);
for i = 1:18
    r.WriteOneValveMillis(2, 50);
    pause(3);
    r.Measure();
    pause(0.5);
    compVoltages(1,i+1) = r.voltages(end);
end
r.Deflate();
pause(8);

% 100ms
r.ResetVoltagesPositions();
r.Measure();
compVoltages(2,1) = r.voltages(end);
for i = 1:9
    r.WriteOneValveMillis(2, 100);
    pause(3);
    r.Measure();
    pause(0.5);
    compVoltages(2,3*i+1) = r.voltages(end);
end
r.Deflate();
pause(8);

% 300ms + 600ms
r.ResetVoltagesPositions();
r.Measure();
compVoltages(3,1) = r.voltages(end);
r.WriteOneValveMillis(2, 300);
pause(3);
r.Measure();
pause(0.5);
compVoltages(3,7) = r.voltages(end);
r.WriteOneValveMillis(2, 600);
pause(3);
r.Measure();
pause(0.5);
compVoltages(3,19) = r.voltages(end);
r.Deflate();
pause(8);

% 600ms + 300ms
r.ResetVoltagesPositions();
r.Measure();
compVoltages(4,1) = r.voltages(end);
r.WriteOneValveMillis(2, 600);
pause(3);
r.Measure();
pause(0.5);
compVoltages(4,13) = r.voltages(end);
r.WriteOneValveMillis(2, 300);
pause(3);
r.Measure();
pause(0.5);
compVoltages(4,19) = r.voltages(end);
r.Deflate();
pause(8);

% 900ms
r.ResetVoltagesPositions();
r.Measure();
compVoltages(5,1) = r.voltages(end);
r.WriteOneValveMillis(2, 900);
pause(3);
r.Measure();
pause(0.5);
compVoltages(5,19) = r.voltages(end);
r.Deflate();
pause(8);

% 150ms
r.ResetVoltagesPositions();
r.Measure();
compVoltages(2,1) = r.voltages(end);
for i = 1:6
    r.WriteOneValveMillis(2, 150);
    pause(3);
    r.Measure();
    pause(0.5);
    compVoltages(6,3*i+1) = r.voltages(end);
end
r.Deflate();
pause(8);

% 50ms + 100ms
r.ResetVoltagesPositions();
r.Measure();
compVoltages(2,1) = r.voltages(end);
for i = 1:6
    r.WriteOneValveMillis(2, 50);
    pause(3);
    r.Measure();
    pause(0.5);
    compVoltages(7,3*i-1) = r.voltages(end);
    r.WriteOneValveMillis(2, 100);
    pause(3);
    r.Measure();
    pause(0.5);
    compVoltages(7,3*i+1) = r.voltages(end);
end
r.Deflate();
pause(8);

% 300ms
r.ResetVoltagesPositions();
r.Measure();
compVoltages(2,1) = r.voltages(end);
for i = 1:3
    r.WriteOneValveMillis(2, 300);
    pause(3);
    r.Measure();
    pause(0.5);
    compVoltages(8,6*i+1) = r.voltages(end);
end
r.Deflate();
pause(8);

t2 = datetime("now");

disp(t2 - t1)
