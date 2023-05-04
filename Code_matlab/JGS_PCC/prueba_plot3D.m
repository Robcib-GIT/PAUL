%% Dibujo en 3D
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-04-19

% Definición de parámetros
a = 3;
r = 10;
theta = 2*pi;

% Círculos
circle(r,0,1,r,theta);

% Función auxiliar para crear arcos de circunferencia con centro en (x,y),
% radio R y límite theta
function h = circle(x,y,z,r,theta)
    hold on
    th = 0:pi/50:theta;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    zunit = th;
    h = plot3(xunit, yunit, zunit);
    hold off
    xlim([0 2*r]);
    ylim([-r r]);
    zlim([0 10]);
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    axis equal
    grid on
    view(60, 25);
    sum(vecnorm(diff([xunit(:),yunit(:)]),2,2))
end