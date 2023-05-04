% Trabajo con los datos del sensor bueno basándonos en Bazewicz1997 y
% Porte2021
% Optimización de nu
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-04-11

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

% Calculamos el cambio de resistencia
error = [];
for nu = 0.1:0.01:5
    dR = calcdR(L0, L, d0, nu);
    % Filtramos
    error = [error; norm(dR - R, 1)];
end

% Error mínimo
minError = find(error == min(error));
nu = 0.1 + (minError - 1)*0.01;
disp(nu);
dR = calcdR(L0, L, d0, nu);
figure;
subplot(1,2,1);
plot(L,dR);
hold on;
plot(L,R);
title('\Delta R');
legend('Estimado', 'Real');
subplot(1,2,2);
plot(error);
title('Error');