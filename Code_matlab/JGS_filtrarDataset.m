%% Eliminar datos defectuosos dataset

% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-01-18

function [dataF, goodRows] = JGS_filtrarDataset(data)
    
    % Definimos los límites de cada variable
    lims = [-200 200;...
        -200 200;...
        -10 40;...
        -0.7 2.1;...
        -0.7 1;...
        -0.7 1];
    
    % Eliminamos las filas fuera de los límites o con -1 en los ángulos
    goodRows = [];
    badRow = false;
    for i = 1:size(data, 1)
        if data(i,4:6) == [-1 -1 -1]
            continue
        end
        for j = 1:size(data, 2)
            if data(i,j) < lims(j,1) || data(i,j) > lims(j, 2)
                badRow = true;
                break
            end
        end
        if ~badRow
            goodRows = [goodRows; i];
        else
            badRow = false;
        end
    end

    dataF = data(goodRows, :);

end