% Calcula dR basado en Rocha2018
% Optimización de nu
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-04-11

function dR = calcdR(L0, L, d0, nu)
    d = zeros(size(L));
    strain = zeros(size(L));
    dR = zeros(size(L));
    for i = 1:size(dR,2)
        strain(i) = (L(i) - L0) / L0;
        d(i) = d0 * (1 + strain(i)^nu);
        dR(i) = (d0/d(i))^2 * (L(i)/L0) - 1;
    end
end