%% Train Neural Networks
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-01-04

% Load Data
load('../../Results/1segment-NN/DatasetNN/prueba_DEF_BUENA_13.mat')

% PT Network
npt = feedforwardnet(25);
npt = train(npt, pos(1:700,:)', t(1:700,:)');
p = perform(npt,t(701:end,:)',npt(pos(701:end,:)'));

% VT Network
nvt = feedforwardnet(25);
nvt = train(nvt, vol(1:700,:)', t(1:700,:)');
p = perform(nvt,t(701:end,:)',nvt(vol(701:end,:)'));