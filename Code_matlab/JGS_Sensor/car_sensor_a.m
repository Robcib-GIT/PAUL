% Trabajo con los datos del sensor bueno basándonos en Bazewicz1997 y
% Porte2021
% Optimización de a
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-04-12

close all;
clear;
load('car_sensor.mat')
L = ida_el(503:end);
V = ida(503:end);

% Calculamos la resistencia
I = 5e-6;
R = V/I;
R0 = 2.13e6;
d0 = 2;
L0 = 100;
L = L + L0;
R = (R - R0) / R0;
nu = 0.65;

% Calculamos el cambio de resistencia
error = [];
paso = 0.001;
for a = 0:paso:2
    dR = calcdR_a(L0, L, d0, nu, a);
    % Filtramos
    error = [error; norm(dR - R, 'inf')];
end

% Error mínimo
minError = find(error == min(error));
a = 0.1 + (minError - 1) * paso;
disp(a);
dR = calcdR_a(L0, L, d0, nu, a);
figure;
subplot(1,2,1);
plot(L,dR);
hold on;
plot(L,R);
title('\Delta R');
legend('Estimado', 'Real');
subplot(1,2,2);
plot(0:paso:2, error);
title('Error');