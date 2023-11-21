function [rotm,euler] = getRotations(r,g, b)

if r(1) == -1 || r(2) == -1 || r(3) == -1 ||   g(1) == -1 || g(2) == -1 || g(3) == -1 ||   b(1) == -1 || b(2) == -1 || b(3) == -1
    euler = [-1 -1 -1];
    rotm = [-1 -1 -1 ; -1 -1 -1 ; -1 -1 -1];
else
    gv = [g(1), g(2), g(3)];
    rv = [r(1), r(2), r(3)];
    bv = [b(1), b(2), b(3)];

    % Calculamos vectores directores del sistema movil
    xr = rv - gv ;
    xr = xr / norm(xr);
    yr = bv - gv;
    yr = yr / norm(yr);

    % Calculamos matriz rotacion
    v = cross(xr,yr);
    ssc = [0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];
    rotm = eye(3) + ssc + ssc^2*(1-dot(xr,yr))/(norm(v))^2;

    % Pasamos a angulos de Euler
    euler = rotm2eul(rotm);

    
end

end