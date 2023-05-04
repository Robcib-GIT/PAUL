%% Modelo PCC en 3D. Basado en Webster2010
%
% Calcula el modelo cinemático directo de un robot de tres cables
% utilizando el método PCC.
%
% T = MCD(l, a) devuelve la matriz de transformación homogénea que permite
% pasar de la base al extremo del robot, conocidas las longtiudes de sus
% cables (l) y el diámetro de la circunferencia que forman (a).
% 
% [T, params] = MCD(l, a) devuelve, además de la matriz de transformación
% homogénea, una estructura con los valores de lr (longitud media), phi
% (orientación) y kappa (curvatura).
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-05-04

function [T, params] = MCD(l, a)  

    %% Comprobaciones iniciales
    if length(l) ~= 3
        error("Introduce un vector de tres longitudes")
    end

    %% Modelado dependiente
    % Caso general
    if ~all(l == l(1))
        lr = mean(l);
        phi = atan2(sqrt(3) * (-2*l(1) + l(2) + l(3)), 3 * (l(2) - l(3)));
        kappa = 2 * sqrt(l(1)^2 + l(2)^2 + l(3)^2 - l(1)*l(2) - l(3)*l(2) - l(1)*l(3)) / a / (l(1) + l(2) + l(3));
    % Posición singular
    else
        lr = l(1);
        phi = 0;
        kappa = 0;
    end

    params.lr = lr;
    params.phi = phi;
    params.kappa = kappa;

    %% Modelado independiente
    if ~all(l == l(1))
        Trot = [cos(phi) -sin(phi) 0 0; sin(phi) cos(phi) 0 0; 0 0 1 0; 0 0 0 1];
        Tarc = [cos(kappa*lr) 0 sin(kappa*lr) (1-cos(kappa*lr))/kappa; 0 1 0 0; -sin(kappa*lr) 0 cos(kappa*lr) sin(kappa*lr)/kappa; 0 0 0 1];
        T = Trot*Tarc;
    else
        T = [1 0 0 0; 0 1 0 0; 0 0 1 lr; 0 0 0 1];
    end

end