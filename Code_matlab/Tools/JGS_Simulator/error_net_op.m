%% Error of the orientation prediction network
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-03-20

% Setup
limValves = 0:100:1000;
errHist = zeros(length(limValves)^3, 7);

% Loop
it = 0;
for i = limValves
    for j = limValves
        for k = limValves
            it = it + 1;
            [p,~,~,o2] = r.Plot([i j k], false);
            q = r.R*net_op(o2(end,:)');
            errHist(it,:) = [p q' norm(p-q')];
        end
    end
end