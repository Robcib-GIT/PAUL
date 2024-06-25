%% GA Video
% 
% Video showing the robot moving continuously
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-06-25

clear 
close all
if ~exist('r', 'var')
    PAUL_setup();
end

% Setup parameters
nFramesPerPoint = 20;
fps = 1;
dateToWrite = string(datetime('now', "Format","yyyyMMdd-HHmm"));

% Loop variables
times_goal = [0 0 0 0 0 0 0 0 0
              randBtw(0, 1000, 4, r.nValves)];
nPoints = size(times_goal, 1);
nFrames = nFramesPerPoint * (nPoints - 1);
goals = zeros(nPoints, 3);
v = zeros(1, size(times_goal, 2));
k = 0;

% Initial Plot
close all
figure
r.Plot([0 0 0; 0 0 0; 0 0 0], true);
[xd0, ~, ~, ~] = r.Plot(reshape(times_goal(2,:), r.nSegments, r.nValvesPerSegment), false);
hold on
plot3(xd0(1), xd0(2), xd0(3), 'xb', 'MarkerSize', 10)
setLegend();
F(1) = getframe(gcf);
F(2:nFrames) = F(1);
close(gcf)

% Genetic Algorithm
for i = 2:nPoints

    % Goal of the current configuration
    [xd, ~, ~, ~] = r.Plot(reshape(times_goal(i,:), r.nSegments, r.nValvesPerSegment), false);
    delta_v = (times_goal(i,:) - times_goal(i-1,:)) / nFramesPerPoint;

    for f = 1:nFramesPerPoint

        k = k + 1;
        
        % Plotting and capturing
        p = r.Plot(reshape(times_goal(i-1,:) + f*delta_v, r.nSegments, r.nValvesPerSegment), true);
        hold on

        % In the last iteration, the x is marked in blue
        if f == nFramesPerPoint
            plotDesired(xd, 'b');
        else
            plotDesired(xd, 'r');
        end
        setLegend();
        F(k+1) = getframe(gcf);
        close(gcf)

    end



    
end

% Video Setup
writerObj = VideoWriter("./Results/GA-IK/" + dateToWrite + "-IK-Video-Intermediate", "MPEG-4");
writerObj.FrameRate = fps;
writerObj.Quality = 100;

% Making Video
open(writerObj);
for f = 1:length(F)
    frame = F(f);
    writeVideo(writerObj, frame);
end
close(writerObj);

%% Auxiliary functions
function setLegend()
    xlim([-200 200])
    ylim([-200 200])
    zlim([-350 0])
end

function plotDesired(goal_c2, color)
    for seg = 1:size(goal_c2, 1)
        % Intermediate markers are different than the final one
        if seg == size(goal_c2, 1)
            marker = 'x';
        else
            marker = 'o';
        end
        if ~any(isnan(goal_c2(seg,:)))
            plot3(goal_c2(seg,1), goal_c2(seg,2), goal_c2(seg,3), ...
                strcat(marker, color), 'MarkerSize', 10)
        end
    end
end