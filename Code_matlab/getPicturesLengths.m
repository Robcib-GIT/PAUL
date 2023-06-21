%% Getting snapshots for calculating real lengths
% 
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-06-21

f = figure;
for i = 1:20
    r.WriteOneValveMillis(0, 70);
    pause(0.5);
    imshow(snapshot(camObj));
    saveas(f, strcat('./Tools/JGS_Lengths/seg_0/', num2str(i*70), '.png'));
end