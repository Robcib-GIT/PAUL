cam1 = webcam("USB Camera");
%cam2 = webcam(4);


while(1 < 2)
    
    img1 = snapshot(cam1) ;
    %img2 = snapshot(cam2);

    imshow(img1);
    hold on;

    pb = findPoint(img1, 'b', "xz");
    pg= findPoint(img1, 'g', "xz");
    po = findPoint(img1, 'o', "xz");
    
        plot([pb(1) pg(1)], [pb(2) pg(2)], 'r');
        plot([pb(1) po(1)], [pb(2) po(2)], 'r');
        plot([pg(1) po(1)], [pg(2) po(2)], 'r');

    %if xb1 ~= -1 && xg1 ~= -1
   % plot([xb1 xg1], [yb1 yg1], 'g');
    %end
    %if xo1 ~= -1 && xb1 ~= -1
    %plot([xb1 xo1], [yb1 yo1], 'b');
    %end
    %if xo1 ~= -1 && xg1 ~= -1
    %plot([xg1 xo1], [yg1 yo1], 'r');
   % end

    hold off;

    

    





end