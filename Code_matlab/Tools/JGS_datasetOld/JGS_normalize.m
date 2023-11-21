%% Normalizar el dataset al intervalo [0,1]

% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-01-19

function [data, maxmin] = JGS_normalize(data)

    % Intervalo al que normalizamos
    l = 1;
    u = 0;
    
    % Cogemos los valores máximo y mínimo
    maxmin = zeros(1, 2*size(data, 2));
    for i = 1:size(data, 2)
        maxmin(2*i - 1) = min(data(:,i));
        maxmin(2*i) = max(data(:,i));
        data(:,i) = (data(:,i) - maxmin(2*i - 1)) / (maxmin(2*i) - maxmin(2*i - 1)) * (u - l) + l;
    end

end