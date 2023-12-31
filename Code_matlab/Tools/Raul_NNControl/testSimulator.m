%% Tests with the simulator
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-10-25

close all

% Target
point = pos(12,:);

% Movement
[pos_final, error_pos, pos_inter] = r.Move(point, true)
disp(point)

% Plotting
pos_inter(~any(pos_inter,2),:) = [];
figure
plot3(pos_inter(:,1),pos_inter(:,2),pos_inter(:,3),'-');
hold on
plot3(pos_inter(1,1),pos_inter(1,2),pos_inter(1,3),'xr')
plot3(pos_inter(end,1),pos_inter(end,2),pos_inter(end,3),'xg')
grid