%% GA Video
% 
% Video showing the capabilites of the GA
% https://es.mathworks.com/help/matlab/ref/videowriter.html
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-06-21

clear 
close all
if ~exist('r', 'var')
    PAUL_setup();
end

% Setup parameters
nPoints = 3;
nInt = 3;          % Number of intermediate joints to consider (including final tip)
fps = 1;

% Loop variables
times_goal = randBtw(0, 1000, nPoints, r.nValves);
goals = zeros(nPoints, 3 * nInt);
times = zeros(nPoints,  3 * nInt);
T = zeros(nPoints, 1);
dateToWrite = string(datetime('now', "Format","yyyyMMdd-HHmm"));

% Initial Plot
figure
[x0, ~, ~, ~] = r.Plot([0 0 0; 0 0 0; 0 0 0], true);
hold on
plot3(x0(1), x0(2), x0(3), 'xb', 'MarkerSize', 10)
setLegend();
F(1) = getframe(gcf);
F(2:2*nPoints+1) = F(1);

% Genetic Algorithm
for i = 1:size(times_goal, 1)

    disp(i);

    % Generation of goal
    [~, ~, goal_c2, ~] = r.Plot(reshape(times_goal(i,:), r.nSegments, r.nValvesPerSegment), false);
    %goal_c2(1,1) = NaN;
    %goal_c2(2,1) = NaN;
    goals(i,:) = reshape(goal_c2, 1, 3 * nInt);
    plotDesired(goal_c2, 'r');
    F(2*i) = getframe(gcf);
    close(gcf)

    % Perform GA for current goal
    t1 = datetime('now');
    [times(i,:), x_aux, res_aux] = r.GA(goal_c2);
    t2 = datetime('now');

    % Plot
    figure
    [p, ~, ~, ~] = r.Plot(reshape(times(i,:), r.nSegments, r.nValvesPerSegment), true);
    hold on
    plotDesired(goal_c2, 'b');
    setLegend()
    F(2*i+1) = getframe(gcf);

    % Store results
    T(i) = seconds(t2 - t1);
end

% Video Setup
writerObj = VideoWriter("./Results/GA-IK/" + dateToWrite + "-IK-Video", "MPEG-4");
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