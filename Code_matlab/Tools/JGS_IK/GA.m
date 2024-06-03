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

% Limits
options.nvars = 9;
options.lb = zeros(1, options.nvars);
options.ub = 900 * ones(1, options.nvars);

% Initial Point
current_times = [0 0 0; 0 0 0; 0 0 0];
current_times = times_goal - [0 100 0; 20 0 0; 0 0 0];
current_times = reshape(current_times, [1 options.nvars]);

% Options
options.Display = "diagnose";
options.MaxGenerations = 20;
options.FitnessLimit = 1;
options.PopulationSize = 50;
options.pNorm = 2;
options.NParents = floor(options.PopulationSize * 0.2);
options.CrossoverFraction = 1;
options.MutationFraction = 0.7;

% Auxiliary variables
fitness = zeros(options.PopulationSize, 2);
fitness(:,1) = 1:options.PopulationSize;

%[t, x, res] = r.GA(goal, options)

%% Running GA

if options.Display == "diagnose"
    t_init = datetime('now');
end

% Generation
individuals = GenerateUniform(options);
%individuals = GenerateFromCurrent(options, current_times);

% Loop
if options.Display == "diagnose"
    t_init = datetime('now');
    t1 = datetime('now');
    disp(['Iteration ' 'Time ' 'Best ' 'Average ' ])
end
for it = 1:options.MaxGenerations

    % Selection
    if it == 1
        evStart = 1;
    else
        evStart = options.NParents+1;
    end

    for ind = evStart:options.PopulationSize
        fitness(ind,2) = GADistance(individuals(ind,:), goal, options.pNorm);
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

        % Checking limits
        individuals(ind,:) = max(individuals(ind,:), options.lb);
        individuals(ind,:) = min(individuals(ind,:), options.ub);
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

% Timing
if options.Display == "diagnose"
    t_end = datetime('now');
    disp(['Elapsed time: ', num2str(seconds(t_end - t_init)), ' s'])
end

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
function individuals = GenerateUniform(options)
    individuals = zeros(options.PopulationSize, options.nvars);
    for ind = 1:size(individuals, 1)
        random_values = rand(1, options.nvars);
        individuals(ind,:) = options.lb + random_values .* (options.ub - options.lb);
    end
end

function individuals = GenerateFromCurrent(options, current_times)
    area = max(options.ub - options.lb);
    individuals = zeros(options.PopulationSize, options.nvars);
    ind = options.PopulationSize;
    discarded = 0;
    while ind 
        if discarded >= 2 * options.PopulationSize
            individuals = GenerateUniform(options);
            disp('Generation from current point not working. Switching to Uniform Generation')
            return
        else
            individuals(ind,:) = current_times + 0.3 * area * randn(1,options.nvars);
            if sum(individuals(ind,:) > options.ub) || sum(individuals(ind,:) < options.lb)
                discarded = discarded + 1;
                continue
            end
            ind = ind - 1;
        end
    end
    disp(discarded);
end

% Fitness Function
function dist = GADistance(times, xd, pNorm)
    global s
    times = reshape(times, 3, 3);
    p = s.Plot(times, false);
    dist = norm(p - xd, pNorm);
end
function dist = GADistanceInterm(times, xd, pNorm)
    global s
    alpha = 0.1;
    times = reshape(times, 3, 3);
    [~, ~, c2, ~] = s.Plot(times, false);
    dif = c2 - xd;
    dif = rmmissing(dif);
    dif(1:end-1,:) = dif(1:end-1,:) * alpha;
    dist = vecnorm(dif')';
end