%% Study length of principal sensor for different values of phi0
%
% Jorge F. García-Samartín
% www.gsamartin.es

load('./Tools/JGS_ImagenesMedir/08-Jun-2023 18-26-46.mat')
[Lmax0, L0] = getMaxLength(positions);

load('./Tools/JGS_ImagenesMedir/09-Jun-2023 13-59-07.mat')
[Lmax1, L1] = getMaxLength(positions);

load('./Tools/JGS_ImagenesMedir/12-Jun-2023 17-07-13.mat')
[Lmax2, L2] = getMaxLength(positions);

disp(max(Lmax0))
disp(max(Lmax1))
disp(max(Lmax2))

function [Lmax, L] = getMaxLength(positions)

    phi0 = pi/2;
    R = [1 0 0;0 0 1;0 -1 0];
    
    positions2 = R * positions(1:3,:);
    
    L = zeros(3, size(positions2,2));
    for i = 1:size(positions2,2)
        L(:,i) = MCI(positions2(:,i), 40, phi0);
    end

    Lmax = max(L);

end