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
maxIt = 20;
tol = 1e-3;
times_goal = [0 250 0; 700 0 0; 0 500 350];
goal = r.Plot(times_goal);
plotInt = false;

% For the loop
nSegments = r.nValves / 3;
millis_sent = zeros(maxIt, nSegments, 3);
errHist = zeros(maxIt, 1);
total_millis = zeros(nSegments, 3);

% Algorithm
s = nSegments;
for i = 1:maxIt
    
    % Plotting
    if plotInt
        figure
    end
    [p, c1, c2, o2]  = r.Plot(total_millis, plotInt);
    
    errHist(i) = norm(p - goal);

    if errHist(i) < tol
        break
    end

    if plotInt
        hold on
        plot3(goal(1), goal(2), goal(3), 'xb', 'MarkerSize', 10)
        keyboard
    end

    total_millis(s,:) = zeros(1, r.nValves / 3);

    % Key vectors and their angle
    e = p - c1(s,:);
    g = goal - c1(s,:);
    ang = acos(e * g' / norm(e) / norm(g));
    ax = cross(e, g);
    quat = axang2quat([ax ang]);

    % Rotation
    newAng = quat2eul(quat);
    p_obj = net_op(newAng');

    % Sending the pressure

    millis_sent(i,:,s) = net_pt(p_obj);
    sum_times = sum(millis_sent);
    total_millis(s,:) = sum_times(:,:,s);

    % millis_sent(i,:,s) = min(net_pt(p_obj), r.max_millis);
    % while 1
    %     sum_times = sum(millis_sent);
    % 
    %     if any(sum_times(:,:,s) > r.max_millis) || any(sum_times(:,:,s) < 0)
    %         diffMax = sum_times(:,:,s) - r.max_millis * ones(size(sum_times(:,:,s)));
    %         diffMin = sum_times(:,:,s) - zeros(size(sum_times(:,:,s)));
    %         millis_sent(i,:,s) = millis_sent(i,:,s) - max(0, diffMax) - min(0, diffMin);
    %     else
    %         break
    %     end
    % end

    % millis_sent(i,:,s) = min(net_pt(p_obj), r.max_millis);
    % while 1
    %     sum_times = sum(millis_sent);
    % 
    %     if sum_times(:,:,s) < 0
    %         diffMin = sum_times(:,:,s) - zeros(size(sum_times(:,:,s)));
    %         millis_sent(i,:,s) = millis_sent(i,:,s) - min(0, diffMin);
    %     else
    %         break
    %     end
    % end

    total_millis(s,:) = sum_times(:,:,s);

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
