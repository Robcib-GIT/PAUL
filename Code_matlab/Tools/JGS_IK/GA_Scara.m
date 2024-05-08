%% GA
% 
% Genetic Algorithm for the IK of the Scara (tests)
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-04-16

clear 
if ~exist('r', 'var')
    r = Scara();
end
global s
s = r;

% Setup parameters
times_goal = deg2rad([30; 60; 45]);
goal = r.Plot(times_goal, false);
fun = @(x) GADistance(x, goal);

nvars = 3;
A = [];
b = [];
Aeq = [];
beq = [];
lb = zeros(nvars, 1);
ub = 2*pi * ones(nvars, 1);
nonlcon = [];
intcon = [];
options = optimoptions('ga');

% Options
options.Display = 'diagnose';
options.MaxGenerations = 20;
options.FitnessLimit = 0.1;

% Running GA
x = ga(fun, nvars, A, b, Aeq, beq, lb, ub, nonlcon, intcon, options);

% Final Plotting
figure
subplot(1,2,1)
p = r.Plot(times_goal, true);
subplot(1,2,2)
p = r.Plot(x', true);

%% Fitness Function
function dist = GADistance(times, xd)
    global s
    p = s.Plot(times', false);
    dist = norm(p - xd);
end