%% Código para mandar al robot a distintas posiciones y, en ellas, leer la
% cámara y los sensores
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-05-16

%% Configuración
obj = serialport('COM3', 9600);
millisdesinflar = "w,1,-5000,-5000,-5000,-5000,-5000,-5000,-5000,-5000,-5000";
writeline(obj, millisdesinflar);
k = 1.5;        % Factor de deshinchado
pause(5);

%% Calibración
writeOneValveMillis(obj, 0, 400);
pause(2);
writeOneValveMillis(obj, 0, -k*400);
pause(1);
writeOneValveMillis(obj, 1, 400);
pause(2);
writeOneValveMillis(obj, 1, -k*400);
pause(1);
writeOneValveMillis(obj, 2, 400);
pause(2);
writeOneValveMillis(obj, 2, -k*400);
pause(1);

%% Captura de datos

%% Desconexión
delete(obj);