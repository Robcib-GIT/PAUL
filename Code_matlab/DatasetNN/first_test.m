%% Working with the data of the datasets
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-07-11

% Loading and extracting the real data
load('prueba_3.mat')
vol2 = vol(1:300,:);
pos2 = pos(1:300,:);
t2 = t(1:300,:);
r = Robot;
pos3 = pos2*r.R;

% % Getting theorethical lengths.
% l = zeros(size(pos2));
% for i = 1:size(pos2, 1)
%     l(i,:) = MCI(pos2(i,:));
% end

% Getting state-space model
data = iddata(pos2, vol2, 125);
imp = impulseest(data);
step(imp);
ss = ssest(data);