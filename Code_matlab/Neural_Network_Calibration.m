MAX_MILLIS = 1200;
N_ITER_MAX = 100;
SAVE = 50;

pos = zeros(N_ITER_MAX,3);
vol = zeros(N_ITER_MAX,3);
t = zeros(N_ITER_MAX,3);
suma = zeros(1,3);
millis_ant = [0 0 0];

for i = 1:N_ITER_MAX
   
    millis = -50 + 50*randi((MAX_MILLIS + 50) / 50, [1 3]);
    t(i,:) = millis - millis_ant;

    if i == 1
        suma = t(i,:);
    else
        suma = suma + t(i,:);
    end

    index = find(suma == MAX_MILLIS);

    if index
        suma(1,index) = suma(1,index) - t(i,index);
        t(i,index) = 0;
    end

    millis_ant = millis;
    

    R.WriteSegmentMillis(t(i,:));
    pause(2 * MAX_MILLIS / 1000)
    R.Measure();
    pause(0.05)

    vol_raw = R.getVoltages();
    pos_raw = R.CapturePosition();
    pos(i,:) = pos_raw(2,:);
    vol(i,:) = vol_raw';

    if ~mod(i,SAVE)
        save(strcat('DatasetNN/prueba_',num2str(i/SAVE)),'pos','vol','t');
    end

end

        




