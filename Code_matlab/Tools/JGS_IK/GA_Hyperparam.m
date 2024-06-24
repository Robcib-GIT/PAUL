%% GA Hyperarmeter
% 
% Hyperparemeter Tunning of GA
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-06-21

clear 
close all
if ~exist('r', 'var')
    PAUL_setup();
end

% Setup Parameters
nPoints = 2;
nInt = 3;          % Number of intermediate joints to consider (including final tip)
rng(1998)
popList = [25 50 75 100];
parList = [0.1 0.2 0.3];
mutList = [0.7 0.8];

% Loop variables
times_goal = randBtw(0, 1000, nPoints, r.nValves);
goals = zeros(nPoints, 3 * nInt);
t = zeros(nPoints, r.nValves);
x = zeros(nPoints, 3 * nInt);
res = zeros(nPoints, 3);
T = zeros(nPoints, 1);
hypRes = zeros(length(popList) * length(parList) * length(mutList), 7);
k = 0;
dateToWrite = string(datetime('now', "Format","yyyyMMdd-HHmm"));

% Tests
disp(['# of inds ' 'Parent rate ' 'Mutation rate'])
for pop = popList
    for par = parList
        for mut = mutList

            k = k + 1;
            disp([num2str([pop par  mut 100*k/size(hypRes, 1)], 3) '% completed'])

            for i = 1:nPoints

                opt.PopulationSize = pop;
                opt.NParents = floor(opt.PopulationSize * par);
                opt.MutationFraction = mut;
            
                % Generation of goals
                [~, ~, c2, ~] = r.Plot(reshape(times_goal(i,:), r.nSegments, r.nValvesPerSegment), false);
                goals(i,:) = reshape(c2(end-nInt+1:end,:), 1, 3 * nInt);
            
                % Perform GA for each goal
                t1 = datetime('now');
                [t(i,:), x_aux, res_aux] = r.GA(reshape(goals(i,:), nInt, 3), opt);
                t2 = datetime('now');
            
                % Store results
                x(i,:) = reshape(x_aux(end-nInt+1:end,:), 1, 3 * nInt);
                res(i,:) = [res_aux.error res_aux.conv res_aux.it];
                T(i) = seconds(t2 - t1);

            end

            hypRes(k,:) = [pop par mut median(res) median(T)];
            save("./Results/GA-IK/" + dateToWrite + "-GA-Hyper.mat", 'hypRes');

        end
    end
end
