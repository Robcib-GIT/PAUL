%% Modelo PCC en 2D. Prueba de las fórmulas de PCC 2D.pdf 
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-04-19

% Definición de parámetros
a = 3;
r = 10;
theta = 2*pi;

% Parámetros derivados
l = r * theta;
l1 = theta * (r-a);
l2 = theta * (r+a);

% Comprobaciones
disp ((l1+l2) * a / (l2-l1))

% Dibujo de los círculos
disp(l1);
circle(r,0,r-a,theta);
disp(l);
circle(r,0,r,theta);
disp(l2);
circle(r,0,r+a,theta);

% Función auxiliar para crear arcos de circunferencia con centro en (x,y),
% radio R y límite theta
function h = circle(x,y,r,theta)
    hold on
    axis equal
    th = 0:-pi/50:-theta;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    h = plot(xunit, yunit);
    hold off
    sum(vecnorm(diff([xunit(:),yunit(:)]),2,2))
end