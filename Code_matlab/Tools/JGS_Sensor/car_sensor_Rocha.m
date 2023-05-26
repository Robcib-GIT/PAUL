% Trabajo con los datos del sensor bueno basándonos en Rocha2018
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-04-11

close all;
clear;
load('car_sensor.mat')
L = ida_el(503:end);
V = ida(503:end);

% Calculamos la resistencia
I = 5;
R = V/I;
R0 = R(1);

% Calculamos el cambio de resistencia
nu = 0.45;
Rcalc = zeros(size(L));
for i = 1:size(R,2)
    Rcalc(i) = R0 * (1+L(i)) / (1 - nu*L(i))^2;
end

as = 1 * (1 + 1/nu);
Lp = L - as;

figure;
plot(Lp,Rcalc);
hold on;
plot(L,R);
title('\Delta R');
legend('Estimado', 'Real');
