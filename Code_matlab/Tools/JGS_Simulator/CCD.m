%% CCD
% 
% Cyclic Coordinate Descent Algorithm
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-02-14

if ~exist('r', 'var')
    PAUL_setup();
end

% Setup
maxIt = 20;
tol = 1e-3;
goal = [46 -10 -316];
nSegments = r.nValves / 3;
millis_sent = zeros(maxIt, nSegments, 3);

% Algorithm
for i = 1:maxIt

    [p, c1, c2, o2]  = r.Plot(total_millis');

    if norm(p - goal) < tol
        break
    end

    total_millis = zeros(nSegments, 3);
    
    for s = 1:nSegments
        % Key vectors and their angle
        e = p - c2(s,:);
        g = goal - c2(s,:);
        ang = acos(e * g' / norm(e) / norm(g));
        ax = cross(e, g);

        % Rotation
        quat = axang2quat([ax ang]);

        % Sending the pressure
        millis_sent(i,s,:) = [0 0 0];
        sum_times = sum(millis_sent);
        total_millis(s,:) = sum_times(:,:,s);
    end
end
