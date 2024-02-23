%% Measure rotation versus time
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-02-19

if ~exist('r', 'var')
    PAUL_setup();
end

% Setup
O2 = zeros(10, 3);

for i = 1:10
    [~, ~, ~, o2]  = r.Plot((i-1) * 100 * [0 0 1]);
    O2(i,:) = o2(end,:);
    close all
end

figure
hold on
plot(O2);