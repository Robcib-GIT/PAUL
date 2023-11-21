%% PAUL Setup
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-11-15

r = PAUL();
load('./NN/3nets.mat')
r.NN_creation(net_pt, net_vt, net_tpv);