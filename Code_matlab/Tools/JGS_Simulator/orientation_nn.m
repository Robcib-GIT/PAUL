%% Train network for orientation prediction
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-03-14

load('./results/1segment-NN/DatasetNN/prueba_DEF_BUENA_13.mat')
if ~exist('r', 'var')
    PAUL_setup();
end


% Setup
nData = size(pos,1);
orList = zeros(nData, 3);

% Dataset generation
for p = 1:nData
    [~, ~, o2] = r.PlotSegment(t(p,:));
    orList(p,:) = o2;
end

% Training the network
net_op = feedforwardnet(25);
net_op = train(net_op, orList(1:700,:)', pos(1:700,:)');
p = perform(net_op, pos(701:end,:)', net_op(orList(701:end,:)'));