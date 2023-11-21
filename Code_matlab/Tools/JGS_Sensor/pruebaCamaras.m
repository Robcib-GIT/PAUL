%% Pruebas Cámaras
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-05-30

if ~exist('r','var') || ~isequal(class(r), 'Robot')
    r = Robot();
    r.CallibrateCameras();
end
if ~isgraphics(r.cam.UIAxes_xz)
    figure;
    title('Images captured by the cameras')
    r.cam.UIAxes_yz = subplot(1,2,1);
    title(r.cam.UIAxes_yz,'CAM_YZ');
    r.cam.UIAxes_xz = subplot(1,2,2);
    title(r.cam.UIAxes_xz,'CAM_XZ');
end

ok = 0;

r.Connect();
r.WriteOneValveMillis(1,400);
r.z_offset = 80;

while (ok ~= 'y')
    close all;
    figure;
    title('Images captured by the cameras')
    r.cam.UIAxes_yz = subplot(1,2,1);
    title(r.cam.UIAxes_yz,'CAM_YZ');
    r.cam.UIAxes_xz = subplot(1,2,2);
    title(r.cam.UIAxes_xz,'CAM_XZ');
    pos = r.CapturePosition();
%     disp('¿Otra foto? (y/n)')
%     ok = input(prompt);
end

figure
hold on
plot3(pos(1,1), pos(1,3), -pos(1,2), 'og')
plot3(pos(2,1), pos(2,3), -pos(2,2), 'or')
plot3(pos(3,1), pos(3,3), -pos(3,2), 'ob')
grid
xlim([200 500])
zlim([100 300])
ylim([0 130])
xlabel('x')
ylabel('z')
zlabel('y')
view(84, 31);
