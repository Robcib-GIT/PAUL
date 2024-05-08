%% Astar
% 
% A* Algorithm for the IK of the Scara (tests)
% https://github.com/alexranaldi/A_STAR/blob/master/a_star.m
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-04-17

close all
if ~exist('r', 'var')
    r = Scara();
end

%% Setup
nSegments = 3;
tol = 0.1;
times_goal = deg2rad([30; 60; 45]);
goal = r.Plot(times_goal, false);

%% Individuals
pressures = 0:50:900;
combs = nSegments * (900/50 + 1)^2;
numPoss = combs^nSegments + 1;
inds = zeros(numPoss, 5); % Parent number, segment number and 3 pressures

inds(1,:) = [0 0 0 0 0];

%% Solver

% Boundary and visited nodes list
Q = false(numPoss, 1);
V = false(numPoss, 1);

% Fitness
fitness = NaN(numPoss, 1);

Q(1) = true;
fitness(1) = 0;

iter = 0;
while ~isempty(Q)
    
    % Using the best solution
    [~, ind] = min(fitness);

    % If we have reached an enough good solution
    % if fit < tol
    %     break
    % end

    % Getting data
    seg = inds(ind, 2);

    % Updating the sets
    Q(ind) = false;
    V(ind) = true;
    fitness(ind) = inf;
    
    % Neighbours
    l = 0;
    neighbours = zeros(length(pressures)^3, 5);
    for i = pressures
        for j = pressures
            for k = pressures
                l = l + 1;
                neighbours(l,:) = [ind seg+1 i j k];
            end
        end
    end
    rowsToKeep = any(neighbours == 0, 2);
    neighbours = neighbours(rowsToKeep, :);


end