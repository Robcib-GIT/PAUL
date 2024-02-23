%% Plot Robot
% 
% Plots the robot
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-11-28

function PlotRobot(times_obj, r)

    % Checking
    if ~isrow(times_obj)
        times_obj = times_obj';
    end

    % Setup
    height = r.geom.height;
    pos = [0 0 0];
    o2 = zeros(3, size(times_obj, 1) + 1);
    c1 = zeros(3, size(times_obj, 1));
    c2 = zeros(size(c1));
    
    % Drawing each segment
    figure
    for seg = 1:size(times_obj, 1)
        [c1(seg), c2(seg), o2(seg)] =  PlotSegment(r, times_obj(seg,:), pos, o2(seg,:));
        pos = c2(seg)' + height * (c2(seg) - c1(seg))' / norm(c2(seg) - c1(seg));
    end

    % Plot settings
    view([0 0])
    xlabel('x')
    ylabel('y')
    zlabel('z')
    grid on
    view(120, 25);

end