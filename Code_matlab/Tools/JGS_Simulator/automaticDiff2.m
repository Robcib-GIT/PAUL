%% Automatic Differentiation Tests
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-01-15

% Example data (replace with your actual data)
inputSize = 1;
outputSize = 3;
numSamples = 1000;

inputData = 0:0.01:2*pi; % Input data
inputData = inputData';
targetData = [sin(inputData) cos(inputData)];

% Define the layers of your neural network
layers = [
    featureInputLayer(1)
    fullyConnectedLayer(100)
    reluLayer
    fullyConnectedLayer(2)
];
lGraph = layerGraph(layers);

% Set training options (you can customize this based on your requirements)
options = trainingOptions( ...
    'sgdm',...
    'MaxEpochs', 1000,...
    'ValidationPatience', 10,...
    'Plots', 'training-progress' ...
    );

% Create and rain the neural network
net = dlnetwork(lgraph)
[loss, gradients] = dlfeval(@compute_gradient, net, x);

% Plot results
y = predict(net, inputData);
figure;
plot(y);
disp('Accuracy (%):')
disp(100 - norm(targetData - y) / norm(targetData) * 100)

% Use dlgradient
x = randn(1, 1, 'single');
dlx = dlarray(x, 'SSCB');
dly = predict(net, x);
grad = dlgradient(@(x) predict(net, x), dlx);

% Display the gradients
disp('Gradients:')
disp(grad)