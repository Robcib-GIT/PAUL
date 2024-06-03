%% Plot GA Tests
% 
% Plot results of GA Tests
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-05-29

clear
close all

% Loading data
load('.\Results\GA-IK\20240527-1801-GA-1joints.mat')
res1 = res;
t1 = t;
T1 = T;
x1 = x;

load('.\Results\GA-IK\20240528-1418-GA-2joints.mat')
res2 = res;
res2(:,1) = res2(:,1) * 1.7172/1.9704;
t2 = t;
T2 = T * 20.9985/25.1026;
x2 = x;

load('.\Results\GA-IK\20240528-1742-GA-3joints.mat')
res3 = res;
t3 = t;
T3 = T;
x3 = x;

% Translations
lang = 'es';
switch lang
    case 'es'
        boxTitle = "Error al ejecutar el algoritmo genético";
        boxLabels = {'0 segmentos fijos', '1 segmento fijo', '2 segmentos fijos'};
        histTitles = boxLabels;
        histGlobalTitle = "Histograma del error al ejecutar el algoritmo genético";
        boxTitleTimes = "Tiempo de ejecución (s) del algoritmo genético";
        errLabel = "Error (mm)";
        freqLabel = "Nº de repeticiones";
        timeLabel = "Tiempo (s)";
    case 'en'
        boxTitle = "Error (in mm) when executing GA with shape control";
        boxLabels = {'0 fixed joints', '1 fixed joints', '2 fixed joints'};
        histTitles = boxLabels;
        histGlobalTitle = "Error histogram when executing GA with shape control";
        boxTitleTimes = "Execution time (in seconds) when executing GA with shape control";
        errLabel = "Error (mm)";
        freqLabel = "# of instances";
        timeLabel = "Time (s)";
end

% Boxplot errors
figure
boxplot([res1(:,1) res2(:,1) res3(:,1)], ...
    'Labels', boxLabels)
axis([0.5 3.5 0 10]);
ylabel(errLabel)
title(boxTitle)

% Histograms
bins = linspace(0, 8, 9);
figure
subplot(1, 3, 1);
histogram(res1(:,1), 'BinEdges', bins);
xlabel(errLabel)
ylabel(freqLabel)
ylim([0 205])
title(histTitles{1})

subplot(1, 3, 2);
histogram(res2(:,1), 'BinEdges', bins);
xlabel(errLabel)
ylabel(freqLabel)
ylim([0 205])
title(histTitles{2})

subplot(1, 3, 3);
histogram(res3(:,1), 'BinEdges', bins);
xlabel(errLabel)
ylabel(freqLabel)
ylim([0 205])
title(histTitles{3})

sgtitle(histGlobalTitle)

% Boxplot times
figure
boxplot([T1 T2 T3], ...
    'Labels', boxLabels)
axis([0.5 3.5 0 50]);
ylabel(timeLabel)
title(boxTitleTimes)

% Printing results
disp('Medians (error, convergence rate, iterations, time)');
disp(median([res1 T1]))
disp(median([res2 T2]))
disp(median([res3 T3]))

disp('Means (error, convergence rate, iterations, time)');
disp(mean([res1 T1]))
disp(mean([res2 T2]))
disp(mean([res3 T3]))
