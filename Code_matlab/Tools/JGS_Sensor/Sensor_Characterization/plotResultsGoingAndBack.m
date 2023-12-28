% Dibujar los resultados de las medidas de 1 sensor con el motor paso a paso
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-12-14

close all

%% Configuración
selectedData = 25;
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
end

%% Dibujado

% Histéresis
figure;
hold on;
plot(ida_el, ida, 'b');
plot(vuelta_el(1:260), vuelta(1:260), 'r');
xlabel('\Delta L (mm)')
ylabel('Voltage (V)')
% ylim([1.5 4.5])
% xlim([0 140])
title('Modified Sensor')
legend('Stretching', 'Relaxation')
