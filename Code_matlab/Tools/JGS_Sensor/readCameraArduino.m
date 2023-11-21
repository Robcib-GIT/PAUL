%% Code to send the robot to different positions and, at these positions,
% to read the camera and sensors
% 
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-05-16

%% Setup
% clear
% close all
% r = Robot();
% r.Connect();
% r.Deflate();
% disp('Desinflado')

nValv = 2;
timeStep = 100;
nCycles = round(900/timeStep);

%% Callibration
% r.WriteOneValveMillis(0, 400);
% pause(2);
% r.WriteOneValveMillis(0, -400);
% pause(1);
% r.WriteOneValveMillis(1, 400);
% pause(2);
% r.WriteOneValveMillis(1, -400);
% pause(1);
% r.WriteOneValveMillis(2, 400);
% pause(2);
% r.WriteOneValveMillis(2, -400);
% pause(1);

%% Data Capture
%r.CallibrateCameras();

r.ResetVoltagesPositions();
r.Measure();
r.CapturePosition();
for i = 1:nCycles
    r.WriteOneValveMillis(nValv, timeStep);
    pause(1);
    pos = r.CapturePosition();
    pause(2);
    r.Measure();
end
pause(5)
for i = 1:nCycles
    r.WriteOneValveMillis(nValv, -timeStep);
    pause(1);
    r.Measure();
    pos = r.CapturePosition();
end

positions = r.positions;
voltages = r.voltages;

%% Analysis
positions2 = r.R * positions(1:3,:);

l = zeros(size(positions2));
l2 = zeros(size(positions2));
for i = 1:size(positions2,2)
    l(:,i) = MCI(positions2(:,i), r.geom.radius);
    l2(:,i) = MCI(positions2(:,i), r.geom.radius, 5.8428);
end

fileName = "./Tools/JGS_ImagenesMedir/" + strrep(char(datetime), ":", "-") + ".mat";
save(fileName, "voltages", "positions", "l");
disp(fileName + " has been saved")

%% Disconnexion
%r.delete(); 