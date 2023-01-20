%% Entrenamiento Red Neuronal cascada de prueba

% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-01-19

%% Entrenamos la red
load('JGS_datosTodo.mat')
[data.outputs, goodRows] = JGS_filtrarDataset(datosTodo.outputs);
data.inputs = datosTodo.inputs(goodRows, :);

% Datos de entrenamiento
inputs = rescale(data.inputs)';
outputs = rescale(data.outputs)';

% net = cascadeforwardnet([50 50]); % 96 75 69
% net = cascadeforwardnet([20 20 20]); % 93 75 72
net = cascadeforwardnet([50 50 50]); % 94 68 73

% Entrenamiento de la red
[net,tr] = train(net, inputs, outputs);