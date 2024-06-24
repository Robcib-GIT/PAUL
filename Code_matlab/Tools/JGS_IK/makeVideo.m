%% Make Video
% 
% Make video from previously collected data
% https://es.mathworks.com/help/matlab/ref/videowriter.html
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-06-24

% Video Setup
dateToWrite = string(datetime('now', "Format","yyyyMMdd-HHmm"));
writerObj = VideoWriter("./Results/GA-IK/" + dateToWrite + "-IK-Video-RT", "MPEG-4");
writerObj.FrameRate = fps;
writerObj.Quality = 100;

% Marking video
open(writerObj);
for i = 1:length(F)
    frame = F(i);
    % Making real time
    if ~mod(i,2)
        for k = 1:round(T(i/2))
            writeVideo(writerObj, frame);
        end
    else
        writeVideo(writerObj, frame);
    end
end
close(writerObj);