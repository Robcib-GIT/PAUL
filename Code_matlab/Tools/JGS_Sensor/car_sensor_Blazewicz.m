%% Trabajo con los datos del sensor bueno basándonos en Bazewicz1997 y
% Porte2021
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

%% Calculamos el coeficiente de strain sensitivity
k = zeros(size(L));
strain = zeros(size(L));
for i = 2:size(k,2)
    strain(i) = (L(i) - L0) / L0;
    k(i) = (R(i) - R0) / R0 / strain(i);
end
f1 = figure;
subplot(1,2,1);
plot(L, k);
title('k');

%% Calculamos el cambio de resistencia
nu = 0.499;
d = zeros(size(L));
dR = zeros(size(L));
for i = 2:size(dR,2)
    d(i) = d0 * (1 + strain(i)^nu);
    dR(i) = (d0/d(i))^2 * (L(i)/L0) - 1;
end

Rp = (R - R0) / R0;

subplot(1,2,2,'Parent', f1);
plot(L, dR);
hold on;
plot(L, Rp);
title('\Delta R');
legend('Estimado', 'Real');

% Figuras
A = dR - Rp;
f2 = figure;
plot(A);