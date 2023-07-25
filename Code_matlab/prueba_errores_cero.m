pos_ini = zeros(20,3);
pos_fin = zeros(20,3);
error_pos = zeros(20);
registro = zeros(20);

for j = 1:20
    while 1
        v = randi(1358);
        registro(j) = v;
        if isempty(find(registro(1:j-1) == v,1))
            break
        end
    end

    pos_ini(j,:) = pos(v,:);
    [pos_fin(j,:), error_pos(j)] = R.Move(pos(v,:));
    R.Deflate();
end

save("Pruebas_errores/prueba_2",'error_pos','pos_ini','pos_fin');