for i = 1:20
    errores(i) = norm(error_pos(i)-error_peso(i));
end

mean(errores)

