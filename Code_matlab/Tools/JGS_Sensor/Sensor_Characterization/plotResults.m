%% Dibujar los resultados de las medidas del sensor con el motor paso a paso
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-05-19

close all

%% Configuración
inicio = 19;
fin = 23;
condsAll = [];
datosAll = [];
deltaAll = [];

dirName = 'Results';
resDir = dir(dirName);
files = {resDir.name};

%% Cargamos los resultados que queremos
for i = inicio:fin
    load(strcat(dirName, '/', files{i+2}));
    condsAll = [condsAll; conds];
    datosAll = [datosAll; datos(datos~=-1)];
    deltaAll = [deltaAll; delta_x(delta_x~=-1)];
end

%% Dibujado

% Datos
figure;
hold on;
for i = 1:size(datosAll, 1)
    plot(datosAll(i,525:1018));
end
legend

% Histéresis
figure;
hold on;
for i = 1:size(datosAll, 1)
    plot(deltaAll(i,525:1018), datosAll(i,525:1018));
end
legend