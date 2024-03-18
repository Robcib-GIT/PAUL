  %% CCD
% 
% Cyclic Coordinate Descent Algorithm
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-02-14

close all

if ~exist('r', 'var')
    PAUL_setup();
end
if ~exist('net_op', 'var')
    load('./Tools/JGS_Simulator/net_op.mat')
end

% Setup
maxIt = 50;
tol = 1e-3;
goal = [20 46 -295]; % r.Plot([400 0 100; 200 150 0; 100 100 0])
plotInt = 0;

% For the loop
nSegments = r.nValves / 3;
millis_sent = zeros(maxIt, nSegments, 3);
errHist = zeros(maxIt, 1);
total_millis = zeros(nSegments, 3);

% Algorithm
s = nSegments;
for i = 1:maxIt
    
    % Plotting
    plot(goal(1), goal(2), 'xb', 'MarkerSize', 10)
    xlim([-20 40])
    ylim([-20 20])
    clf
    [p, c1, c2, o2]  = r.Plot(total_millis');
    
    errHist(i) = norm(p - goal);

    if errHist(i) < tol
        break
    end

    if plotInt
        keyboard
    else
        close all
    end

    total_millis(s,:) = zeros(1, r.nValves / 3);

    % Key vectors and their angle
    e = p - c1(s,:);
    g = goal - c1(s,:);
    ang = acos(e * g' / norm(e) / norm(g));
    ax = cross(e, g);
    quat = axang2quat([ax ang]);

    % Rotation
    % Raux = eye(3);
    % for k = 2:s
    %     Raux = Raux * eul2rotm(o2(k,:));
    % end
    % o_goal = Raux \ eul2rotm(o2(s+1,:));
    % newAng = quat .* rotm2quat(o_goal);
    % newAng = quat2eul(newAng);
    newAng = quat2eul(quat);
    p_obj = net_op(newAng');

    % Sending the pressure
    millis_sent(i,s,:) = net_pt(p_obj);
    sum_times = sum(millis_sent);
    total_millis(s,:) = max(sum_times(:,:,s), 0);

    % Loop control
    s = s - 1;
    if ~s
        s = nSegments;
    end

end

disp(errHist)

if ~plotInt
    figure
    [p, c1, c2, o2]  = r.Plot(total_millis);
    hold on
    plot3(goal(1), goal(2), goal(3), 'xb', 'MarkerSize', 10)
end
