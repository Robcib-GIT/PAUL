MAX_MILLIS = 900;
N_ITER_MAX = 2000;
SAVE = 100;
RESET = 200;
% 
% pos = zeros(N_ITER_MAX,3);
% vol = zeros(N_ITER_MAX,3);
% t = zeros(N_ITER_MAX,3);
% 
% R.Measure();
% for u = 1:100000000
% end
%     
% pos_raw = R.CapturePosition();
% vol_raw = R.getVoltages();
% pos(1,:) = pos_raw(2,:);
% vol(1,:) = vol_raw';

for i = 973:N_ITER_MAX
   
    while 1

        t(i,:) = -25 + 25*randi(fix((MAX_MILLIS/25 + 1)), [1 3]);
    
        indice = find(t(i,:) == min(t(i,:)));
    
        if (t(i,indice(1)) ~= 0) && (isempty(find(t(i,:) == 0, 1)))
            t(i,indice(1)) = 0;
        end

        if isempty(find(ismember(t(i,:),t(1:i-1,:),'rows') == 1,1))
            break;
        end
    end
    

    R.WriteSegmentMillis(t(i,:));
    pause(2 * MAX_MILLIS / 1000)
    R.Measure();
    for u = 1:100000000
    end
    
    pos_raw = R.CapturePosition();
    vol_raw = R.getVoltages();

    pos(i,:) = pos_raw(2,:);
    vol(i,:) = vol_raw';

    if ~mod(i,SAVE)
        save(strcat('DatasetNN/prueba_DEF_',num2str(i/SAVE)),'pos','vol','t');
    end
    
    R.Deflate();
    pause(1)

end