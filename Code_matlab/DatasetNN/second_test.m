%% Working with the data of the datasets
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-07-20

close all;
clear;

% Setup
dataset = 3;
netType = 2;

% Loading and extracting the real data
switch dataset
    case 1
        load('prueba_BUENA_2.mat')
        vol2 = vol(1:198,:);
        pos2 = pos(1:198,:);
        %t2 = t(1:198,:);
        prueba2 = prueba(1:198,:);
        
        load('prueba_BUENA_3.mat')
        vol2 = [vol2; vol(1:435,:)];
        pos2 = [pos2; pos(1:435,:)];
        %t2 = [t2; t(1:435,:)];
        prueba2 = [prueba2; prueba(1:435,:)];
    case 2
%         load('./NN/datos_seg_2.mat')
%         vol2 = voltage(:,1:434)';
%         pos2 = position(:,1:434)';

        load('./NN/datos_seg_2_2.mat')
        vol2 = voltage(:,435:end)';
        pos2 = position(:,435:end)';

    case 3
        load('prueba_DEF_def.mat')
        vol2 = vol(1:end,:);
        pos2 = pos(1:end,:);
end

% Normalising
muV = mean(vol2);
sigmaV = std(vol2);
muP = mean(pos2);
sigmaP = std(pos2);

vol2 = (vol2 - muV) ./ sigmaV;
pos2 = (pos2 - muP) ./ sigmaP;

if netType == 2
    pos3 = {};
%     pos3{1} = [0 0 0; 0 0 0; pos2(1,:)]';
%     pos3{2} = [0 0 0; pos2(1,:); pos2(2,:)]';
% 
%     for i = 3:size(pos2)
%         pos3{i} = [pos2(i-2,:); pos2(i-1,:); pos2(i,:)]';
%     end
    pos3{1} = [0 -77 0; pos2(1,:)]';

    for i = 2:size(pos2)
        pos3{i} = [pos2(i-1,:); pos2(i,:)]';
    end
end

% Training the net
switch netType
    case 1
        net = feedforwardnet(125);
        net.name = 'PAUL';
        [net, tr] = train(net, pos2(1:end-10,:)', vol2(1:end-10,:)');
    case 2
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
            'MaxEpochs',700, ...
            'MiniBatchSize',50, ...
            'GradientThreshold',1, ...
            'Verbose',false, ...
            'Plots','training-progress');

        net = trainNetwork(pos3(1:end-10)', vol2(1:end-10,:), layers, options);
end

% Results
error = zeros(10,1);
switch netType
    case 1
        for i = 1:10
            res = net(pos2(end - i,:)');
            error(i) = norm(res - vol2(end - i,:));
        end
    case 2
        res =zeros(10,1);
        for i = 1:10
            [~, res] = predictAndUpdateState(net,pos3(end - i)); 
            error(i) = norm(res - vol2(end - i,:));
        end
end           

disp(mean(error))
disp(mean(error)*mean(vol))