
            

%yz, xz son las coordenadas de un punto en dos imagenes
% matyz, maxz son dos matrices que contienen los parametros extrinsecos de
% las respectivas camaras. 

%dx,dy e dz distancias medidas segun el sistema viejo

% Si se ha encontrado el punto correctamente
if yz(1) ~= -1 && yz(2) ~= -1 && xz(1) ~= -1 && xz(2) ~= -1

    %obtenemos punto en sistema de coordenadas de la imagen mediante una
    %triangulacion estereo
    point = triangulate(yz,xz,matyz,matxz);
    
    %giramos los ejes para que sean paralelos al sistema del robot
    point_girado(1) = -point(3);
    point_girado(2) = -point(1);
    point_girado(3) = point(2);

    pointReal(1) = point_girado(1) - dx;
    pointReal(2) = point_girado(2) - dy;
    pointReal(3) = point_girado(3) - dz + zoffset;

else
    
    pointReal = [-1, -1, -1];
end








end