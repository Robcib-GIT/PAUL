%% Relation between voltages and PCC lengths
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-01-19

close all

% Setup
PAUL_setup;
nBladders = 3;
nTimes = 11;
L0 = [90 90 90]';
L = zeros(3, nBladders * nTimes);
V = zeros(3, nBladders * nTimes);

% Movement
it = 0;
for b = 1:nBladders
    inflation = zeros(3, 1);
    inflation(b) = 1;

    for t = 0:nTimes-1

        it = it + 1;

        % Movement
        xv = net_tpv(t * 100 * inflation);
        x = xv(1:3);
        v = xv(4:6);

        % Getting the lengths
        l = r.MCI(r.R * x);

        % Storing
        L(:,it) = l';
        V(:,it) = v;
    end
end

figure
hold on
for k = 2
    %for t = 1:nBladders
    for t = 2
        plot(L(k,(t-1)*nTimes+1:t*nTimes) - L0(t), V(k,(t-1)*nTimes+1:t*nTimes), 'Color', [0 0 1])
    end
end

load('./Tools/JGS_Sensor/Sensor_Characterization/Results/car_sensor.mat')
plot(ida_el, ida, 'Color', [1 0 0])

xlim([0 100])
xlabel('\Delta L (mm)')
ylabel('Voltage (V)')
legend('Outside the sensor', 'In the sensor')
title('Modified sensor')