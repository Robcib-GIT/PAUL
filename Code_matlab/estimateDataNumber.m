%% Estimate number of data for training NN

% alphaRange = 0:100:700;
% T = zeros(length(alphaRange),3);
% for alpha = alphaRange
%     [p1, p2] = r.NN_training(pos(1:end-alpha,:), vol(1:end-alpha,:), t(1:end-alpha,:), 275, 250);
%     T(alpha+1,:) = [alpha, p1, p2];
% end

NData = 300:100:700;
NeurPT = [10 25 50 75];
NeurVT = [10 25 50 75];

T = [];
for n = NData
    disp(n)
    for p = NeurPT
        for v = NeurVT
            r.NN_training(pos(1:n,:), vol(1:n,:), t(1:n,:), p, v);
            p1 = perform(r.net_pt, t(700:end,:)', r.net_pt(pos(700:end,:)'));
            p2 = perform(r.net_vt, t(700:end,:)', r.net_vt(vol(700:end,:)'));
            T(end+1,:) = [n p v p1 p2];
        end
    end
end