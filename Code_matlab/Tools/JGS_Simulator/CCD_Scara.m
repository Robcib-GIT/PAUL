  %% CCD
% 
% Cyclic Coordinate Descent Algorithm
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-02-14

close all

if ~exist('r', 'var')
    r = Scara();
end

% Setup
maxIt = 50;
tol = 1;
%goal = [-10 8];
goal = [20 -15];
plotInt = 1;

nSegments = 5;
millis_sent = zeros(maxIt, nSegments, 1);
errHist = zeros(maxIt, 1);
total_millis = zeros(nSegments, 1);

% Algorithm
s = nSegments;
for i = 1:maxIt
    
    clf
    [p, c1, c2, o2]  = r.Plot(total_millis);
    plot(goal(1), goal(2), 'xb', 'MarkerSize', 10)
    xlim([-20 40])
    ylim([-20 20])
    
    errHist(i) = norm(p - goal);

    if errHist(i) < tol
        break
    end

    if plotInt
        keyboard
    else
        close all
    end

    total_millis(s) = 0;

    % Key vectors and their angle
    e = p - c1(s,:);
    g = goal - c1(s,:);
    ang = acos(e * g' / norm(e) / norm(g));
    ax = [0 0 1];
    quat = axang2quat([ax ang]);

    % % Rotation
    % Raux = eye(2);
    % for k = 2:s
    %     Raux = Raux * createRotMatrix(o2(k,:));
    % end
    % o_goal = Raux \ createRotMatrix(ang);
    % o_goal = getAngle(o_goal);
    % % newAng = quat .* axang2quat([ax getAngle(o_goal)]);
    % % newAng = quat2axang(newAng);
    % % newAng = newAng(4);
    % p_obj = r.l * [cos(o_goal) sin(o_goal)];
    p_obj = r.l * [cos(ang) sin(ang)];

    % Sending the pressure
    millis_sent(i,s,:) = wrapTo2Pi(atan2(p_obj(2), p_obj(1)));
    sum_times = sum(millis_sent);
    total_millis(s,:) = sum_times(:,s);
    
    % Loop control
    s = s - 1;
    if s == 0
        s = nSegments;
    end

end

disp(errHist)

if plotInt
    figure
    [p, c1, c2, o2]  = r.Plot(total_millis);
    plot(goal(1), goal(2), 'xb', 'MarkerSize', 10)
    xlim([-20 40])
    ylim([-20 20])
end

function R = createRotMatrix(ang)
    R = [cos(ang) -sin(ang); sin(ang) cos(ang)];
end

function ang = getAngle(RotM)
    ang = wrapTo2Pi(atan2(RotM(2,1), RotM(1,1)));
end
