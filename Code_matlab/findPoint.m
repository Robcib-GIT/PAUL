function point = findPoint(rgb,color, camera, debug)
    
    if nargin < 4
        debug = 'x';
    end

    switch color
        case 'b'   
            if camera == "yz"
                [BW, ~] = imageThresholdBlue_yz(rgb);
            else
                [BW, ~] = imageThresholdBlue_xz(rgb);
            end
        case 'p'
            [BW, ~] = imageThresholdPurple(rgb);
        case 'g'
            if camera == "yz"
                [BW, ~] = imageThresholdGreen_yz(rgb);
            else
                [BW, ~] = imageThresholdGreen_xz(rgb);
            end
        case 'o'
            if camera == "yz"
                [BW, ~] = imageThresholdOrange_yz(rgb);
            else
                [BW, ~] = imageThresholdOrange_xz(rgb);
            end
        case 'n'
            [BW, ~] = imageThresholdBlack(rgb);
    end

    % Detectamos las regiones
    [misRegiones,mserCC] = detectMSERFeatures(BW);
    
    % Filtramos por excentricidad
    stats = regionprops('table',mserCC,'Eccentricity');
    eccentricityIdx = stats.Eccentricity < 0.99;
    misRegiones = misRegiones(eccentricityIdx);

    % Comprobamos numero de regiones detectadas
    if misRegiones.Count > 0

        x = misRegiones.Location(1,1);
        y = misRegiones.Location(1,2);

    else
        

        x = -1;
        y = -1;

    end
 
    if debug == 'y'
        figure;
        
        imshow(rgb);
        pause(0.2);
        imshow(BW);
        hold on;
        pause(0.2);
        plot(misRegiones);
        text(x,y, color);
        pause(0.2) 
        close();
    end

    point = [x,y];
end

