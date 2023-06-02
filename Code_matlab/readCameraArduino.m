%% Código para mandar al robot a distintas posiciones y, en ellas, leer la
% cámara y los sensores
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-05-16

%% Configuración
clear
close all
r = Robot();
r.Connect();
r.Deflate();
disp('Desinflado')

%% Calibración
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

%% Captura de datos
r.CallibrateCameras();
%r.SetZero();

% Posición inicial
% r.origin = r.CapturePosition();
% r.bottom = r.origin(1,:) + [0 -r.trihDistance 0];
% r.base = r.bottom + [0 -r.segmLength 0];
pos = r.CapturePosition();
x = pos(4,:);
x2 = r.R*x';
[l,params] = MCI(x2, 40);

%% Desconexión
%r.delete(); 