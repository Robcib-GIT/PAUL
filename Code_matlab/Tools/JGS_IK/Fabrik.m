%% Fabrik
% 
% FABRIK Algorithm
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-05-21

close all
clear

if ~exist('r', 'var')
    PAUL_setup();
end
if ~exist('net_op', 'var')
    load('./Tools/JGS_Simulator/net_op.mat')
end

% Setup
maxIt = 20;
tol = 1e-3;
times_goal = [0 250 0; 700 0 0; 0 500 350];
[goal, c1, c2] = r.Plot(times_goal);
plotInt = false;

% For the loop
nSegments = r.nValves / 3;
millis_sent = zeros(maxIt, nSegments, 3);
errHist = zeros(maxIt, 1);
total_millis = zeros(nSegments, 3);
randomize = false;

% Algorithm
s = nSegments;
for k = 1:maxIt
    
    % Checking if we have arrived
    if difa < tol
        break
    end

    % STAGE 1: FORWARD REACHING
    % Set the end effector pn as target t
    c2(nSegments,:) = goal;
    for i=nSegments-1:-1:1
        % Find the distance ri between the new joint position
        % pi+1 and the joint pi
        r = norm(c2(i+1,:) - c2(i,:), "fro");
        lambda_ = d(i) / r;
        % Find the new joint positions pi.
        c2(i,:) = (1 - lambda_) * c2(i+1,:) + lambda_ * c2(i,:);
    end

    % STAGE 2: BACKWARD REACHING
    % Set the root p1 its initial position.
    c2(1,:) = b;
    for i=1:nSegments-1
        % % Find the distance ri between the new joint
        % position pi
        r = norm(c2(i+1,:) - c2(i,:), "fro");
        lambda_ = d(i) / r;
        % Find the new joint positions pi.
        c2(i+1,:) = (1 - lambda_) * c2(i,:) + lambda_ * c2(i+1,:);
    end
    difa = norm(c2(nSegments,:) - goal);
end