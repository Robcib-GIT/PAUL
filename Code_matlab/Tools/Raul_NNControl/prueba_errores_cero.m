N_PUNTOS = 30;

pos_ini = zeros(N_PUNTOS,3);
pos_fin = zeros(N_PUNTOS,3);
error_pos = zeros(N_PUNTOS,1);
registro = zeros(N_PUNTOS,1);

for j = 1:N_PUNTOS
    while 1
        v = randi(1300);
        registro(j) = v;
        if isempty(find(registro(1:j-1) == v,1))
            break
        end
    end

    pos_ini(j,:) = pos(v,:);
    [pos_fin(j,:), error_pos(j)] = R.Move(pos(v,:));
    R.Deflate();
end

save("Pruebas_errores/prueba_pesode1_1",'error_pos','pos_ini','pos_fin');