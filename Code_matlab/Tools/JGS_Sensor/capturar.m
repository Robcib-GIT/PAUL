%% Capturar rápidamente una posición y mostrarla
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-05-30

close all;
figure;
title('Images captured by the cameras')
r.cam.UIAxes_yz = subplot(1,2,1);
title(r.cam.UIAxes_yz,'CAM_YZ');
r.cam.UIAxes_xz = subplot(1,2,2);
title(r.cam.UIAxes_xz,'CAM_XZ');
pos = r.CapturePosition();