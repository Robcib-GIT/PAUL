N_PUNTOS = 20;

pos_fin = zeros(N_PUNTOS,3);
error_pos = zeros(N_PUNTOS,1);

for j = 1:N_PUNTOS
    [pos_fin(j,:), error_pos(j)] = R.Move(pos_ini(j,:));
    R.Deflate();
end

save("Pruebas_errores/prueba_pesode2_2",'error_pos','pos_ini','pos_fin');