%% Generate dataset for IK NN
% Based on Thuruthel2017
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-05-13

clear 
close all
if ~exist('r', 'var')
    PAUL_setup();
end

% Setup parameters
nData = 20000;
maxTime = 500;
maxTotTime = 1000;
nValves = 9;
nPos = 9;
times_tot = zeros(1, nValves);
datasetPos = zeros(nData, 2*nPos + nValves);
p = r.GetCompletePosition(times_tot);

% Generating
it = nData;
while it
    disp(it)

    % Generating times
    if it == nData
        times = randBtw(0, maxTime, 1, nValves);
    else
        times = randBtw(-maxTime, maxTime, 1, nValves);
    end
    times_tot = times_tot + times;

    % Ensuring times are inside the limits
    if (any(times_tot > 1000) || any(times_tot < 0))
        times_tot = times_tot - times;
        continue
    end

    % Getting position 
    pos_old = p;
    p = r.GetCompletePosition(times_tot);
    datasetPos(it,:) = [pos_old p times];

    it = it - 1;
end