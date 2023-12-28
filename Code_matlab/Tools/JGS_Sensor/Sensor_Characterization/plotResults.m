% Dibujar los resultados de las medidas del sensor con el motor paso a paso
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-05-19

close all

%% Configuración
inicio = 19;
fin = 23;
selectedData = [15, 16, 18, 20, 21, 23];
%selectedData = 1:23;
condsAll = [];
datosAll = [];
deltaAll = [];
legTxt = {};

dirName = 'Results';
resDir = dir(dirName);
files = {resDir.name};

%% Cargamos los resultados que queremos

for i = selectedData
    load(strcat(dirName, '/', files{i+2}));
    condsAll = [condsAll; conds];
    datosAll = [datosAll; datos(datos~=-1)];
    deltaAll = [deltaAll; delta_x(delta_x~=-1)];
    legTxt{end+1} = num2str(conds.temp);
end

%% Dibujado

% Configuración
c = colormap(parula);
mycolors = [c(1,:); c(43,:); c(86,:); c(129,:); c(215,:); c(256,:)];

% Datos
figure;
hold on;
ax1 = gca;
ax1.ColorOrder = mycolors;
for i = 1:size(datosAll, 1)
    plot(datosAll(i,525:1018));
end
leg1 = legend(legTxt, 'Location', 'north');
leg1.Title.String = 'Temperature (ºC)';
xlabel('Motor Steps')
ylabel('Voltage (V)')
title('Voltage evolution at the sensor')

% Histéresis
figure;
hold on;
ax2 = gca;
ax2.ColorOrder = mycolors;
for i = 1:size(datosAll, 1)
    plot(deltaAll(i,525:1018), datosAll(i,525:1018));
end
leg2 = legend(legTxt);
leg2.Title.String = 'Temperature (ºC)';
xlabel('\Delta L (mm)')
ylabel('Voltage (V)')
title('Voltage evolution at the sensor')
