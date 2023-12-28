%% Automatic Differentiation Tests
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-12-11

% Example data (replace with your actual data)
inputSize = 1;
outputSize = 3;
numSamples = 1000;

x = 1:1000; % Input data
x = x';
y = [sin(x) cos(x) tan(x)];

% Create the layers of the network
layers = [
    inputLayer(inputSize, 'U')
    fullyConnectedLayer(64)
    reluLayer
    fullyConnectedLayer(64)
    reluLayer
    fullyConnectedLayer(outputSize(1))
    regressionLayer
];

% Create the dlnetwork object
net = dlnetwork(layers);

% Convert input data to dlarray
dlX = dlarray(x);

% Convert output data to dlarray
dlY = dlarray(y);

% Train the network
miniBatchSize = 32;
numEpochs = 10;
learnRate = 0.001;

options = trainingOptions('adam', ...
    'MiniBatchSize', miniBatchSize, ...
    'MaxEpochs', numEpochs, ...
    'InitialLearnRate', learnRate, ...
    'GradientThresholdMethod', 'l2norm', ...
    'Plots', 'training-progress');

% Train the network using trainNetwork function
net = trainNetwork(dlX, dlY, layerGraph(layers), options);