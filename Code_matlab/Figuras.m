%% Cuadrado
N_PUNTOS = 5;

pos_fin = zeros(N_PUNTOS,3);
error_pos = zeros(N_PUNTOS,1);

[pos_fin(1,:), error_pos(1), pos_inter_1] = R.Move_debug([-16, 90, 19]);
[pos_fin(2,:), error_pos(2), pos_inter_2] = R.Move_debug([16, 96, 19]);
[pos_fin(3,:), error_pos(3), pos_inter_3] = R.Move_debug([16, 96, -19]);
[pos_fin(4,:), error_pos(4), pos_inter_4] = R.Move_debug([-16, 91, -19]);
[pos_fin(5,:), error_pos(5), pos_inter_5] = R.Move_debug([-16, 90, 19]);

save("Figuras_robot/cuadrado_3",'error_pos','pos_inter_1','pos_inter_2','pos_inter_3','pos_inter_4','pos_inter_5','pos_fin');


%% Triángulo
% N_PUNTOS = 4;
% 
% pos_fin = zeros(N_PUNTOS,3);
% error_pos = zeros(N_PUNTOS,1);
% 
% [pos_fin(1,:), error_pos(1), pos_inter_1] = R.Move_debug([16, 96, 16]);
% [pos_fin(2,:), error_pos(2), pos_inter_2] = R.Move_debug([16, 96, -16]);
% [pos_fin(3,:), error_pos(3), pos_inter_3] = R.Move_debug([-16, 90, 0]);
% [pos_fin(4,:), error_pos(4), pos_inter_4] = R.Move_debug([16, 96, 16]);
% 
% save("Figuras_robot/triangulo_3",'error_pos','pos_inter_1','pos_inter_2','pos_inter_3','pos_inter_4','pos_fin');


%% Gráficas
% figure

% Cuadrado
% plot3([pos_inter_1(1:3,1);pos_inter_2(1:4,1);pos_inter_3(1:5,1);pos_inter_4(1:15,1);pos_inter_5(1:5,1)],[pos_inter_1(1:3,2);pos_inter_2(1:4,2);pos_inter_3(1:5,2);pos_inter_4(1:15,2);pos_inter_5(1:5,2)],[pos_inter_1(1:3,3);pos_inter_2(1:4,3);pos_inter_3(1:5,3);pos_inter_4(1:15,3);pos_inter_5(1:5,3)])

% Triángulo
% plot3([pos_inter_1(1:5,1);pos_inter_2(1:4,1);pos_inter_3(1:6,1);pos_inter_4(1:5,1)],[pos_inter_1(1:5,2);pos_inter_2(1:4,2);pos_inter_3(1:6,2);pos_inter_4(1:5,2)],[pos_inter_1(1:5,3);pos_inter_2(1:4,3);pos_inter_3(1:6,3);pos_inter_4(1:5,3)])

% figure
% plot3(pos_fin(:,1),pos_fin(:,2),pos_fin(:,3))


















