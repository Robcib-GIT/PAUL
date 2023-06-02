%% Mover el robot, sacar puntos con la cámara, medir y sacar la posición real para el modelo PCC
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-06-01

R = [1 0 0
     0 0 -1
     0 -1 0];

pos = r.CapturePosition()
pos2 = pos - r.origin
a = pos(4,:) - r.base
r.Measure()