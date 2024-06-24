%% GA Video
% 
% Tests of frame control Matlab
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-06-21

clear 
close all
if ~exist('r', 'var')
    PAUL_setup();
end

% Initial Plot
figure
hold on
[~, ~, ~, ~, f1] = r.Plot([0 0 0; 0 0 0; 0 0 0], true);
[~, ~, ~, ~, f2] = r.Plot([0 200 0; 0 0 0; 0 0 0], true);

set(f1, 'Visible', 'off');
xlim([-200 200])
ylim([-200 200])
zlim([-300 0])
F(1) = getframe(gcf);
keyboard;
F(2:4) = F(1);

set(f1, 'Visible', 'on');
set(f2, 'Visible', 'off');
xlim([-200 200])
ylim([-200 200])
zlim([-300 0])
F(5) = getframe(gcf);
F(6:8) = F(5);

% create the video writer with 1 fps
writerObj = VideoWriter('myVideo.avi');
writerObj.FrameRate = 1;
% set the seconds per image
% open the video writer
open(writerObj);
% write the frames to the video
for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;    
    writeVideo(writerObj, frame);
end
% close the writer object
close(writerObj);