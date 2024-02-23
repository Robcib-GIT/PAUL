%% Comparing different sensors
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-02-07

% Setup
close all
figure
hold on
% Different sensors
load('./Tools/JGS_Sensor/Sensor_Characterization/Results/car_sensor.mat')
plot([ida_el vuelta_el], [ida vuelta], 'b')
load('./Tools/JGS_Sensor/Sensor_Characterization/Results/car_sensor_2.mat')
plot([ida_el vuelta_el], [ida vuelta], 'r')
load('./Tools/JGS_Sensor/Sensor_Characterization/Results/2023-05-19-20.mat')
delta_x = delta_x(delta_x~=-1);
delta_x = delta_x - min(delta_x);
datos = datos(datos~=-1);
% plot(delta_x(525:1018), datos(525:1018));
load('./Tools/JGS_Sensor/Sensor_Characterization/Results/2023-05-19-03.mat')
delta_x = delta_x(delta_x~=-1);
delta_x = delta_x - min(delta_x);
datos = datos(datos~=-1);
plot(delta_x(525:1018), datos(525:1018), 'Color', [0.9290 0.6940 0.1250]);
xlabel('\Delta L (mm)')
ylabel('Voltage (V)')
title('Voltage evolution at the sensor')
load('./Tools/JGS_Sensor/Sensor_Characterization/Results/2023-05-19-12.mat')
delta_x = delta_x(delta_x~=-1);
delta_x = delta_x - min(delta_x);
datos = datos(datos~=-1);
plot(delta_x(525:1018), datos(525:1018), 'Color', [0.4660 0.6740 0.1880]);
xlabel('\Delta L (mm)')
ylabel('Voltage (V)')
title('Voltage evolution at the sensor')
xlim([0 125])
