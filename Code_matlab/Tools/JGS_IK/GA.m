%% GA
% 
% Genetic Algorithm for the IK of PAUL
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-04-16

clear 
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

% Running GA
x = ga(fun, nvars, A, b, Aeq, beq, lb, ub, nonlcon, intcon, options);

% Final Plotting
figure
subplot(1,2,1)
p = r.Plot(times_goal, true);
subplot(1,2,2)
p = r.Plot(reshape(x,3,3), true);

%% Fitness Function
function dist = GADistance(times, xd)
    global s
    times = reshape(times, 3, 3);
    p = s.Plot(times, false);
    dist = norm(p - xd);
end