%% Obtiene el MCI con un algoritmo genético
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-06-02

P = [0 -90 -16];

fun = @(s)fitness_function(s,P);
nvars = 3;
A = [];
b = [];
Aeq = [];
beq = [];
lb = 70*ones(1,3);
ub = 300*ones(1,3);
nonlcon = [];
options = optimoptions('ga','PlotFcn', @gaplotbestf, 'PopulationSize', 250);
[x,fval,exitflag,output] = ga(fun,nvars,A,b,Aeq,beq,lb,ub,nonlcon,options)

function fitness = fitness_function(l, xobj)
    T = MCD(l,40);
    x = T(1:3,4)';
    fitness = norm(x-xobj);
end