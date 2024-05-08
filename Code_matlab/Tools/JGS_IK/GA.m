%% GA
% 
% Genetic Algorithm for the IK of PAUL - Custom code
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-05-08

clear 
close all
if ~exist('r', 'var')
    PAUL_setup();
end
global s
s = r;

%% Setup parameters
times_goal = [0 250 0; 700 0 0; 0 500 350];
goal = r.Plot(times_goal, false);
pNorm = 2;

options.nvars = 9;
A = [];
b = [];
Aeq = [];
beq = [];
options.lb = zeros(1, options.nvars);
options.ub = 1000 * ones(1, options.nvars);
nonlcon = [];
intcon = [];

% Options
options.Display = 'diagnose';
options.MaxGenerations = 20;
options.FitnessLimit = 1;

options.PopulationSize = 50;
options.EliteCount = 1;
options.NParents = floor(options.PopulationSize * 0.2);
options.MutationFraction = 0.7;
options.SelectionFcn = {@selectiontournament, 2};
%options.SelectionFcn = @selectionremainder;
options.CrossoverFcn = @crossoverintermediate;
options.CrossoverFraction = 1;
%options.MutationFcn = @mutationgaussian;
options.MutationFcn = @UniformMutation;

% Auxiliary variables
fitness = zeros(options.PopulationSize, 2);
fitness(:,1) = 1:options.PopulationSize;

%% Running GA

% Generation
individuals = GenerateIndividuals(options);

% Loop
if options.Display == "diagnose"
    t1 = datetime('now');
end
for it = 1:options.MaxGenerations

    % Selection
    if it == 1
        evStart = 1;
    else
        evStart = options.NParents+1;
    end

    for ind = evStart:options.PopulationSize
        fitness(ind,2) = GADistance(individuals(ind,:), goal, pNorm);
    end
    
    % Best individual
    M = min(fitness(:,2));

    if M < options.FitnessLimit
        break
    end

    % For statistics
    a = mean(fitness(:,2));
    
    % Selection
    fitOrd = sortrows(fitness, 2, 'ascend');
    parents = fitOrd(1:options.NParents, 1);
    individuals(1:options.NParents,:) = individuals(parents,:);

    % To not evaluate parents again
    fitness(1:options.NParents,2) = fitOrd(1:options.NParents,2);

    % Crossover and mutation
    for ind = options.NParents:options.PopulationSize

        % Selecting the parents
        p1 = randi([1 options.NParents]);
        p2 = p1;
        while p2 == p1
            p2 = randi([1 options.NParents]);
        end

        % Performing crossover
        individuals(ind,:) = mean([individuals(p1,:); individuals(p2,:)]);

        % Mutation
        q = rand();
        if q < options.MutationFraction 
            individuals(ind,:) = individuals(ind,:) .* randBtw(0.9, 1.1, 1, options.nvars);
        end
    end

    % Statistics
    if options.Display == "diagnose"
        t2 = datetime('now');
        t = seconds(t2-t1);
        disp([it t M a])
        t1 = datetime('now');
    end
    

end

% Best solution
best = find(fitness(:,2) == M, 1);
x = individuals(best,:);

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

%% Aux Functions
% Generation function
function individuals = GenerateIndividuals(options)
    individuals = zeros(options.PopulationSize, options.nvars);
    for ind = 1:size(individuals, 1)
        random_values = rand(1, options.nvars);
        individuals(ind,:) = options.lb + random_values .* (options.ub - options.lb);
    end
end

% Fitness Function
function dist = GADistance(times, xd, pNorm)
    global s
    times = reshape(times, 3, 3);
    p = s.Plot(times, false);
    dist = norm(p - xd, pNorm);
end