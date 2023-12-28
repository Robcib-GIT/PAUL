%% Gráficas bigote sensor paso a paso
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-07-14

close all;

%% Configuración
inicio = 14;
fin = 23;
selectedData = inicio:fin;
cutoffTemp = 29;
v1 = [];
v2 = [];

dirName = 'Results';
resDir = dir(dirName);
files = {resDir.name};

%% Cargamos los resultados que queremos
for i = selectedData
    load(strcat(dirName, '/', files{i+2}));
    if conds.temp < cutoffTemp
        v1 = [v1 mean(datos(datos~=-1))];
    else
        v2 = [v2 mean(datos(datos~=-1))];
    end
end
groupping = [zeros(length(v1),1); ones(length(v2),1)];

%% Gráfico de cajas
figure;
boxplot([v1';v2'], groupping, 'Labels', {'T < 29ºC','T > 29ºC'});
title('Average sensor voltage at different temperatures')
ylabel('Voltage (V)')