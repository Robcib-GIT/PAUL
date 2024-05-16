%% Train Neural Networks for IK
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-05-13

clear
close all

% Load Data
load('./Tools/JGS_IK/2024-05-13-datasetIK.mat')
x = datasetPos(:,1:18);
t = datasetPos(:,19:27);

% Setup parameters
trainLim = 1800;

% PT Network
npt = feedforwardnet(100);
npt = train(npt, x(1:trainLim,:)', t(1:trainLim,:)');
p = perform(npt,t(trainLim+1:end,:)',npt(x(trainLim+1:end,:)'));