%% Plot errors
% 
% Jorge F. García-Samartín
% www.gsamartin.es
% 6-02-2024

close all
load('./Results/1segment-results/prueba_no_deflate_bien.mat')

% Setup
maxError = max(error_pos);
pos_fin =  pos_fin * r.R;

% Plotting setup
figure
hold on
grid
axis equal
xlabel('x (mm)')
ylabel('y (mm)')
zlabel('z (mm)')
set(gca, 'TickLabelInterpreter', 'latex')
xtickformat('$%g$')
ytickformat('$%g$')
ztickformat('$%g$')
view([60 52])

% Plot
for i = 1:length(error_pos)
    color = [0 1 0] + error_pos(i)/maxError * [1 -1 0];
    plot3(pos_fin(i,1), pos_fin(i,2), pos_fin(i,3), '.', 'Color', color, 'MarkerSize', 16);
end