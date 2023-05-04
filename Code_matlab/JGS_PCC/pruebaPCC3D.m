%% Modelo PCC en 3D. Basado en Webster2010
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-04-19

close all

%% Definición de parámetros
l1 = 20;
l2 = 30;
l3 = 35;
a = 5;
% l1 = 15;
% l2 = 15;
% l3 = 16;

%% Modelado dependiente
l = (l1 + l2 + l3) / 3;
phi = atan2(sqrt(3) * (-2*l1 + l2 + l3), 3 * (l2 - l3));
kappa = 2 * sqrt(l1^2 + l2^2 + l3^2 - l1*l2 - l3*l2 - l1*l3) / a / (l1 + l2 + l3);
r = 1 / kappa;
theta = kappa * l;

%% Modelado independiente
Trot = [cos(phi) -sin(phi) 0 0; sin(phi) cos(phi) 0 0; 0 0 1 0; 0 0 0 1];
Tarc = [cos(kappa*l) 0 sin(kappa*l) (1-cos(kappa*l))/kappa; 0 1 0 0; -sin(kappa*l) 0 cos(kappa*l) sin(kappa*l)/kappa; 0 0 0 1];
T = Trot*Tarc;
disp(T)
% T tiene la matriz de rotación en sus tres primeras columnas y la
% diferencia entre final e inicio en la última


%% Dibujamos
x = [r*cos(phi), r*sin(phi), 0]';
figure;
[h,c] = circle(x, r, theta, phi);
disp(l);

% Para cada cable
phi_i = -phi + [0 2*pi/3 -2*pi/3];
r_i = r*ones(1,3) - a*sin(phi_i);
x_i = x - a*[sin(phi_i); cos(phi_i); zeros(size(phi_i))];
for j = 1:3
    circle(x_i(:,j), r_i(j), theta, phi, 'r');
end

% Base y extremo
l_i = r_i.*theta;
hold on
s = 0:pi/50:2*pi;
circ = a * [cos(s);sin(s);zeros(size(s))];
plot3(circ(1,:),circ(2,:),circ(3,:),'k')
circ = c(:,end) - a * T(1:3,1:3) * [cos(s);sin(s);zeros(size(s))];
plot3(circ(1,:),circ(2,:),circ(3,:),'k')
hold off

% Cables
hold on
aux = a*[sin(phi_i); -cos(phi_i); zeros(size(phi_i))];
for j = 1:3
    c2 = c + aux(:,j);
    plot3(c2(1,:),c2(2,:),c2(3,:),'g')
end
hold off

fprintf("\n");

%% Funciones auxiliares

function [h,x] = circle(p,r,theta,phi,plotOptions)
    % Función auxiliar para crear arcos de circunferencia con centro en p = (x,y,z),
    % radio r y límite theta en un plano vertical girado phi grados respecto a OZ
    
    % Opciones por defecto
    if nargin < 5
        plotOptions = '';
    end

    % Cogemos dos vectores ortnormales del plano (uno es el propio OZ)
    u = [cos(phi) sin(phi) 0]';
    v = [0 0 1]';

    % Circunferencia
    th = 0:pi/50:theta;
    x = p - u*r*cos(th) - v*r*sin(th);
    
    % Longitud
    L = arclength(x(1,:), x(2,:), x(3,:));
    fprintf("Longitud: %f ", L);

    % Dibujamos
    hold on
    h = plot3(x(1,:), x(2,:), x(3,:), plotOptions);
    hold off
    xlabel('x')
    ylabel('y')
    zlabel('z')
    grid on
    view(120, 25);
    axis equal
end

function R = rotZ(a)
    % Devuelve una matriz de rotación en torno al eje Z de ángulo a
    R = [cos(a) -sin(a) 0; sin(a) cos(a) 0; 0 0 1];
end
