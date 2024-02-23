%% Plot Segment
%
% Plot one segment of PAUL and its bases, assuming the PCC model hypothesis
% with base at pos and orientation or
%
% [c1, c2, o2] = PlotSegment(r, times) plots a segment for robot r (PAUL type) and
% bladders infated during times (in milliseconds). It returns the centres
% of the circles of the base and the bottom and the orientation of the
% bottom, in Euler angles
% 
% [c1, c2, o2] = PlotSegment(r, times, pos, or) locates the base at position pos and
% rotates it an orientation or
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-11-21

function [c1, c2, o2] = PlotSegment(r, times_obj, pos, or)

    switch nargin
        case 4
            if ~iscolumn(pos)
                pos = pos';
            end
        case 3
            or = [0 0 0];
            if ~iscolumn(pos)
                pos = pos';
            end
        case 2
            or = [0 0 0];
            pos = [0 0 0]';
    end

    % Kinematics
    a = r.geom.radius;
    R = eul2rotm(or);

    pos_obj = r.net_tpv(times_obj');
    [l, ~] = r.MCI(r.R * pos_obj(1:3));
    [T, params] = r.MCD(l, a);

    rho = 1 / params.kappa;
    theta = params.kappa * params.lr;
        
    % Drawing
    axis equal
    hold on
    grid on

    x = [rho*cos(params.phi), rho*sin(params.phi), 0]';
    [~,c] = circle(x, rho, theta, params.phi);
    c = R*c + pos;
    plot3(c(1,:), c(2,:), c(3,:));
    
    % Base and final
    s = 0:pi/50:2*pi;
    circ = a * [cos(s);sin(s);zeros(size(s))];
    circ = R*circ + pos;
    plot3(circ(1,:),circ(2,:),circ(3,:),'k')

    circ = c(:,end) - a * R * T(1:3,1:3) * [cos(s);sin(s);zeros(size(s))];
    plot3(circ(1,:),circ(2,:),circ(3,:),'k')

    hold off

    % Centres of the bases
    c1 = c(:,1);
    c2 = c(:,end);
    o2 = rotm2eul(R*T(1:3,1:3));

end