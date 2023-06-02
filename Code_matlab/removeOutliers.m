%% Remove outliers from traslation matrix
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-06-01

function A = removeOutliers(A, th)
    % Remove outliers from traslation matrix
    %
    % B = removeOutliers(A) returns a matrix B in which values that deviate
    % from the average by more than 2.5mm
    % 
    % B = removeOutliers(A, th) allows to specifiy the desired
    % thershold th in which to mark some data as outlier

    if nargin < 2
        th = 2.5;
    end
    
    m = mean(A);
    for i = 1:size(A,1)
        u = abs (A(i,:) - m);
        for j = 1:length(u)
            if u(j) > th
                A(i,j) = NaN;
            end
        end
    end


end