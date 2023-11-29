%% Determinación del espacio de trabajo del robot
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-05-19

close all;

%% Configuración (todo en mm)
L = 80:200;
a = 60;

%% Llamamos a la función
points = [
    getMCD(L, L, 0, a) ...
    getMCD(L, 0, L, a) ...
    getMCD(0, L, L, a)
    ];
plot3(points(1,:), points(2,:), points(3,:), '.');
grid;

%% Funciones auxiliares
function points = getMCD(L1range, L2range, L3range, a)
    % Calcula el MCD para un conjunto de puntos
    %
    % points = getMCD(L1range, L2range, L3range, a) calcula, dado un
    % segmento de radio a, el MCD para todas las combinaciones de
    % longitudes comprendidas en el cubo L1range x L2range x L3range y
    % devuelve un vector en el que cada columna es uno de los puntos de
    % dicho workspace.
    
    points = zeros(3, size(L1range,2) * size(L2range,2) * size(L3range,2));
    num = 0;

    for i = L1range
        for j = L2range
            for k = L3range
                num = num + 1;
                T = MCD([i,j,k], a);
                points(:,num) = T(1:3,4);
            end
        end
    end

end