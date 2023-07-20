% MAX_MILLIS = 1000;
% N_ITER_MAX = 1000;
% SAVE = 100;
% 
% pos = zeros(N_ITER_MAX,3);
% vol = zeros(N_ITER_MAX,3);
% t = zeros(N_ITER_MAX,3);
% suma = zeros(1,3);
% millis_ant = [0 0 0];
% 
% prueba = zeros(N_ITER_MAX,3);

% R.Calibrate();

R.WriteSegmentMillis(prueba(590,:));
suma = prueba(590,:);

for i = 591:N_ITER_MAX
   
    while 1

        t(i,:) = -MAX_MILLIS -50 + 50*randi(fix((2*MAX_MILLIS/50 + 1)), [1 3]);
    
        if i == 1
            suma = t(i,:);
        else
            suma = suma + t(i,:);
        end
    
        for j = 1:3
            if suma(j) < 0
                suma(j) = 0;
            end 
        end
    
        index = find(suma > MAX_MILLIS);
    
        if ~isempty(index)
            suma(1,index) = suma(1,index) - t(i,index);
            t(i,index) = 0;
        end
    
        indice = find(t(i,:) == min(t(i,:)));
    
        if (suma(indice(1)) ~= 0) && (isempty(find(suma == 0, 1)))
            t(i,indice) = -suma(indice);
            suma(indice) = 0;
        end

        if isempty(find(ismember(prueba(1:i-1,:),suma,'rows') == 1,1))
            break;
        end
    end

    prueba(i,:) = suma;
    

    R.WriteSegmentMillis(t(i,:));
    pause(3 * MAX_MILLIS / 1000)
    R.Measure();
    for u = 1:100000000
    end
    
    pos_raw = R.CapturePosition();
    vol_raw = R.getVoltages();
        
%     for n = 1:3
%         vol_raw(n) = 100.0000 - (vol_raw(n) - R.max_min(n,1)) * 100.0000 / (R.max_min(n,2) - R.max_min(n,1));
%     end

    pos(i,:) = pos_raw(2,:);
    vol(i,:) = vol_raw';

    if ~mod(i,SAVE)
        save(strcat('DatasetNN/prueba_BUENA_2_',num2str(i/SAVE)),'pos','vol','t','prueba');
    end

end

        




