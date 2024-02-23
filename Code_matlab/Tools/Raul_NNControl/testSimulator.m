%% Tests with the simulator
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-10-25

close all
clear r
PAUL_setup;

% Target
point = [16 97 30];

% Movement
[pos_final, error_pos, pos_inter, millis_inter] = r.Move(point, true)
disp(point)

% Plotting positions
pos_inter(~any(pos_inter,2),:) = [];
pos_inter = pos_inter * r.R;
figure
plot3(pos_inter(:,1),pos_inter(:,2),pos_inter(:,3),'-');
hold on
plot3(pos_inter(end,1),pos_inter(end,2),pos_inter(end,3), '.r', 'MarkerSize', 20)
plot3(pos_inter(1,1),pos_inter(1,2),pos_inter(1,3), '.g', 'MarkerSize', 20)
grid
axis equal
xlabel('x (mm)')
ylabel('y (mm)')
zlabel('z (mm)')
title('Movement from (0,0,90) to (16,30,97)')
view([35 24])
set(gca, 'TickLabelInterpreter', 'latex')
xtickformat('$%g$')
ytickformat('$%g$')
ztickformat('$%g$')

% Plotting times
figure
hold on
plot(millis_inter(:,1), 'b')
plot(millis_inter(:,2), 'r')
plot(millis_inter(:,3), 'g')
title('Inflation sent to the valves at each iteration of the control loop')
legend('Bladder 1', 'Bladder 2', 'Bladder 3')
xlabel('Iteration')
ylabel('Inflation time (ms)')
xlim([1 10])
ylim([-400 400])
set(gca, 'TickLabelInterpreter', 'latex')
xtickformat('$%g$')
ytickformat('$%g$')