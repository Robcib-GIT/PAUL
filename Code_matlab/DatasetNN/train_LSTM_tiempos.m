%% Train LSTM for the times
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-07-22

close all;
clear;

% Loading and extracting the real data
load('prueba6_3.mat')
vol2 = vol(1:300,:);
pos2 = pos(1:300,:);
t2 = prueba(1:300,:);

% Normalising
muV = mean(vol2);
sigmaV = std(vol2);
muP = mean(pos2);
sigmaP = std(pos2);
muT = mean(t2);
sigmaT = std(t2);

vol2 = (vol2 - muV) ./ sigmaV;
pos2 = (pos2 - muP) ./ sigmaP;
t2 = (t2 - muT) ./ sigmaT;


vol3 = {};
vol3{1} = [0 -77 0; vol2(1,:)]';

for i = 2:size(vol2)
    vol3{i} = [vol2(i-1,:); vol2(i,:)]';
end

% Training the net
numFeatures = 3;
numHiddenUnits = 50;
numResponses = 3;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numResponses)
    regressionLayer];

options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'MaxEpochs',4000, ...
    'MiniBatchSize',50, ...
    'GradientThreshold',1, ...
    'Verbose',false, ...
    'Plots','training-progress');

net = trainNetwork(vol3(1:end-10)', t2(1:end-10,:), layers, options);

% Results
error = zeros(10,1);
res =zeros(10,1);
for i = 1:10
    [~, res] = predictAndUpdateState(net,vol3(end - i)); 
    error(i) = norm(res - t2(end - i,:));
end          

disp(mean(error))
disp(mean(error)*mean(prueba))