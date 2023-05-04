%% Entrenamiento Red Neuronal de prueba

% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-01-17

%% Entrenamos la red
load('JGS_datosTodo.mat')
[data.outputs, goodRows] = JGS_filtrarDataset(datosTodo.outputs);
data.inputs = datosTodo.inputs(goodRows, :);

% Datos de entrenamiento
inputs, mI = JGS_normalize(data.inputs);
outputs, mO = JGS_normalize(data.outputs);

% Creación de la red
% net = feedforwardnet([25 25 25]); % 97 75 68
% net = feedforwardnet([50 25 50]); % 95 71 77
% net = feedforwardnet([50 10 25]); % 91 61 66
% net = feedforwardnet([50 25 25]); % 90 66 71
% net = feedforwardnet([25 25 50]); % 87 75 67
% net = feedforwardnet([40 40]); % 93 67 79
% net = feedforwardnet([30 30]); % 89 78 73
net = feedforwardnet([37 70 51]); % 93 59 73

%net = cascadenet(350);

% Entrenamiento de la red
[net,tr] = train(net, inputs, outputs);