%% Evaluating performance of a LSTM net
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-07-22

% Setup
close all
secondTestPrev = true;
max_error = 1;
R = [1 0 0; 0 0 1; 0 -1 0];

% Preparing the data (if second_test has not been executed before)
if ~secondTestPrev
    load('./NN/datos_seg_2_2.mat')
    vol2 = voltage(:,435:end)';
    pos2 = position(:,435:end)';
    muV = mean(vol2);
    sigmaV = std(vol2);
    muP = mean(pos2);
    sigmaP = std(pos2);
    
    vol2 = (vol2 - muV) ./ sigmaV;
    pos2 = (pos2 - muP) ./ sigmaP;
   
    pos3 = {};
    pos3{1} = [0 -77 0; pos2(1,:)]';

    for i = 2:size(pos2)
        pos3{i} = [pos2(i-1,:); pos2(i,:)]';
    end
end

% Evaluating
error = zeros(size(vol2, 1), 1);
res = zeros(size(error, 1), 3);
color = zeros(size(error, 1), 3);

figure
hold on
grid

for i = 1:size(error, 1)
    [~, res(i,:)] = predictAndUpdateState(net, pos3(i)); 
    error(i) = norm(res(i,:) - vol2(i,:));
    color(i,:) =  [0 1 0] + error(i)/max_error * [1 -1 0];

    if error(i) <= max_error
        plot3(pos3{i}(4), pos3{i}(6), -pos3{i}(5), 'Color', color(i,:), 'Marker', 'o')
    end
end