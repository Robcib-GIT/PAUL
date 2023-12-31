%% Look for the nearest values in 
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-11-15

function result = TableKinematics(table, point, mode)
    % Inverse or Direct kinematics
    if mode == 'D'
        points = table(:,1:3);
        results = table(:,4:6);
    else
        points = table(:,4:6);
        results = table(:,1:3);
    end

    % Calculate Euclidean distances between 'point' and each row in 'table'
    distances = sqrt(sum((points- point).^2, 2));
    
    % Find the indices of the three rows with the smallest distances
    [sortedDistances, indices] = sort(distances);
    nearestDists = sortedDistances(1:3);
    nearestResults = results(indices(1:3),:);

    % Checking the point is not in the table
    if nearestDists(1) < 1e-5
        result = points(indices(1));
        return
    end

    % Averaging the distance to get the result
    weights = 1 ./ nearestDists;


    result = weights' * nearestResults / sum(weights);
end
