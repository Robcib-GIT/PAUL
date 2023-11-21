%% Función objetivo del algoritmo genético para optimizar la red

% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-01-19

function y = JGS_fitness_tr(x)
    global inputs outputs
    net = feedforwardnet(x);
    [~,tr] = train(net, inputs, outputs);
    y = tr.best_perf + tr.best_vperf + tr.best_tperf;
end