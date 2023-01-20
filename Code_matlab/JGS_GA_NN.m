%% Algoritmo para optimizar la red neuronal

% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-01-19

%% Algoritmo genético

global inputs outputs

% Carga de datos
load('JGS_datosTodo.mat')
[data.outputs, goodRows] = JGS_filtrarDataset(datosTodo.outputs);
data.inputs = datosTodo.inputs(goodRows, :);

% Datos de entrenamiento
inputs = rescale(data.inputs)';
outputs = rescale(data.outputs)';

% Configuración del algoritmo genético
fun = @JGS_fitness_tr;
nvars = 3;
lb = 10 * ones(nvars,1);
ub = 70 * ones(nvars,1);
intcon = 1:nvars;
options = optimoptions("ga", 'MaxGenerations', 10);

% Algoritmo genético
[y, fval] = ga(fun,nvars,[],[],[],[],lb,ub,[],intcon,options);
% 37 70 51