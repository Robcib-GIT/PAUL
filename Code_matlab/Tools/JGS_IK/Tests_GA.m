%% GA Tests
% 
% Massive testing of r.GA method
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-05-27

clear 
close all
if ~exist('r', 'var')
    PAUL_setup();
end

% Setup Parameters
nPoints = 300;
nInt = 3;          % Number of intermediate joints to consider (including final tip)
rng(1998)

% Loop variables
times_goal = randBtw(0, 1000, nPoints, r.nValves);
goals = zeros(nPoints, 3 * nInt);
t = zeros(nPoints, r.nValves);
x = zeros(nPoints, 3 * nInt);
res = zeros(nPoints, 3);
T = zeros(nPoints, 1);
dateToWrite = string(datetime('now', "Format","yyyyMMdd-HHmm"));

% Tests
for i = 1:size(times_goal, 1)

    disp(i);

    % Generation of goals
    [~, ~, c2, ~] = r.Plot(reshape(times_goal(i,:), r.nSegments, r.nValvesPerSegment), false);
    goals(i,:) = reshape(c2(end-nInt+1:end,:), 1, 3 * nInt);

    % Perform GA for each goal
    t1 = datetime('now');
    [t(i,:), x_aux, res_aux] = r.GA(reshape(goals(i,:), nInt, 3));
    t2 = datetime('now');

    % Store results
    x(i,:) = reshape(x_aux(end-nInt+1:end,:), 1, 3 * nInt);
    res(i,:) = [res_aux.error res_aux.conv res_aux.it];
    T(i) = seconds(t2 - t1);

    if ~mod(i,10)
        save("./Results/GA-IK/" + dateToWrite + "-GA-" + num2str(nInt) + "joints.mat", 't', 'x', 'res', 'T');
    end
end
