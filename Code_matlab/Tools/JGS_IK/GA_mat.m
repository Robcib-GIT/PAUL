%% GA
% 
% Genetic Algorithm for the IK of PAUL - Matlab library
% https://es.mathworks.com/help/gads/genetic-algorithm-options.html
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-04-16

clear 
close all
if ~exist('r', 'var')
    PAUL_setup();
end
global s
s = r;

% Setup parameters
times_goal = [0 250 0; 700 0 0; 0 500 350];
goal = r.Plot(times_goal, false);
fun = @(x) GADistance(x, goal);

nvars = 9;
A = [];
b = [];
Aeq = [];
beq = [];
lb = zeros(nvars, 1);
ub = 1000 * ones(nvars, 1);
nonlcon = [];
intcon = [];
options = optimoptions('ga');

% Options
options.Display = 'diagnose';
options.MaxGenerations = 20;
options.FitnessLimit = 1;

options.PopulationSize = 50;
options.EliteCount = 1;
options.SelectionFcn = {@selectiontournament, 2};
%options.SelectionFcn = @selectionremainder;
options.CrossoverFcn = @crossoverintermediate;
options.CrossoverFraction = 1;
%options.MutationFcn = @mutationgaussian;
options.MutationFcn = @UniformMutation;

% Running GA
x = ga(fun, nvars, A, b, Aeq, beq, lb, ub, nonlcon, intcon, options);

% Final Plotting
figure
subplot(1,2,1)
p = r.Plot(times_goal, true);
title('Desired')
subplot(1,2,2)
p = r.Plot(reshape(x,3,3), true);
title('GA')

% Final Display
disp('Desired position:')
disp(goal)
disp('Reached position:')
disp(p)
disp('Error:')
disp(norm(p-goal));

%% Fitness Function
function dist = GADistance(times, xd)
    global s
    times = reshape(times, 3, 3);
    p = s.Plot(times, false);
    dist = norm(p - xd);
end
function dist = GADistanceInf(times, xd)
    global s
    times = reshape(times, 3, 3);
    p = s.Plot(times, false);
    dist = norm(p - xd, inf);
end

%% Mutation Function
function mutationChildren = UniformMutation(parents, options, nvars, FitnessFcn, state, thisScore, thisPopulation)
    a = 0.9;
    b = 1.1;
    mutProb = 0.7;
    mutationChildren = thisPopulation;
    for k = 1:size(thisPopulation, 1)
        if thisScore(k) == state.Best
            continue
        end
        r = rand();
        if r < mutProb
            mutationChildren(k,:) = mutationChildren(k,:) .* (b-a) .* rand(size(mutationChildren(k,:))) + a;
        end
    end
end