function [h,x] = circle(p,r,theta,phi,plotOptions)
    % Auxiliary function to create arcs of a circle with centre at p = (x,y,z),
    % radius r, and boundary theta in a vertical plane rotated phi degrees
    % with respect to OZ
    
    % Default options
    if nargin < 5
        plotOptions = '';
        h = '';
    end

    % We take two orthonormal vectors of the plane (one is the OZ itself).
    u = [cos(phi) sin(phi) 0]';
    v = [0 0 1]';

    % Circunference
    th = 0:pi/5000:theta;
    x = p - u*r*cos(th) - v*r*sin(th);
    
    % Length
    L = arclength(x(1,:), x(2,:), x(3,:));
    %fprintf("Longitud: %f ", L);

    % Plotting
    if plotOptions
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
end