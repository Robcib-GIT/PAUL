%% Bending tests

% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-12-28

close all

maxIt = 10;
angles = zeros(maxIt,1);
poses = zeros(maxIt,3);
diff = zeros(size(poses));
or = r.net_tpv([0 0 0]');
or = or(1:3)';
r.Move(or)

for i = 1:maxIt
    r.WriteOneValveMillis(2, 100);
    poses_aux = r.CapturePosition();
    poses(i,:) = (r.R * poses_aux(1,1:3)')';
    %diff(i,:) = poses(i,:) - (r.R * or')';
    %angles(i) = acos((poses(i,3) - or(3)) / norm(poses(i,:) - or));
    %angles(i) = atan2(diff(i,3), norm(diff(i,1:2)));
    %angles(i) = acos(poses(i,:) * poses(1,:)' / norm(poses(i,:)) / norm(poses(1,:)));
    angles(i) = atan2(norm(poses(i,1:2) - poses(1,1:2)), -poses(i,3));
end

figure
angles2 = rad2deg(angles);  
plot(linspace(1, 100*maxIt, maxIt), 1.5*angles2);
grid
title('Bending analysis of PAUL segments')
xlabel('Inflated time (ms)')
ylabel('Bending angle (º)')

figure
plot3(poses(:,1),poses(:,2),poses(:,3))
grid
axis equal