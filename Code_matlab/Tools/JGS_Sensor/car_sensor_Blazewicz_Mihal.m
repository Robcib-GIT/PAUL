%% Trabajo con los datos del sensor bueno basándonos en Bazewicz1997 y
% cogiendo los distintos modelos de Mihal2017
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
modelo = 1;

%% Calculamos el cambio de resistencia
nu = 0.499;
d = zeros(size(L));
dR = zeros(size(L));
for i = 1:size(dR,2)
    strain(i) = (L(i) - L0) / L0;
    switch modelo
        case 1
            d(i) = d0 * (1 + strain(i)^nu);
        case 2
            d(i) = d0 * (1 + nu*(strain(i)-1) + 1);
        case 3
            d(i) = d0 * (1 - sqrt(nu*(strain(i)^2-1) + 1));
        case 4
            d(i) = d0 * (1 + (nu*(-strain(i)^(-2)-1) + 1)^2);
    end
    dR(i) = (d0/d(i))^2 * (L(i)/L0) - 1;
end

Rp = (R - R0) / R0;

subplot(1,2,1);
plot(L, dR);
hold on;
plot(L, Rp);
title('\Delta R');
legend('Estimado', 'Real');

% Figuras
A = dR - Rp;
subplot(1,2,2);
plot(A);
title('Error');