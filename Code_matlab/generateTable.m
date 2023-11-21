%% Generate table from NN Model and evaluate it
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-11-15

%% Setup
close all
minD = 50;
maxD = 1200;
num = 3;
step = round((maxD - minD) / num);
table = zeros([num^3, 6]);
heads = zeros(num);
evSize = 100;
evResults = zeros(evSize, 7);
evResultsI = zeros(evSize, 7);

heads(1) = minD;
for i = 2:num
    heads(i) = heads(i-1) + step;
end

%% Table generation
PAUL_setup;

row = 0;
for i = minD:step:maxD
    for j = minD:step:maxD
        for k = minD:step:maxD
            row = row + 1;
            res = r.net_tpv([i j k]');
            table(row,:) = [i j k res(1:3)'];
        end
    end
end

%% Evaluation
% Direct Kinematics
for i = 1:evSize
    times = minD + (maxD - minD) * rand(3,1);
    resTable = TableKinematics(table, times', 'D');
    resNet = r.net_tpv(times);
    evResults(i,:) = [resTable resNet(1:3)' norm(resTable - resNet(1:3)')];
end

% Inverse Kinematics
maxI = max(table(:,4:6))';
minI = min(table(:,4:6))';
for i = 1:evSize
    poses = minI + (maxI - minI) .* rand(3,1);
    resTable = TableKinematics(table, poses', 'I');
    resNet = r.net_tpv(resTable');
    evResultsI(i,:) = [resTable resNet(1:3)' norm(poses - resNet(1:3))];
end


figure
subplot(1, 2, 1)
disp([mean(evResults(:,7)), median(evResults(:,7)), std(evResults(:,7))])
histogram(evResults(:,7), 10)
title('Error between predicted and achieved positions (Direct Kinematics)')
xlabel('Error (mm)')
ylabel ('% of Ocurrences')
subplot(1, 2, 2)
disp([mean(evResultsI(:,7)), median(evResultsI(:,7)), std(evResultsI(:,7))])
histogram(evResultsI(:,7), 10)
title('Error between desired and achieved positions (Inverse Kinematics)')
xlabel('Error (mm)')
ylabel ('% of Ocurrences')