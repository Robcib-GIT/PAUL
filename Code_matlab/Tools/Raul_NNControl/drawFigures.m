%% For Figure experiments, draw real figure and reached figure
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-01-04

% Setup
fig = 1;
rotM = [1 0 0; 0 0 1; 0 -1 0];

switch fig
    % Triangle
    case 1
        load('./Results/1segment-figures/triangulo_2.mat')
        real = [16 96 16
                10 96 -16
                -16 90 0
                16 96 16];
        real = real * rotM';
        start = 4;

        a = [pos_inter_1(1:5,:)
            pos_inter_2(1:4,:)
            pos_inter_3(1:3,:)
            pos_inter_4(1:5,:)];
        a = a * rotM';

    % Square
    case 2
        load('./Results/1segment-figures/cuadrado_2.mat')
        real = [-16 90 19
                16 96 19
                16 96 -19
                -16 90 -19
                -16 90 19];
        real = real * rotM';
        start = 3;

        a = [pos_inter_1(1:3,:)
            pos_inter_2(1:4,:)
            pos_inter_3(1:5,:)
            pos_inter_4(1:3,:)
            pos_inter_5(2:5,:)];
        a = a * rotM';

end

% Plotting
figure
plot3(a(start:end,1),a(start:end,2),a(start:end,3), 'b', 'DisplayName', 'Drawn Figure', 'LineWidth', 1)
grid
hold on
plot3(real(:,1),real(:,2),real(:,3), 'r', 'DisplayName', 'Reference Figure', 'LineWidth', 1)
axis equal
xlabel('x (mm)')
ylabel('y (mm)')
zlabel('z (mm)')
legend()
set(gca, 'TickLabelInterpreter', 'latex')
xtickformat('$%g$')
ytickformat('$%g$')
ztickformat('$%g$')

switch fig
    case 1
        view(-147, 21)
    case 2
        view(-135, 23)
end