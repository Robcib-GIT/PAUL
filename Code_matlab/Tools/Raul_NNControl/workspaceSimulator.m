%% Get workspace of a simulated robot
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-10-25

close all

% Setup parameters
res = 5;
tol = 3;
r.realMode = 0;

limX = -50:res:50;
limY = 75:res:110;
limZ = -50:res:50;
L = length(limX) * length(limY) * length(limZ);
wksp = zeros(L, 3);
PosList = zeros(L,4);
i = 0;
t1 = datetime('now');
for x = limX
    for y = limY
        for z = limZ
            i = i + 1;
            if ~mod(i,100)
                t2 = datetime('now');
                t = seconds(t2 - t1);
                disp(['Iterations complete: ', num2str(i), ' (', num2str(i/L*100,2) ,'%) - eta: ', num2str(t), 's'])
            end
            [pos_final, error_pos] = r.Move(point);
            PosList(i,:) = [pos_final, error_pos];
            if error_pos <= tol
                wksp(i,:) = [x y z];
            end
        end
    end
end

% Plotting
wksp(~any(wksp,2),:) = [];
plot3(wksp(:,1), wksp(:,2), wksp(:,3), 'x')
grid