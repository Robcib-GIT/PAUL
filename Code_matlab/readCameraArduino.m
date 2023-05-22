%% Código para mandar al robot a distintas posiciones y, en ellas, leer la
% cámara y los sensores
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-05-16

%% Configuración
r = Robot();
r.Connect();
r.Deflate();

%% Calibración
r.WriteOneValveMillis(0, 400);
pause(2);
r.WriteOneValveMillis(0, -400);
pause(1);
r.WriteOneValveMillis(1, 400);
pause(2);
r.WriteOneValveMillis(1, -400);
pause(1);
r.WriteOneValveMillis(2, 400);
pause(2);
r.WriteOneValveMillis(2, -400);
pause(1);

%% Captura de datos

%% Desconexión
r.delete(); 