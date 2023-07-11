MAX_MILLIS = 1200;
N_ITER_MAX = 1000;
SAVE = 100;

pos = zeros(N_ITER_MAX,3);
vol = zeros(N_ITER_MAX,3);
t = zeros(N_ITER_MAX,3);
suma = zeros(1,3);
millis_ant = [0 0 0];


prueba = zeros(N_ITER_MAX,3);


for i = 1:N_ITER_MAX
   
    t(i,:) = -MAX_MILLIS -10 + 10*randi(fix((2*MAX_MILLIS/10 + 1)), [1 3]);

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

    prueba(i,:) = suma;
    

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

        




