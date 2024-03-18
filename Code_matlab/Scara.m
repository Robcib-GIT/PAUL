%% Class for Scara robot (tests)
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-02-14

classdef Scara < handle

    properties (Access = public)
        l = 10;
    end
    
    methods
        function [c1, c2, o2] = PlotSegment(this, angles, pos, or)
            switch nargin
                case 4
                    if ~iscolumn(pos)
                        pos = pos';
                    end
                case 3
                    or = [0 0];
                    if ~iscolumn(pos)
                        pos = pos';
                    end
                case 2
                    or = [0 0];
                    pos = [0 0]';
            end
        
            % Kinematics
            RotM = [cos(or) -sin(or);
                    sin(or) cos(or)];
            theta = angles(end);
            T = [cos(theta) -sin(theta) this.l*cos(theta);
                sin(theta) cos(theta) this.l*sin(theta);
                0 0 1];
            c = T(1:2,3);
            c = RotM*c + pos;
            c1 = pos';
            Ang = RotM * T(1:2,1:2);

                
            % Drawing
            axis equal
            hold on
            grid on
    
            plot([c1(1) c(1)], [c1(2) c(2)], '-b')
            plot(c1(1), c1(2), 'or')
            plot(c(1), c(2), 'or')
        
            % Centres of the bases
            c1 = c1';
            c2 = c;
            o2 = wrapTo2Pi(atan2(Ang(2,1), Ang(1,1)));
        end
    
        function [p, c1, c2, o2] = Plot(this, angles)
            
            pos = [0 0];
            o2 = zeros(size(angles, 1) + 1, 1);
            c1 = zeros(size(angles, 1), 2);
            c2 = zeros(size(c1));
    
            % Drawing each segment
            for seg = 1:size(angles, 1)
                [c1(seg,:), c2(seg,:), o2(seg+1,:)] =  this.PlotSegment(angles(seg,:), pos, o2(seg,:));
                pos = c2(seg,:);
            end
    
            % Returning values
            p = c2(end,:);

            % Base
            plot(0, 0, '^r', 'MarkerSize', 10)
        
            % Plot settings
            xlabel('x')
            ylabel('y')
            grid on
        end
    end
end