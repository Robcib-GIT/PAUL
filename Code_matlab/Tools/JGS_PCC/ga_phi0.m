%% Obtiene con un algoritmo genético el ángulo que está girado nuestro
% sistema de referencia del ideal
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-06-12

global positions2
% positions = [0 0.51133 4.4559 8.3486 11.435 14.435 18.392 21.137 24.321 25.838 29.331 25.001 20.722 16.499 12.513 9.7179 5.8874 4.0814 2.4114 1.3412;
%             0 91.518 92.292 92.829 93.028 93.308 93.216 92.92 92.349 91.831 90.881 92.055 92.819 93.336 93.194 93.217 92.787 92.39 92.104 91.898;
%             0 -0.045486 -5.4276 -10.997 -16.03 -20.471 -24.938 -29.502 -33.5 -37.723 -41.175 -35.059 -28.911 -22.926 -17.658 -13.047 -8.5382 -5.163 -2.6329 -0.90481;
%             0 -1.5407 -1.603 -1.725 -1.7458 -1.6046 -1.8437 -1.6935 -1.6372 -1.6359 -1.3542 -1.6195 -1.7327 -1.6789 -1.8571 -1.9436 -1.8839 -1.4727 -1.7166 -1.7326;
%             0 1.4245 1.4086 1.3809 1.3863 1.3906 1.3889 1.377 1.3746 1.3747 1.3499 1.3712 1.3724 1.3953 1.3754 1.3604 1.3811 1.4067 1.4252 1.4124;
%             0 -1.7662 -1.7643 -1.8267 -1.7631 -1.565 -1.7365 -1.5324 -1.4127 -1.3627 -1.0552 -1.3815 -1.5738 -1.6024 -1.8573 -2.0097 -2.0045 -1.6423 -1.9068 -1.959];

positions2 = r.R * positions(1:3,:);

% Longitud que SÏ que tiene que variar
n = 1;

fun = @(s)fitness_function(s,n);
nvars = 1;
A = [];
b = [];
Aeq = [];
beq = [];
lb = 0;
ub = 2*pi;
nonlcon = [];
options = optimoptions('ga','PlotFcn', @gaplotbestf, 'PopulationSize', 250);
[x,fval,exitflag,output] = ga(fun,nvars,A,b,Aeq,beq,lb,ub,nonlcon,options)

L = zeros(3, size(positions2,2));
for i = 1:size(positions2,2)
    L(:,i) = MCI(positions2(:,i), 40, x);
end

function fitness = fitness_function(phi0, n)
    
    global positions2

    l = zeros(3, size(positions2,2));
    for i = 1:size(positions2,2)
        l(:,i) = MCI(positions2(:,i), 40, phi0);
    end
    
    v = zeros(3,1);
    for i = 1:3
        if i ~= n
            v(i) = var(l(i,2:end));
        end
    end

    fitness = norm(v);
end